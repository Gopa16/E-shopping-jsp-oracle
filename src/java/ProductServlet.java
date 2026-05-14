import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class ProductServlet extends HttpServlet {

    private String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe"; 
    private String jdbcUsername = "system";   // replace with your Oracle username
    private String jdbcPassword = "manager";  // replace with your Oracle password

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Connect to DB
            Connection con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            // Query products
            String sql = "SELECT id, name, category, price, image FROM products";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            // Build HTML output
            out.println("<html><head><title>Product List</title></head><body>");
            out.println("<h2>Available Products</h2>");
            out.println("<table border='1' cellpadding='10'>");
            out.println("<tr><th>ID</th><th>Name</th><th>Category</th><th>Price</th><th>Image</th></tr>");

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String category = rs.getString("category");
                double price = rs.getDouble("price");
                String image = rs.getString("image");

                out.println("<tr>");
                out.println("<td>" + id + "</td>");
                out.println("<td>" + name + "</td>");
                out.println("<td>" + category + "</td>");
                out.println("<td>" + price + "</td>");
                out.println("<td><img src='" + image + "' width='100'></td>");
                out.println("</tr>");
            }

            out.println("</table>");
            out.println("</body></html>");

            rs.close();
            stmt.close();
            con.close();

        } catch (Exception e) {
            out.println("<h2>Error: " + e.getMessage() + "</h2>");
            e.printStackTrace(out);
        }
    }
}
