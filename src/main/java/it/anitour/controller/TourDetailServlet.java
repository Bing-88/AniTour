package it.anitour.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import it.anitour.model.Tour;
import it.anitour.model.TourDAO;

public class TourDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public TourDetailServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect("/AniTour/tours");
            return;
        }
        
        String slug = pathInfo.substring(1); // Rimuovi lo slash iniziale
        
        try {
            TourDAO dao = new TourDAO();
            Tour tour = dao.findBySlug(slug);
            
            if (tour == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tour non trovato");
                return;
            }
            
            request.setAttribute("tour", tour);
            request.getRequestDispatcher("/tour-details.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore del database");
        }
    }
}