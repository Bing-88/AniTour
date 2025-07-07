package it.anitour.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LoginPageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    public LoginPageServlet() {
        super();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Controlla se c'è un parametro di redirect
        String redirect = request.getParameter("redirect");
        if (redirect != null && redirect.equals("checkout")) {
            request.getSession().setAttribute("redirectAfterLogin", request.getContextPath() + "/checkout");
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
