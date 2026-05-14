<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>All Orders</title>
  <style>
    body { font-family: Arial, sans-serif; background:#f4f4f4; padding:20px; }
    h2 { text-align:center; margin-bottom:20px; }
    table { width:80%; margin:auto; border-collapse:collapse; background:#fff; }
    th, td { padding:12px; border:1px solid #ddd; text-align:center; }
    th { background:#333; color:#fff; }
  </style>
</head>
<body>
  <h2>All Orders</h2>
  <table>
    <tr>
      <th>Order ID</th>
      <th>User ID</th>
      <th>Product Name</th>
      <th>Order Date</th>
    </tr>
    <%
      try {
          Class.forName("oracle.jdbc.driver.OracleDriver");
          Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","system","manager");
          PreparedStatement ps = con.prepareStatement("SELECT * FROM orders ORDER BY order_date DESC");
          ResultSet rs = ps.executeQuery();
          while (rs.next()) {
    %>
            <tr>
              <td><%= rs.getInt("order_id") %></td>
              <td><%= rs.getInt("user_id") %></td>
              <td><%= rs.getString("product_name") %></td>
              <td><%= rs.getDate("order_date") %></td>
            </tr>
    <%
          }
          rs.close(); ps.close(); con.close();
      } catch (Exception e) {
          out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
      }
    %>
  </table>
</body>
</html>
