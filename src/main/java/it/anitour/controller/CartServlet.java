package it.anitour.controller;

import it.anitour.model.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private BookingDAO bookingDAO;
    private TourDAO tourDAO;
    
    public void init() {
        bookingDAO = new BookingDAO();
        tourDAO = new TourDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
            showCart(request, response);
        } else if (pathInfo.equals("/remove")) {
            removeFromCart(request, response);
        } else if (pathInfo.equals("/clear")) {
            clearCart(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.equals("/add")) {
            addToCart(request, response);
        } else if (pathInfo != null && pathInfo.equals("/update")) {
            updateCartItem(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    private void showCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            String sessionId = getOrCreateSessionId(session);
            
            List<Booking> cartItems = bookingDAO.getCart(userId, sessionId);
            request.setAttribute("cartItems", cartItems);
            
            // Calcola il totale del carrello
            double total = 0;
            for (Booking item : cartItems) {
                total += item.getPrice() * item.getQuantity();
            }
            request.setAttribute("cartTotal", total);
            
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
    
    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quantità non valida");
                return;
            }
            
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            String sessionId = getOrCreateSessionId(session);
            
            // Ottieni il tour
            Tour tour = tourDAO.findById(tourId);
            
            if (tour != null) {
                // Verifica se il tour è già presente nel carrello
                Booking existingBooking = bookingDAO.getCartItemByTourId(userId, sessionId, tourId);
                
                if (existingBooking != null) {
                    // Se il tour è già nel carrello, aggiorna la quantità
                    int newQuantity = existingBooking.getQuantity() + quantity;
                    bookingDAO.updateBookingQuantity(existingBooking.getId(), newQuantity);
                } else {
                    // Se il tour non è nel carrello, crea un nuovo elemento
                    Booking booking = new Booking();
                    booking.setTourId(tour.getId());
                    booking.setUserId(userId);
                    booking.setSessionId(userId == null ? sessionId : null);
                    booking.setQuantity(quantity);
                    booking.setPrice(tour.getPrice());
                    booking.setTourName(tour.getName());
                    booking.setTourImagePath(tour.getImagePath());
                    booking.setStatus("cart");
                    
                    // Salva il booking nel database
                    bookingDAO.saveBooking(booking);
                }
                
                response.sendRedirect(request.getContextPath() + "/cart");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tour non trovato");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri non validi");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore database");
        }
    }
    
    private void updateCartItem(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity <= 0) {
                // Se la quantità è zero o negativa, rimuovi l'articolo
                removeFromCart(request, response);
                return;
            }
            
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            String sessionId = getOrCreateSessionId(session);
            
            // Ottieni la prenotazione corrente
            List<Booking> cartItems = bookingDAO.getCart(userId, sessionId);
            Booking bookingToUpdate = null;
            
            for (Booking booking : cartItems) {
                if (booking.getId() == bookingId) {
                    bookingToUpdate = booking;
                    break;
                }
            }
            
            if (bookingToUpdate != null) {
                bookingToUpdate.setQuantity(quantity);
                bookingDAO.updateBooking(bookingToUpdate);
            }
            
            response.sendRedirect(request.getContextPath() + "/cart");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
    
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            String sessionId = getOrCreateSessionId(session);
            
            bookingDAO.removeFromCart(userId, sessionId, tourId);
            
            response.sendRedirect(request.getContextPath() + "/cart");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
    
    private void clearCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            String sessionId = getOrCreateSessionId(session);
            
            bookingDAO.clearCart(userId, sessionId);
            
            response.sendRedirect(request.getContextPath() + "/cart");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
    
    private String getOrCreateSessionId(HttpSession session) {
        String sessionId = (String) session.getAttribute("sessionId");
        if (sessionId == null) {
            sessionId = UUID.randomUUID().toString();
            session.setAttribute("sessionId", sessionId);
        }
        return sessionId;
    }
}