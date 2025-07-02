package it.anitour.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import it.anitour.model.User;
import it.anitour.model.UserDAO;
import java.util.List;

public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    public ProfileServlet() {
        super();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Verifica se l'utente è loggato
        if (request.getSession().getAttribute("username") == null) {
            response.sendRedirect("/AniTour/login");
            return;
        }
        
        // Carica la lista degli utenti
        String userType = (String) request.getSession().getAttribute("type");
        boolean isAdmin = "admin".equals(userType);
        if (isAdmin) {
            try {
                UserDAO userDAO = new UserDAO();
                List<User> userList = userDAO.findAll();
                request.setAttribute("userList", userList);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}