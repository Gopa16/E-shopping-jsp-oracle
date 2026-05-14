import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
@WebServlet("/logout") 
public class logout extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); 
        if (session != null) {
            session.invalidate(); // end session
        }

        // ✅ Redirect directly to webpage.html
        response.sendRedirect("frontPage.html");
    }
}