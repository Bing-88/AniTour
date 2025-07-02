package it.anitour.controller;

import java.io.IOException;
import java.sql.SQLException;

import it.anitour.model.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    public DeleteUserServlet() {
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
        String currentUserIdStr = String.valueOf(session.getAttribute("userId"));
        
        // Controllo che l'utente non stia cercando di eliminare se stesso
        if (userId != null && userId.equals(currentUserIdStr)) {
            response.sendRedirect("/AniTour/profile?error=cannot_delete_self");
            return;
        }
        
        try {
            int id = Integer.parseInt(userId);
            UserDAO dao = new UserDAO();
            dao.deleteUser(id);
            
            response.sendRedirect("/AniTour/profile?success=user_deleted");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/AniTour/profile?error=delete_user_failed");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("/AniTour/profile?error=invalid_user_id");
        }
    }
}