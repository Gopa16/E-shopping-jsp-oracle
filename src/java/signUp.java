import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class signUp extends HttpServlet {

    // Database connection settings
    private String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe"; // Oracle XE default
    private String jdbcUsername = "system";   // <-- replace with your Oracle username
    private String jdbcPassword = "manager";  // <-- replace with your Oracle password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
// Basic password match check


        // Collect form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone_number = request.getParameter("phone_number");
        String security = request.getParameter("security_question");
        String answer = request.getParameter("security_answer");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");
        String role = request.getParameter("user_role"); // <-- add role field from form

        if (!password.equals(confirm)) {
    out.println("<h2>Passwords do not match. Please try again.</h2>");
    out.println("<a href='signUp.html'>Back</a>");
    return; // stop execution, don't insert
}
        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Connect to DB
            Connection con = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            // SQL Insert
            String sql = "INSERT INTO users1 (name, email, phone_number, security_question, "
                       + "security_answer, address, password, user_role) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone_number);
            ps.setString(4, security);
            ps.setString(5, answer);
            ps.setString(6, address);
            ps.setString(7, password);
            ps.setString(8, role); // <-- bind the role value

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("login.html");
            } else {
                out.println("<h2>Registration Failed. Please try again.</h2>");
                out.println("<a href='signUp.html'>Back</a>");
            }

            ps.close();
            con.close();

        } catch (Exception e) {
            out.println("<h2>Error: " + e.getMessage() + "</h2>");
            e.printStackTrace(out);
        }
    }
}
