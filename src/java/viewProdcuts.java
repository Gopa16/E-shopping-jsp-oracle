 import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
 import javax.servlet.annotation.WebServlet;

@WebServlet("/viewProducts")
public class viewProdcuts extends HttpServlet {

   


    

    private String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe";
    private String jdbcUsername = "system";   // replace with your Oracle username
    private String jdbcPassword = "manager";  // replace with your Oracle password

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            String sql = "SELECT id, name, category, price, image FROM products";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            out.println("<html>");
            out.println("<head>");
            out.println("<title>View Products</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; background: #f4f4f4; margin: 0; padding: 20px; }");
            out.println("h2 { text-align: center; margin-bottom: 20px; }");
            out.println("table { width: 90%; margin: 0 auto; border-collapse: collapse; background: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }");
            out.println("th, td { padding: 12px; text-align: center; border-bottom: 1px solid #ddd; }");
            out.println("th { background: #333; color: #fff; }");
            out.println("tr:hover { background-color: #f1f1f1; }");
            out.println("img { border-radius: 6px; }");
            out.println(".btn { padding: 6px 12px; margin: 2px; border: none; border-radius: 4px; cursor: pointer; }");
            out.println(".edit { background-color: #4CAF50; color: white; }");
            out.println(".delete { background-color: #f44336; color: white; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h2>Product List</h2>");
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Name</th><th>Category</th><th>Price</th><th>Image</th><th>Actions</th></tr>");

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
                out.println("<td>");
                out.println("<form action='UpdateProductServlet' method='get' style='display:inline;'>");
                out.println("<input type='hidden' name='id' value='" + id + "'>");
                out.println("<input type='submit' value='Edit' class='btn edit'>");
                out.println("</form>");
                out.println("<form action='deleteProduct' method='post' style='display:inline;'>");
                out.println("<input type='hidden' name='id' value='" + id + "'>");
                out.println("<input type='submit' value='Delete' class='btn delete'>");
                out.println("</form>");
                out.println("</td>");
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
