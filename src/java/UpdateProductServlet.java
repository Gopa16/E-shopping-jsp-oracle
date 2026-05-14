 import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

import javax.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = {"/UpdateProductServlet"})
public class UpdateProductServlet extends HttpServlet {

   



    private String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe";
    private String jdbcUsername = "system";
    private String jdbcPassword = "manager";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String idStr = request.getParameter("id");

        try {
            int id = Integer.parseInt(idStr);

            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            String sql = "SELECT name, category, price, image FROM products WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String name = rs.getString("name");
                String category = rs.getString("category");
                double price = rs.getDouble("price");
                String image = rs.getString("image");

                out.println("<html><head><title>Update Product</title>");
                out.println("<style>");
                out.println("body { font-family: Arial; background:#f4f4f4; }");
                out.println("form { width:400px; margin:50px auto; padding:20px; background:#fff; border-radius:8px; }");
                out.println("label { display:block; margin-top:10px; font-weight:bold; }");
                out.println("input[type=text], input[type=number] { width:100%; padding:8px; margin-top:5px; border:1px solid #ccc; border-radius:4px; }");
                out.println("input[type=submit] { margin-top:15px; padding:10px; width:100%; background:#333; color:#fff; border:none; border-radius:4px; cursor:pointer; }");
                out.println("input[type=submit]:hover { background:#555; }");
                out.println("</style></head><body>");
                out.println("<h2 style='text-align:center;'>Update Product</h2>");
                out.println("<form action='UpdateProductServlet' method='post'>");
                out.println("<input type='hidden' name='id' value='" + id + "'>");
                out.println("<label>Name:</label><input type='text' name='name' value='" + name + "' required>");
                out.println("<label>Category:</label><input type='text' name='category' value='" + category + "' required>");
                out.println("<label>Price:</label><input type='number' name='price' step='0.01' value='" + price + "' required>");
                out.println("<label>Image:</label><input type='text' name='image' value='" + image + "' required>");
                out.println("<input type='submit' value='Update'>");
                out.println("</form></body></html>");
            } else {
                out.println("<h2>Product not found!</h2>");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            out.println("<h2>Error: " + e.getMessage() + "</h2>");
            e.printStackTrace(out);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String image = request.getParameter("image");

        try {
            int id = Integer.parseInt(idStr);
            double price = Double.parseDouble(priceStr);

            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            String sql = "UPDATE products SET name=?, category=?, price=?, image=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, category);
            ps.setDouble(3, price);
            ps.setString(4, image);
            ps.setInt(5, id);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                out.println("<h2>Product updated successfully!</h2>");
                out.println("<a href='viewProducts'>Back to Product List</a>");
            } else {
                out.println("<h2>Update failed. Try again.</h2>");
            }

            ps.close();
            con.close();

        } catch (Exception e) {
            out.println("<h2>Error: " + e.getMessage() + "</h2>");
            e.printStackTrace(out);
        }
    }
}
