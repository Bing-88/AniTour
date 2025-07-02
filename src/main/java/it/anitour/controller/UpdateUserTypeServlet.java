package it.anitour.controller;

import java.io.IOException;
import java.sql.SQLException;

import it.anitour.model.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UpdateUserTypeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    public UpdateUserTypeServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("type");
        
        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("/AniTour/profile?error=unauthorized");
            return;
        }
        
        String userId = request.getParameter("userId");
        String newType = request.getParameter("userType");
        String currentUserIdStr = String.valueOf(session.getAttribute("userId"));
        
        // Controllo che l'utente non stia cercando di modificare se stesso
        if (userId != null && userId.equals(currentUserIdStr)) {
            response.sendRedirect("/AniTour/profile?error=cannot_modify_self");
            return;
        }
        
        if (newType == null || (!newType.equals("admin") && !newType.equals("user"))) {
            response.sendRedirect("/AniTour/profile?error=invalid_user_type");
            return;
        }
        
        try {
            int id = Integer.parseInt(userId);
            UserDAO dao = new UserDAO();
            dao.updateUserType(id, newType);
            
            response.sendRedirect("/AniTour/profile?success=user_updated");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/AniTour/profile?error=update_user_failed");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("/AniTour/profile?error=invalid_user_id");
        }
    }
}