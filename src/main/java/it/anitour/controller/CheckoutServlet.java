package it.anitour.controller;

import it.anitour.model.Booking;
import it.anitour.model.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.List;
import java.util.UUID;

public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private BookingDAO bookingDAO;
    private static final String EMAIL_PATTERN = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
    private static final String PHONE_PATTERN = "^(\\+\\d{1,3}[-\\s]?)?\\d{3,}[-\\s]?\\d{3,}[-\\s]?\\d{3,}$";

    public void init() {
        bookingDAO = new BookingDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Verifica se l'utente è loggato
        if (session.getAttribute("username") == null) {
            // Salva l'URL corrente per redirect dopo il login
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/checkout");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Ottieni il carrello
        try {
            List<Booking> cartItems = getCartItemsFromSession(request);
            
            if (cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            
            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Verifica se l'utente è loggato
        Integer userId = (Integer) session.getAttribute("userId");
        String sessionId = (String) session.getAttribute("sessionId");
        
        // Se l'utente non è loggato e non c'è una sessione, reindirizza al login
        if (userId == null && (sessionId == null || sessionId.isEmpty())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Recupera i dati dal form di checkout
        String shippingName = request.getParameter("shippingName");
        String shippingAddress = request.getParameter("shippingAddress");
        String shippingCity = request.getParameter("shippingCity");
        String shippingCountry = request.getParameter("shippingCountry");
        String shippingPostalCode = request.getParameter("shippingPostalCode");
        String shippingEmail = request.getParameter("shippingEmail");
        String shippingPhone = request.getParameter("shippingPhone");
        String cardNumber = request.getParameter("cardNumber");
        String cardExpiry = request.getParameter("cardExpiry");
        String cardCvv = request.getParameter("cardCvv");
        String cardHolder = request.getParameter("cardHolder");
        
        // Validazione di base
        if (shippingName == null || shippingName.trim().isEmpty() ||
            shippingAddress == null || shippingAddress.trim().isEmpty() ||
            shippingCity == null || shippingCity.trim().isEmpty() ||
            shippingCountry == null || shippingCountry.trim().isEmpty() ||
            shippingPostalCode == null || shippingPostalCode.trim().isEmpty() ||
            shippingEmail == null || shippingEmail.trim().isEmpty() ||
            shippingPhone == null || shippingPhone.trim().isEmpty() ||
            cardNumber == null || cardNumber.trim().isEmpty() ||
            cardExpiry == null || cardExpiry.trim().isEmpty() ||
            cardCvv == null || cardCvv.trim().isEmpty() ||
            cardHolder == null || cardHolder.trim().isEmpty()) {
            
            request.setAttribute("error", "Tutti i campi sono obbligatori");
            doGet(request, response);
            return;
        }
        
        // Validazione regex per email
        if (!shippingEmail.matches(EMAIL_PATTERN)) {
            request.setAttribute("error", "Formato email non valido");
            doGet(request, response);
            return;
        }
        
        // Validazione regex per numero di telefono
        if (!shippingPhone.matches(PHONE_PATTERN)) {
            request.setAttribute("error", "Formato numero di telefono non valido");
            doGet(request, response);
            return;
        }
        
        // Validazione regex per carta di credito
        String cardNumberRegex = "^[0-9]{13,19}$";
        String cardExpiryRegex = "^(0[1-9]|1[0-2])\\/([0-9]{2})$";
        String cardCvvRegex = "^[0-9]{3,4}$";
        
        // Rimuove spazi e trattini dal numero di carta
        String cleanCardNumber = cardNumber.replaceAll("[-\\s]", "");
        
        if (!cleanCardNumber.matches(cardNumberRegex)) {
            request.setAttribute("error", "Numero carta di credito non valido. Deve contenere da 13 a 19 cifre.");
            doGet(request, response);
            return;
        }
        
        if (!cardExpiry.matches(cardExpiryRegex)) {
            request.setAttribute("error", "Data di scadenza non valida. Usa il formato MM/YY");
            doGet(request, response);
            return;
        }
        
        if (!cardCvv.matches(cardCvvRegex)) {
            request.setAttribute("error", "CVV non valido. Deve contenere 3 o 4 cifre.");
            doGet(request, response);
            return;
        }
        
        // Controlla validità data scadenza
        try {
            String[] expParts = cardExpiry.split("/");
            int month = Integer.parseInt(expParts[0]);
            int year = Integer.parseInt("20" + expParts[1]);
            
            Calendar now = Calendar.getInstance();
            int currentYear = now.get(Calendar.YEAR);
            int currentMonth = now.get(Calendar.MONTH) + 1;
            
            if (year < currentYear || (year == currentYear && month < currentMonth)) {
                request.setAttribute("error", "La carta è scaduta");
                doGet(request, response);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("error", "Data di scadenza non valida");
            doGet(request, response);
            return;
        }
        
        try {
            // Crea l'ordine (converte gli articoli da carrello a ordine)
            bookingDAO.createOrderFromCart(userId, sessionId, 
                                         shippingName, shippingAddress, 
                                         shippingCity, shippingCountry, 
                                         shippingPostalCode, shippingEmail, 
                                         shippingPhone, cardHolder);
            
            // Pulisci il carrello nella sessione
            session.removeAttribute("cartCount");
            
            // Reindirizza alla pagina di conferma ordine
            response.sendRedirect(request.getContextPath() + "/order-confirmation.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Errore SQL durante il checkout: " + e.getMessage());
            
            // Crea un messaggio di errore più dettagliato per il debug
            String errorDetails = "Errore durante il checkout: " + e.getMessage();
            if (e.getCause() != null) {
                errorDetails += " - Causa: " + e.getCause().getMessage();
            }
            
            // Log dettagliato per il debug
            System.err.println(errorDetails);
            
            // Messaggio utente
            request.setAttribute("error", "Errore durante il processo di checkout. Riprova più tardi.");
            doGet(request, response);
        }
    }
    
    // Metodo rinominato per coerenza
    private List<Booking> getCartItemsFromSession(HttpServletRequest request) throws SQLException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String sessionId = getOrCreateSessionId(session);
        return bookingDAO.getCart(userId, sessionId);
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