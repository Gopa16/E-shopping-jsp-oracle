import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/addToCart")
public class addToCart extends HttpServlet {

    private String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe";
    private String jdbcUsername = "system";
    private String jdbcPassword = "manager";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Get product id from request
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("userDashboard.jsp");
            return;
        }
        int productId = Integer.parseInt(idStr);

        // Get user id from session (assuming you stored it during login)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.html");
            return;
        }
        int userId = (Integer) session.getAttribute("user_id");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            String sql = "INSERT INTO cart (user_id, product_id, quantity, status) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, 1); // default quantity
            ps.setString(4, "active");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("cart.jsp"); // go to cart page
            } else {
                out.println("<p style='color:red;'>Failed to add product to cart.</p>");
            }

        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}
