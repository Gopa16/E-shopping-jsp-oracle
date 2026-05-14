<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Fetch the admin's name from session
    String adminName = (String) session.getAttribute("name");
    if (adminName == null) {
        // If no session, redirect to login
        response.sendRedirect("login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard</title>
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: #f4f4f4;
    }
    .navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: #333;
      padding: 10px 20px;
      color: #fff;
    }
    .navbar .left {
      display: flex;
      gap: 20px;
    }
    .navbar a {
      color: #fff;
      text-decoration: none;
      font-weight: bold;
    }
    .navbar a:hover {
      text-decoration: underline;
    }
    .navbar .right {
      font-weight: bold;
    }
    .options {
      display: flex;
      justify-content: center;
      margin-top: 50px;
      gap: 30px;
    }
    .options a {
      display: block;
      padding: 20px;
      background: #fff;
      border: 1px solid #ccc;
      border-radius: 8px;
      text-align: center;
      width: 150px;
      text-decoration: none;
      color: #333;
      font-weight: bold;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      transition: 0.3s;
    }
    .options a:hover {
      background: #333;
      color: #fff;
    }
  </style>
</head>
<body>
  <div class="navbar">
    <div class="left">
      <a href="AdminDashboard.jsp">Home</a>
      <a href="logout">Logout</a>
    </div>
    <div class="right">
      Welcome, <%= adminName %>
    </div>
  </div>

  <div class="options">
    <a href="AddProduct.html">Add Product</a>
    <a href="viewProducts">View Products</a>
    <a href="UpdateProductServlet">Update Product</a>
    <a href="deleteProduct.html">Delete Product</a>
     <a href="adminOrders.jsp">View Orders</a>
  </div>
</body>
</html>
