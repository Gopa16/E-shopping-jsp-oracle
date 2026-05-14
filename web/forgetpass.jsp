<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%
    // Database connection variables
    String dbURL = "jdbc:oracle:thin:@localhost:1521:xe"; 
    String dbUser = "system"; 
    String dbPass = "manager"; 
    
    String message = "";
    boolean verified = false;

    // Step 1: Verify user
    if (request.getParameter("verify") != null) {
        String mobile = request.getParameter("mobile");
        String secQ = request.getParameter("security_question");
        String ans = request.getParameter("answer");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE mobile=? AND security_question=? AND answer=?"
            );
            ps.setString(1, mobile);
            ps.setString(2, secQ);
            ps.setString(3, ans);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                verified = true;
                session.setAttribute("mobile", mobile); 
            } else {
                message = "Invalid details. Please try again.";
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    }

    // Step 2: Update password
    if (request.getParameter("reset") != null) {
        String newPass = request.getParameter("new_password");
        String confirmPass = request.getParameter("confirm_password");
        String mobile = (String) session.getAttribute("mobile");

        if (newPass.equals(confirmPass)) {
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

                PreparedStatement ps = con.prepareStatement(
                    "UPDATE users SET password=? WHERE mobile=?"
                );
                ps.setString(1, newPass);
                ps.setString(2, mobile);

                int updated = ps.executeUpdate();
                if (updated > 0) {
                    message = "Password successfully updated. You can now login.";
                    session.removeAttribute("mobile");
                    response.sendRedirect("login.html");
                    return;
                } else {
                    message = "Failed to update password.";
                }

                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                message = "Error: " + e.getMessage();
            }
        } else {
            message = "Passwords do not match.";
            verified = true; 
        }
    }
%>

<html>
<head>
    <title>Forgot Password</title>
    <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: Arial, sans-serif;
    }

    body, html {
      height: 100%;
    }

    body {
      background: url("images/home.png") no-repeat center center/cover;
      position: relative;
    }

    body::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: inherit;
      filter: blur(8px);
      z-index: -1;
    }

    .login-container {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background: rgba(255, 255, 255, 0.85);
      padding: 30px 40px;
      border-radius: 12px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.2);
      width: 320px;
      text-align: center;
    }

    .login-container h2 {
      margin-bottom: 20px;
      color: #3e2723;
    }

    /* Make input and select look the same */
    .login-container input,
    .login-container select {
      width: 100%;
      padding: 12px;
      margin: 10px 0;
      border: 1px solid #8b4513;
      border-radius: 8px;
      outline: none;
      font-size: 16px;
      background: #fff;
      appearance: none; /* removes browser default style */
    }

    .login-container input:focus,
    .login-container select:focus {
      border-color: #5d4037;
      box-shadow: 0 0 6px rgba(93,64,55,0.4);
    }

    /* Optional custom arrow for dropdown */
    .login-container select {
      background: #fff url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='12' height='12'><polygon points='0,0 12,0 6,6' fill='%238b4513'/></svg>") no-repeat right 10px center;
      background-size: 12px;
    }

    .login-container button,
    .login-container input[type=submit] {
      width: 100%;
      padding: 12px;
      margin-top: 15px;
      border: none;
      border-radius: 8px;
      background-color: #d2b48c;
      color: #3e2723;
      font-size: 16px;
      font-weight: bold;
      cursor: pointer;
      transition: background 0.3s;
    }

    .login-container button:hover,
    .login-container input[type=submit]:hover {
      background-color: #c19a6b;
    }

    .login-container a {
      display: block;
      margin-top: 15px;
      text-decoration: none;
      color: #5d4037;
      font-size: 14px;
    }

    .login-container a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
    <div class="login-container">
    <h2>Forgot Password</h2>

    <form method="post">
    <% if (!verified && session.getAttribute("mobile") == null) { %>
        <!-- Verification form -->
        <input type="text" name="mobile" placeholder="Mobile no." required>

        <select name="security_question" required>
            <option value="" disabled selected>Security Question</option>
            <option value="color">Favourite Color</option>
            <option value="pet">Pet Name</option>
        </select>

        <input type="text" name="answer" placeholder="Answer" required>

        <input type="submit" name="verify" value="Verify">
    <% } else { %>
        <!-- Reset password form -->
        <input type="password" name="new_password" placeholder="New Password" required>

        <input type="password" name="confirm_password" placeholder="Confirm Password" required>

        <input type="submit" name="reset" value="Reset Password">
    <% } %>
    </form>

    <p style="color:red;"><%= message %></p>
    </div>
</body>
</html>