import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class login extends HttpServlet {

    private String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe";
    private String jdbcUsername = "system";
    private String jdbcPassword = "manager";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String phone_number = request.getParameter("phone_number");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            // ✅ Make sure your users1 table has an 'id' column (primary key)
            String sql = "SELECT user_id, name, phone_number, email, address, user_role "
                       + "FROM users1 WHERE phone_number=? AND password=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, phone_number);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                String role = rs.getString("user_role");

                HttpSession session = request.getSession();
                // ✅ Store user_id in session for cart functionality
                session.setAttribute("user_id", rs.getInt("user_id"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("phone_number", rs.getString("phone_number"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("address", rs.getString("address"));
                session.setAttribute("role", role);

                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("AdminDashboard.jsp");
                } else {
                    response.sendRedirect("userDashboard.jsp");
                }
            } else {
                out.println("<h3 style='color:red; text-align:center;'>Invalid Mobile or Password</h3>");
                RequestDispatcher rd = request.getRequestDispatcher("login.html");
                rd.include(request, response);
            }

        } catch (Exception e) {
            out.println("<h2 style='color:red; text-align:center;'>Error: " + e.getMessage() + "</h2>");
            e.printStackTrace(out);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}
