import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = {"/AddProductServlet"})


public class AddProductServlet extends HttpServlet {

    private String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe";
    private String jdbcUsername = "system";   // replace with your Oracle username
    private String jdbcPassword = "manager";  // replace with your Oracle password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String image = request.getParameter("image");

        try {
            double price = Double.parseDouble(priceStr);

            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            String sql = "INSERT INTO products (name, category, price, image) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, category);
            ps.setDouble(3, price);
            ps.setString(4, image);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                out.println("<h2>Product added successfully!</h2>");
                out.println("<a href='viewProducts'>View Products</a>");
            } else {
                out.println("<h2>Failed to add product. Try again.</h2>");
                out.println("<a href='addProduct.html'>Back</a>");
            }

            ps.close();
            con.close();

        } catch (Exception e) {
            out.println("<h2>Error: " + e.getMessage() + "</h2>");
            e.printStackTrace(out);
        }
    }
}
