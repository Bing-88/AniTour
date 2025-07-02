package it.anitour.controller;

import java.io.IOException;
import java.sql.SQLException;

import it.anitour.model.TourDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class DeleteTourServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    public DeleteTourServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("type");
        
        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("/AniTour/profile?error=unauthorized");
            return;
        }
        
        String tourIdStr = request.getParameter("tourId");
        
        if (tourIdStr == null || tourIdStr.trim().isEmpty()) {
            response.sendRedirect("/AniTour/profile?error=delete_tour_failed");
            return;
        }
        
        try {
            int tourId = Integer.parseInt(tourIdStr);
            TourDAO tourDAO = new TourDAO();
            tourDAO.delete(tourId);
            
            response.sendRedirect("/AniTour/profile?success=tour_deleted");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/AniTour/profile?error=delete_tour_failed");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("/AniTour/profile?error=delete_tour_failed");
        }
    }
}