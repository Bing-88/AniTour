package it.anitour.controller;

import it.anitour.model.User;
import it.anitour.model.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public SignupServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("/AniTour/signup");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");

        if (username == null || email == null || password == null || password2 == null || 
            username.trim().isEmpty() || email.trim().isEmpty() || 
            password.trim().isEmpty() || !password.equals(password2)) {
            response.sendRedirect("/AniTour/signup?error=validation");
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        user.setType("user");

        try {
            UserDAO dao = new UserDAO();
            
            if (dao.findByUsername(username) != null) {
                response.sendRedirect("/AniTour/signup?error=username_exists");
                return;
            }
            
            if (dao.findByEmail(email) != null) {
                response.sendRedirect("/AniTour/signup?error=email_exists");
                return;
            }
            
            dao.insertUser(user);
            
            HttpSession session = request.getSession();
            String authToken = java.util.UUID.randomUUID().toString();
            session.setAttribute("authToken", authToken);
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("type", user.getType());
            
            response.sendRedirect("/AniTour/home");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/AniTour/signup?error=server");
        }
    }
}
