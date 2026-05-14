import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/deleteProduct")
public class deleteProduct extends HttpServlet {

    private String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe";
    private String jdbcUsername = "system";   // replace with your Oracle username
    private String jdbcPassword = "manager";  // replace with your Oracle password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String idStr = request.getParameter("id");

        try {
            int id = Integer.parseInt(idStr);

            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            String sql = "DELETE FROM products WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            int rows = ps.executeUpdate();

            out.println("<html><head><title>Delete Product</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; background:#f4f4f4; }");
            out.println(".message { text-align:center; margin-top:100px; font-size:20px; }");
            out.println("a { display:inline-block; margin-top:20px; padding:10px 20px; background:#333; color:#fff; text-decoration:none; border-radius:4px; }");
            out.println("a:hover { background:#555; }");
            out.println("</style></head><body>");

            if (rows > 0) {
                out.println("<div class='message'>Product deleted successfully!<br>");
                out.println("<a href='viewProducts'>Back to Product List</a></div>");
            } else {
                out.println("<div class='message'>No product found with ID " + id + ".<br>");
                out.println("<a href='deleteProduct.html'>Try Again</a></div>");
            }

            out.println("</body></html>");

            ps.close();
            con.close();

        } catch (Exception e) {
            out.println("<html><body><div class='message'>Error: " + e.getMessage() + "</div></body></html>");
            e.printStackTrace(out);
        }
    }
}
