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
  <title>My Orders</title>
  <style>
    body { font-family: Arial, sans-serif; background:#f4f4f4; padding:20px; }
    h2 { text-align:center; margin-bottom:20px; color:#333; }
    table {
      width:80%; margin:auto; border-collapse:collapse; background:#fff;
      box-shadow:0 2px 8px rgba(0,0,0,0.1);
    }
    th, td { padding:12px; border:1px solid #ddd; text-align:center; }
    th { background:#333; color:#fff; text-transform:uppercase; }
    tr:hover { background:#f1f1f1; }
    td { color:#555; }
  </style>
</head>
<body>
  <h2>My Orders (<%= userName %>)</h2>
  <table>
    <tr>
      <th>Order ID</th>
      <th>Product Name</th>
      <th>Order Date</th>
    </tr>
    <%
      try {
          Class.forName("oracle.jdbc.driver.OracleDriver");
          con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

          String sql = "SELECT order_id, product_name, order_date FROM orders WHERE user_id=? ORDER BY order_date DESC";
          ps = con.prepareStatement(sql);
          ps.setInt(1, userId);
          rs = ps.executeQuery();

          boolean hasOrders = false;
          while (rs.next()) {
              hasOrders = true;
    %>
            <tr>
              <td><%= rs.getInt("order_id") %></td>
              <td><%= rs.getString("product_name") %></td>
              <td><%= rs.getDate("order_date") %></td>
            </tr>
    <%
          }
          if (!hasOrders) {
              out.println("<tr><td colspan='3'>You have no orders yet.</td></tr>");
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
