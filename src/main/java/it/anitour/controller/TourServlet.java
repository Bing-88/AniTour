package it.anitour.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import it.anitour.model.Tour;
import it.anitour.model.TourDAO;

/**
 * Servlet implementation class TourServlet
 */
public class TourServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TourServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        TourDAO dao = new TourDAO();
        List<Tour> tours = null;
        
        try {
            // Controlla se ci sono parametri di ricerca
            String theme = request.getParameter("theme");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String minPriceStr = request.getParameter("minPrice");
            String maxPriceStr = request.getParameter("maxPrice");
            
            // Ricerca per tema
            if (theme != null && !theme.trim().isEmpty()) {
                tours = dao.searchByTheme(theme);
                request.setAttribute("searchType", "theme");
                request.setAttribute("searchQuery", theme);
            }
            // Ricerca per date
            else if (startDateStr != null || endDateStr != null) {
                Date startDate = null;
                Date endDate = null;
                
                if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                    startDate = Date.valueOf(startDateStr);
                }
                
                if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                    endDate = Date.valueOf(endDateStr);
                }
                
                tours = dao.searchByDate(startDate, endDate);
                request.setAttribute("searchType", "date");
                request.setAttribute("startDate", startDateStr);
                request.setAttribute("endDate", endDateStr);
            }
            // Ricerca per budget
            else if (minPriceStr != null && maxPriceStr != null) {
                double minPrice = Double.parseDouble(minPriceStr);
                double maxPrice = Double.parseDouble(maxPriceStr);
                
                tours = dao.searchByPrice(minPrice, maxPrice);
                request.setAttribute("searchType", "budget");
                request.setAttribute("minPrice", minPrice);
                request.setAttribute("maxPrice", maxPrice);
            }
            // Nessun parametro di ricerca, mostra tutti i tour
            else {
                tours = dao.findAll();
            }
            
            request.setAttribute("tours", tours);
            request.getRequestDispatcher("/tours.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
