<%@ page import="javax.servlet.http.*,javax.servlet.*" language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("mobile") == null) {
        response.sendRedirect("login.html"); // redirect if not logged in
        return;
    }

    String userName = (String) session.getAttribute("name");
    String userMobile = (String) session.getAttribute("mobile");
    String userEmail = (String) session.getAttribute("email");
    String userAddress = (String) session.getAttribute("address");

    // Product details passed via request attributes (from servlet)
    String productName = (String) request.getAttribute("name");
    String productPrice = (String) request.getAttribute("price");
    String productImage = (String) request.getAttribute("image");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Product Details</title>
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background-color: #f9f3e6; /* light cream */
      color: #4b2e2e;
    }

    /* Top Navbar */
    .navbar {
      background-color: #d2a679; /* light brown */
      border-bottom: 2px solid #8b4513;
      padding: 15px 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      position: relative;
    }

    /* E-SHOP Logo Center */
    .navbar-center {
      position: absolute;
      left: 50%;
      transform: translateX(-50%);
    }

    .navbar-center a {
      color: #2d1d1d;
      text-decoration: none;
      font-weight: bold;
      font-size: 28px;
    }

    .welcome {
      font-size: 14px;
      font-weight: normal;
      color: #2d1d1d;
    }

    .logout a {
      font-size: 18px;
      font-weight: bold;
      color: #2d1d1d;
      text-decoration: none;
    }

    .logout a:hover {
      text-decoration: underline;
    }

    /* Heading */
    .heading {
      text-align: center;
      margin: 20px 0;
      font-size: 26px;
      font-weight: bold;
      color: #4b2e2e;
    }

    /* Layout */
    .container {
      display: flex;
      justify-content: space-around;
      padding: 30px;
      width: auto;
    }
    .left, .right {
      background: #fff;
      border: 2px solid #a0522d;
      border-radius: 12px;
      padding: 20px;
      width: 35%;
    }

    /* Left (Product) */
    .left img {
      width: 100%;
      height: 300px;
      object-fit: contain;
      border-radius: 8px;
    }
    .left h2 {
      margin: 15px 0 5px;
    }
    .left h3 {
      margin: 5px 0;
      color: #4b2e2e;
    }

    /* Right (User + Payment) */
    .right h3 {
      margin-bottom: 10px;
      color: #4b2e2e;
    }
    .details p {
      margin: 6px 0;
    }
    .payment {
      margin-top: 20px;
    }
    .payment label {
      margin-right: 15px;
    }
    .confirm-btn {
      margin-top: 20px;
      padding: 10px 20px;
      background-color: #d2a679;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-weight: bold;
    }
    .confirm-btn:hover {
      background-color: #a0522d;
      color: #fff;
    }
  </style>
</head>
<body>

  <div class="navbar">
    <div class="welcome">
      Welcome, <%= userName %>
    </div>

    <div class="navbar-center">
      <a href="webpage2.jsp">E-SHOP</a>
    </div>

    <div class="logout">
      <a href="logout">Logout</a>
    </div>
</div>
  <!-- Page Heading -->
  <div class="heading">PRODUCT DETAILS</div>

  <!-- Main Layout -->
  <div class="container">

    <!-- Left: Product Info -->
    <div class="left">
      <img src="<%= productImage %>" alt="<%= productName %>">
      <h2><%= productName %></h2>
      <h3>Price: ₹<%= productPrice %></h3>
    </div>

    <!-- Right: User Info + Checkout -->
    <div class="right">
      <h3>User Details</h3>
      <div class="details">
        <p><b>Name:</b> <%= userName %></p>
        <p><b>Mobile:</b> <%= userMobile %></p>
        <p><b>Email:</b> <%= userEmail %></p>
        <p><b>Address:</b> <%= userAddress %></p>
      </div>

      <h3>Total Amount: ₹<%= productPrice %></h3>

      <div class="payment">
        <h3>Payment Mode</h3>
        <label><input type="radio" name="payment" value="COD" checked> Cash on Delivery</label>
        <label><input type="radio" name="payment" value="UPI"> UPI</label>
      </div>

      <form action="ProductServlet" method="post">
        <input type="hidden" name="name" value="<%= productName %>">
        <input type="hidden" name="price" value="<%= productPrice %>">
        <input type="hidden" name="image" value="<%= productImage %>">
        <input type="hidden" name="action" value="confirmOrder">
        <input type="submit" value="Confirm Order"class="confirm-btn">
      </form>
    </div>

  </div>

</body>
</html>