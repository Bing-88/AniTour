package it.anitour.controller;

import it.anitour.model.BookingDAO;
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
    
    private BookingDAO bookingDAO;
       
    public LoginServlet() {
        super();
        bookingDAO = new BookingDAO();
    }

    // Modifica nel metodo doGet per supportare il parametro redirect
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Controlla se c'è un parametro di redirect
        String redirect = request.getParameter("redirect");
        if (redirect != null && redirect.equals("checkout")) {
            request.getSession().setAttribute("redirectAfterLogin", request.getContextPath() + "/checkout");
        }
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
                
                // Salva l'ID sessione attuale prima di impostare le nuove informazioni utente
                String sessionId = (String) session.getAttribute("sessionId");
                
                session.setAttribute("authToken", authToken);
                session.setAttribute("user", user);
                
                session.setAttribute("username", user.getUsername());
                session.setAttribute("email", user.getEmail());
                session.setAttribute("type", user.getType());
                session.setAttribute("userId", user.getId());
                
                // Se c'è un sessionId e ci sono prodotti nel carrello di una sessione non autenticata
                // li trasferiamo al nuovo utente
                if (sessionId != null) {
                    try {
                        bookingDAO.transferCart(sessionId, user.getId());
                    } catch (SQLException e) {
                        e.printStackTrace();
                        // Non blocchiamo il login se il trasferimento del carrello fallisce
                    }
                }
                
                // Check if there's a redirect URL saved in session
                String redirectURL = (String) session.getAttribute("redirectAfterLogin");
                if (redirectURL != null) {
                    session.removeAttribute("redirectAfterLogin");
                    response.sendRedirect(redirectURL);
                } else {
                    response.sendRedirect("/AniTour/home");
                }
            } else {
                response.sendRedirect("/AniTour/login?error=1");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/AniTour/login?error=server");
        }
    }
}
