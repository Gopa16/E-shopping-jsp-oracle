import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
@WebServlet("/placeOrder")
public class PlaceOrder extends HttpServlet {
    private String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe";
    private String jdbcUsername = "system";
    private String jdbcPassword = "manager";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int cartId = Integer.parseInt(request.getParameter("cartId"));
        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("user_id");

        try (Connection con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Get product name from cart + products
            String sql = "SELECT p.name FROM cart c JOIN products p ON c.product_id=p.id WHERE c.cart_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String productName = rs.getString("name");

                // Insert into orders
                String insertOrder = "INSERT INTO orders (user_id, product_name) VALUES (?, ?)";
                PreparedStatement ps2 = con.prepareStatement(insertOrder);
                ps2.setInt(1, userId);
                ps2.setString(2, productName);
                ps2.executeUpdate();

                // Update cart status
                String updateCart = "UPDATE cart SET status='ordered' WHERE cart_id=?";
                PreparedStatement ps3 = con.prepareStatement(updateCart);
                ps3.setInt(1, cartId);
                ps3.executeUpdate();

                response.sendRedirect("orderSuccess.jsp");
            }
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
