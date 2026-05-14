<%@ page import="java.sql.*" %>
<%
    String userName = (String) session.getAttribute("name");
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.html");
        return;
    }

    String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe";
    String jdbcUsername = "system";
    String jdbcPassword = "manager";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
  <title>Your Cart</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f4f4f4;
      margin: 0;
      padding: 20px;
    }
    h2 {
      text-align: center;
      margin-bottom: 20px;
      color: #333;
    }
    table {
      width: 85%;
      margin: auto;
      border-collapse: collapse;
      background: #fff;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    th, td {
      padding: 12px 15px;
      text-align: center;
      border-bottom: 1px solid #ddd;
    }
    th {
      background: #333;
      color: #fff;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    tr:hover {
      background: #f1f1f1;
    }
    td {
      color: #555;
    }
    .price {
      font-weight: bold;
      color: #2a9d8f;
    }
    .btn-remove {
      background: #e63946;
      color: #fff;
      padding: 6px 12px;
      border-radius: 4px;
      text-decoration: none;
      margin-right: 5px;
    }
    .btn-remove:hover {
      background: #c1121f;
    }
    .btn-order {
      background: #2a9d8f;
      color: #fff;
      padding: 6px 12px;
      border-radius: 4px;
      text-decoration: none;
    }
    .btn-order:hover {
      background: #21867a;
    }
  </style>
</head>
<body>
  <h2>Cart for <%= userName %></h2>
  <table>
    <tr>
      <th>Product</th>
      <th>Category</th>
      <th>Price</th>
      <th>Quantity</th>
      <th>Actions</th>
    </tr>
    <%
      try {
          Class.forName("oracle.jdbc.driver.OracleDriver");
          con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

          String sql = "SELECT p.name, p.category, p.price, c.quantity, c.cart_id " +
                       "FROM cart c JOIN products p ON c.product_id = p.id " +
                       "WHERE c.user_id=? AND c.status='active'";
          ps = con.prepareStatement(sql);
          ps.setInt(1, userId);
          rs = ps.executeQuery();

          boolean hasItems = false;
          while (rs.next()) {
              hasItems = true;
    %>
            <tr>
              <td><%= rs.getString("name") %></td>
              <td><%= rs.getString("category") %></td>
              <td class="price"><%= rs.getDouble("price") %></td>
              <td><%= rs.getInt("quantity") %></td>
              <td>
                <a class="btn-remove" href="removeFromCart?id=<%= rs.getInt("cart_id") %>">Remove</a>
                <a class="btn-order" href="placeOrder?cartId=<%= rs.getInt("cart_id") %>">Place Order</a>
              </td>
            </tr>
    <%
          }
          if (!hasItems) {
              out.println("<tr><td colspan='5'>Your cart is empty.</td></tr>");
          }
      } catch (Exception e) {
          out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
      } finally {
          try { if (rs != null) rs.close(); } catch (Exception ignored) {}
          try { if (ps != null) ps.close(); } catch (Exception ignored) {}
          try { if (con != null) con.close(); } catch (Exception ignored) {}
      }
    %>
  </table>
</body>
</html>
