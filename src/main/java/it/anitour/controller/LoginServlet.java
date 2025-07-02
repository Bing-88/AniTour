package it.anitour.controller;

import it.anitour.model.User;
import it.anitour.model.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public LoginServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("/AniTour/login");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            UserDAO dao = new UserDAO();
            User user = dao.findByUsername(username);
            if (user != null && user.getPassword().equals(password)) {
                String authToken = java.util.UUID.randomUUID().toString();
                HttpSession session = request.getSession();
                session.setAttribute("authToken", authToken);
                session.setAttribute("user", user);
                
                session.setAttribute("username", user.getUsername());
                session.setAttribute("email", user.getEmail());
                session.setAttribute("type", user.getType());
                session.setAttribute("userId", user.getId());
                
                response.sendRedirect("/AniTour/home");
            } else {
                response.sendRedirect("/AniTour/login?error=1");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/AniTour/login?error=server");
        }
    }
}
