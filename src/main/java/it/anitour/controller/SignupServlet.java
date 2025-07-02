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
        String adminCreate = request.getParameter("adminCreate");
        String userType = request.getParameter("type");
        boolean isAdminCreation = "true".equals(adminCreate);
        
        // Se non è una creazione da admin, verifica che le password coincidano
        if (!isAdminCreation) {
            String password2 = request.getParameter("password2");
            
            if (username == null || email == null || password == null || password2 == null || 
                username.trim().isEmpty() || email.trim().isEmpty() || 
                password.trim().isEmpty() || !password.equals(password2)) {
                response.sendRedirect("/AniTour/signup?error=validation");
                return;
            }
        }
        
        // Se è una creazione da admin, verifica che l'utente corrente sia admin
        if (isAdminCreation) {
            HttpSession session = request.getSession();
            String currentUserType = (String) session.getAttribute("type");
            
            if (!"admin".equals(currentUserType)) {
                response.sendRedirect("/AniTour/profile?error=unauthorized");
                return;
            }
        }
        
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        
        // Se è una creazione da admin e il tipo è specificato, usa quello, altrimenti usa "user"
        if (isAdminCreation && userType != null && (userType.equals("admin") || userType.equals("user"))) {
            user.setType(userType);
        } else {
            user.setType("user");
        }

        try {
            UserDAO dao = new UserDAO();
            
            if (dao.findByUsername(username) != null) {
                if (isAdminCreation) {
                    response.sendRedirect("/AniTour/profile?error=username_exists");
                } else {
                    response.sendRedirect("/AniTour/signup?error=username_exists");
                }
                return;
            }
            
            if (dao.findByEmail(email) != null) {
                if (isAdminCreation) {
                    response.sendRedirect("/AniTour/profile?error=email_exists");
                } else {
                    response.sendRedirect("/AniTour/signup?error=email_exists");
                }
                return;
            }
            
            dao.insertUser(user);
            
            // Se è una creazione da admin, torna alla pagina di profilo
            if (isAdminCreation) {
                response.sendRedirect("/AniTour/profile?success=user_created");
                return;
            }
            
            // Altrimenti, procedi con il login automatico
            HttpSession session = request.getSession();
            String authToken = java.util.UUID.randomUUID().toString();
            session.setAttribute("authToken", authToken);
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("type", user.getType());
            session.setAttribute("userId", user.getId());
            
            response.sendRedirect("/AniTour/home");
        } catch (SQLException e) {
            e.printStackTrace();
            if (isAdminCreation) {
                response.sendRedirect("/AniTour/profile?error=create_user_failed");
            } else {
                response.sendRedirect("/AniTour/signup?error=server");
            }
        }
    }
}
