import os
from flask import Flask, render_template, request, redirect, session
from db import get_connection

base_dir = os.path.dirname(os.path.abspath(__file__))
template_dir = os.path.join(base_dir, "..", "frontend", "templates")
static_dir = os.path.join(base_dir, "..", "frontend", "static")

app = Flask(__name__, template_folder=template_dir, static_folder=static_dir)
app.secret_key = "change_this_secret_key"

@app.route("/")
def home():
    search_query = request.args.get("q", "")
    selected_category = request.args.get("category", "")
    selected_sort = request.args.get("sort", "")

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    query = """
        SELECT p.product_id, p.product_name, p.price, p.category_id, c.category_name, i.quantity
        FROM PRODUCT p
        JOIN CATEGORY c ON p.category_id = c.category_id
        JOIN INVENTORY i ON p.product_id = i.product_id
        WHERE 1=1
    """
    params = []

    if search_query:
        query += " AND p.product_name LIKE %s"
        params.append(f"%{search_query}%")

    if selected_category:
        query += " AND p.category_id = %s"
        params.append(selected_category)

    if selected_sort == "price_asc":
        query += " ORDER BY p.price ASC"
    elif selected_sort == "price_desc":
        query += " ORDER BY p.price DESC"
    elif selected_sort == "name_asc":
        query += " ORDER BY p.product_name ASC"

    cursor.execute(query, params)
    products = cursor.fetchall()

    cursor.execute("SELECT * FROM CATEGORY")
    categories = cursor.fetchall()

    cursor.close()
    conn.close()
    return render_template(
        "products.html",
        products=products,
        categories=categories,
        search_query=search_query,
        selected_category=selected_category,
        selected_sort=selected_sort
    )

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            "SELECT * FROM CUSTOMER WHERE email = %s AND password = %s",
            (email, password)
        )
        customer = cursor.fetchone()
        cursor.close()
        conn.close()
        if customer:
            session["customer_id"] = customer["customer_id"]
            session["customer_name"] = customer["name"]
            return redirect("/")
        else:
            return render_template("login.html", error="Invalid email or password")
    return render_template("login.html")

@app.route("/logout")
def logout():
    session.clear()
    return redirect("/login")

def get_or_create_cart(customer_id, cursor, conn):
    cursor.execute("SELECT cart_id FROM CART WHERE customer_id = %s", (customer_id,))
    row = cursor.fetchone()
    if row:
        return row["cart_id"]
    cursor.execute("INSERT INTO CART (customer_id) VALUES (%s)", (customer_id,))
    conn.commit()
    return cursor.lastrowid

def get_cart_items(customer_id, cursor):
    cursor.execute("""
        SELECT ci.cart_item_id, ci.product_id, p.product_name, p.price, ci.quantity,
               (p.price * ci.quantity) AS subtotal
        FROM CART_ITEM ci
        JOIN CART c ON ci.cart_id = c.cart_id
        JOIN PRODUCT p ON ci.product_id = p.product_id
        WHERE c.customer_id = %s
    """, (customer_id,))
    return cursor.fetchall()

@app.route("/add_to_cart/<int:product_id>", methods=["POST"])
def add_to_cart(product_id):
    if "customer_id" not in session:
        return redirect("/login")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cart_id = get_or_create_cart(session["customer_id"], cursor, conn)
    cursor.execute(
        "SELECT * FROM CART_ITEM WHERE cart_id = %s AND product_id = %s",
        (cart_id, product_id)
    )
    existing = cursor.fetchone()
    if existing:
        cursor.execute(
            "UPDATE CART_ITEM SET quantity = quantity + 1 WHERE cart_item_id = %s",
            (existing["cart_item_id"],)
        )
    else:
        cursor.execute(
            "INSERT INTO CART_ITEM (cart_id, product_id, quantity) VALUES (%s, %s, 1)",
            (cart_id, product_id)
        )
    conn.commit()
    cursor.close()
    conn.close()
    return redirect("/")

@app.route("/cart")
def view_cart():
    if "customer_id" not in session:
        return redirect("/login")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cart_items = get_cart_items(session["customer_id"], cursor)
    total = sum(item["subtotal"] for item in cart_items)
    cursor.close()
    conn.close()
    return render_template("cart.html", cart_items=cart_items, total=total)

@app.route("/remove_from_cart/<int:cart_item_id>", methods=["POST"])
def remove_from_cart(cart_item_id):
    if "customer_id" not in session:
        return redirect("/login")
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM CART_ITEM WHERE cart_item_id = %s", (cart_item_id,))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect("/cart")

@app.route("/checkout", methods=["POST"])
def checkout():
    if "customer_id" not in session:
        return redirect("/login")
    customer_id = session["customer_id"]
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    items = get_cart_items(customer_id, cursor)
    if not items:
        cursor.close()
        conn.close()
        return redirect("/cart")
    total = sum(item["subtotal"] for item in items)
    try:
        cursor.execute(
            "INSERT INTO CUSTOMER_ORDER (customer_id, total_amount, order_status) VALUES (%s, %s, 'CONFIRMED')",
            (customer_id, total)
        )
        order_id = cursor.lastrowid
        for item in items:
            cursor.execute(
                "INSERT INTO ORDER_ITEM (order_id, product_id, quantity, price_at_purchase) VALUES (%s, %s, %s, %s)",
                (order_id, item["product_id"], item["quantity"], item["price"])
            )
        cursor.execute(
            "INSERT INTO PAYMENT (order_id, payment_method, payment_status, amount) VALUES (%s, 'COD', 'SUCCESS', %s)",
            (order_id, total)
        )
        cursor.execute("SELECT address FROM CUSTOMER WHERE customer_id = %s", (customer_id,))
        address = cursor.fetchone()["address"]
        cursor.execute(
            "INSERT INTO DELIVERY (order_id, delivery_address, delivery_status) VALUES (%s, %s, 'PROCESSING')",
            (order_id, address)
        )
        cursor.execute("""
            DELETE ci FROM CART_ITEM ci
            JOIN CART c ON ci.cart_id = c.cart_id
            WHERE c.customer_id = %s
        """, (customer_id,))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(f"/order_success/{order_id}?total={total}")
    except Exception as e:
        conn.rollback()
        cursor2 = conn.cursor(dictionary=True)
        cart_items = get_cart_items(customer_id, cursor2)
        total = sum(item["subtotal"] for item in cart_items)
        cursor2.close()
        conn.close()
        return render_template("cart.html", cart_items=cart_items, total=total, error=str(e))

@app.route("/my_orders")
def my_orders():
    if "customer_id" not in session:
        return redirect("/login")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        "SELECT * FROM CUSTOMER_ORDER WHERE customer_id = %s ORDER BY order_date DESC",
        (session["customer_id"],)
    )
    orders = cursor.fetchall()
    for order in orders:
        cursor.execute(
            "SELECT product_name, quantity, price_at_purchase FROM ORDER_ITEM oi JOIN PRODUCT p ON oi.product_id = p.product_id WHERE order_id = %s",
            (order["order_id"],)
        )
        order["order_items"] = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template("my_orders.html", orders=orders)

@app.route("/order_success/<int:order_id>")
def order_success(order_id):
    total = request.args.get("total")
    return render_template("order_success.html", order_id=order_id, total=total)

@app.route("/admin")
def admin_dashboard():
    if session.get("customer_id") != 1:
        return redirect("/login")

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.callproc("sp_top_selling_products", [5])
    top_products = []
    for result in cursor.stored_results():
        top_products = result.fetchall()

    cursor.execute("SELECT * FROM vw_low_stock")
    low_stock = cursor.fetchall()

    cursor.execute("""
        SELECT c.category_name, COALESCE(SUM(oi.quantity * oi.price_at_purchase), 0) AS revenue
        FROM CATEGORY c
        LEFT JOIN PRODUCT p ON c.category_id = p.category_id
        LEFT JOIN ORDER_ITEM oi ON p.product_id = oi.product_id
        GROUP BY c.category_name
    """)
    category_revenue = cursor.fetchall()

    cursor.execute("""
        SELECT o.order_id, cu.name, o.total_amount, o.order_status, o.order_date
        FROM CUSTOMER_ORDER o
        JOIN CUSTOMER cu ON o.customer_id = cu.customer_id
        ORDER BY o.order_date DESC
        LIMIT 10
    """)
    recent_orders = cursor.fetchall()

    cursor.execute("SELECT customer_id, name FROM CUSTOMER")
    all_customers = cursor.fetchall()
    top_customers = []
    for c in all_customers:
        cursor.execute("SELECT fn_customer_total_spent(%s) AS total_spent", (c["customer_id"],))
        total = cursor.fetchone()["total_spent"]
        top_customers.append({"name": c["name"], "total_spent": total})
    top_customers = sorted(top_customers, key=lambda x: x["total_spent"], reverse=True)[:5]

    cursor.close()
    conn.close()
    return render_template(
        "admin_dashboard.html",
        top_products=top_products,
        low_stock=low_stock,
        category_revenue=category_revenue,
        recent_orders=recent_orders,
        top_customers=top_customers
    )

if __name__ == "__main__":
    app.run(debug=True)