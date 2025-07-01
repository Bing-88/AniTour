<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Login</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/AniTour/styles/style.css">
        <link rel="stylesheet" href="/AniTour/styles/login.css">
        <link rel="icon" href="/AniTour/images/anitour.ico">
    </head>
    
    <body>
    <div class="page-container">
        <header id="fixed-header">
            <%@ include file="header.jsp" %>
        </header>

        <div class="main-content">
            <div id="login-style">
                <div id="login-box">
                    <h2>Login</h2>
                        <form action="login-action" method="post" id="loginForm">
                            <%
                                String authToken = (String) session.getAttribute("authToken");
                                String error = request.getParameter("error");
                            %>
                            <input type="hidden" name="authToken" value="<%= authToken != null ? authToken : "" %>">
                            <input type="text" id="username" placeholder="Nome utente" name="username" required>
                            <input type="password" id="password" placeholder="Password" name="password" required style="padding-right: 2.2rem;">
                            
                            <% if (error != null) { %>
                                <p class="error-message">
                                    <% if (error.equals("1")) { %>
                                        Nome utente o password errati.
                                    <% } else if (error.equals("server")) { %>
                                        Errore del server. Riprova più tardi.
                                    <% } %>
                                </p>
                            <% } %>
                            
                            <% if (request.getParameter("registered") != null) { %>
                                <p style="color: green;">Registrazione completata con successo. Accedi.</p>
                            <% } %>
                        
                        <div class="toggle-password-wrapper">
                            <span id="togglePasswordIcon">
                                <svg id="eyeOpen" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" style="vertical-align: middle;">
                                    <path stroke="#888" stroke-width="2" d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12Z"/>
                                    <circle cx="12" cy="12" r="3" stroke="#888" stroke-width="2"/>
                                </svg>
                                <svg id="eyeClosed" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" style="display:none;vertical-align: middle;">
                                    <path stroke="#888" stroke-width="2" d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12Z"/>
                                    <path stroke="#888" stroke-width="2" d="M4 4l16 16"/>
                                </svg>
                            </span>
                            <span class="toggle-text">Mostra password</span>
                        </div>
                        
                        <div id="capsWarning">Caps Lock attivo!</div>
                            <button type="submit" class="btn1">Accedi</button>
                            <br><br>
                            <p>Non hai ancora un account?</p>
                            <button type="button" class="btn1" onclick="window.location.href='/AniTour/signup'">Registrati</button>
                        </form>
                    </div>
            </div>
        </div>

        <script src="/AniTour/scripts/formValidation.js"></script>
        <script src="/AniTour/scripts/togglePassword.js"></script>
        <script src="/AniTour/scripts/capsLockWarning.js"></script>
        
        <footer id="footer-login">
            <%@ include file="footer.jsp" %>
        </footer>
    </div>
    </body>
</html>

