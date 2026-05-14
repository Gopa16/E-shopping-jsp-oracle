<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String idStr = request.getParameter("id");
    if (idStr == null) {
        response.sendRedirect("userDashboard.jsp");
        return;
    }

    int id = Integer.parseInt(idStr);

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
  <title>Product Details</title>
  <style>
    body { font-family:Arial,sans-serif; background:#f4f4f4; padding:40px; }
    .details {
      background:#fff; padding:20px; border-radius:8px;
      box-shadow:0 2px 5px rgba(0,0,0,0.1); width:400px; margin:auto;
    }
    h2 { margin-bottom:15px; }
    .btn {
      display:inline-block; margin-top:20px; padding:10px 20px;
      background:#333; color:#fff; text-decoration:none; border-radius:4px;
    }
    .btn:hover { background:#555; }
  </style>
</head>
<body>
  <div class="details">
    <%
      try {
          Class.forName("oracle.jdbc.driver.OracleDriver");
          con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

          String sql = "SELECT category, name, price FROM products WHERE id=?";
          ps = con.prepareStatement(sql);
          ps.setInt(1, id);
          rs = ps.executeQuery();

          if (rs.next()) {
    %>
            <h2><%= rs.getString("name") %></h2>
            <p><strong>Category:</strong> <%= rs.getString("category") %></p>
            <p><strong>Price:</strong> ₹<%= rs.getDouble("price") %></p>
            <a class="btn" href="addToCart?id=<%= id %>">Add to Cart</a>
    <%
          } else {
              out.println("<p>Product not found.</p>");
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
