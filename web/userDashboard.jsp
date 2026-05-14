<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if user is logged in
    String userName = (String) session.getAttribute("name");
    if (userName == null) {
        response.sendRedirect("login.html");
        return;
    }

    // Database connection
    String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe";
    String jdbcUsername = "system";
    String jdbcPassword = "manager";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>User Dashboard</title>
  <style>
    body { margin:0; font-family:Arial,sans-serif; background:#f4f4f4; }
    .navbar {
      display:flex; justify-content:space-between; align-items:center;
      background:#333; padding:10px 20px; color:#fff;
    }
    .navbar .left a {
      color:#fff; text-decoration:none; font-weight:bold; margin-right:20px;
    }
    .navbar .left a:hover { text-decoration:underline; }
    .navbar .center { font-weight:bold; }
    .products { display:flex; flex-wrap:wrap; gap:20px; padding:20px; }
    .category { width:100%; font-size:20px; margin:20px 0 10px; font-weight:bold; }
    .card {
      background:#fff; border:1px solid #ccc; border-radius:8px;
      width:200px; padding:15px; box-shadow:0 2px 5px rgba(0,0,0,0.1);
      text-align:center;
    }
    .card a { text-decoration:none; color:#333; font-weight:bold; }
    .card a:hover { color:#000; }
  </style>
</head>
<body>
  <div class="navbar">
    <div class="left">
      <a href="userDashboard.jsp">Home</a>
      <a href="cart.jsp">Cart</a>
      <a href="myOrders.jsp">My orders</a>
      <a href="logout">Logout</a>
    </div>
    <div class="center">
      Welcome, <%= userName %>
    </div>
  </div>

  <div class="products">
    <%
      try {
          Class.forName("oracle.jdbc.driver.OracleDriver");
          con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

          // Fetch products grouped by category
          String sql = "SELECT category, name, price, id FROM products ORDER BY category";
          ps = con.prepareStatement(sql);
          rs = ps.executeQuery();

          String currentCategory = "";
          while (rs.next()) {
              String category = rs.getString("category");
              String productName = rs.getString("name");
              double price = rs.getDouble("price");
              int id = rs.getInt("id");

              if (!category.equals(currentCategory)) {
                  currentCategory = category;
    %>
                  <div class="category"><%= category %></div>
    <%
              }
    %>
              <div class="card">
                <a href="productDetails.jsp?id=<%= id %>">
                  <%= productName %><br>₹<%= price %>
                </a>
              </div>
    <%
          }
      } catch (Exception e) {
          out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
      } finally {
          try { if (rs != null) rs.close(); } catch (Exception ignored) {}
          try { if (ps != null) ps.close(); } catch (Exception ignored) {}
          try { if (con != null) con.close(); } catch (Exception ignored) {}
      }
    %>
  </div>
</body>
</html>
