package it.anitour.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

@WebServlet("/TokenServlet")
public class TokenServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Genera un token sicuro
    private String generateToken() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[32];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    // Fornisce un token di accesso via AJAX o come attributo di sessione
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = generateToken();
        HttpSession session = request.getSession();
        session.setAttribute("accessToken", token);

        // Se richiesto via AJAX, restituisci il token come testo
        response.setContentType("text/plain");
        response.getWriter().write(token);
    }

    // Aggiunto per gestire l'inserimento del token nel modulo
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String authToken = (String) session.getAttribute("authToken");

        // Invia il token come attributo di richiesta per JSP
        request.setAttribute("authToken", authToken);

        // Inoltra alla JSP per la visualizzazione del modulo
        request.getRequestDispatcher("/path/to/your/form.jsp").forward(request, response);
    }

    // Metodo per gestire il login e la generazione dell'authToken
    protected void doLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // ... codice per verificare username e password ...

        // dopo aver verificato che username e password sono corretti
        String authToken = java.util.UUID.randomUUID().toString();
        HttpSession session = request.getSession();
        session.setAttribute("authToken", authToken);
        // Puoi anche restituirlo come JSON se usi AJAX
    }
}

<%
    String authToken = (String) session.getAttribute("authToken");
%>
<input type="hidden" name="authToken" value="<%= authToken != null ? authToken : "" %>">