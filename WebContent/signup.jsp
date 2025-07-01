<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Registrati</title>
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
                    <h2>Registrazione</h2>
                    <form action="signup-action" method="post" id="signupForm">
                        <%
                            String authToken = (String) session.getAttribute("authToken");
                            String error = request.getParameter("error");
                        %>
                        <input type="hidden" name="authToken" value="<%= authToken != null ? authToken : "" %>">
                        
                        <input type="text" id="username" placeholder="Nome utente" name="username" required>
                        <p class="error-message" id="usernameError">
                            <% if (error != null && error.equals("username_exists")) { %>
                                Nome utente già in uso.
                            <% } %>
                        </p>
                        
                        <input type="email" id="email" placeholder="Email" name="email" required>
                        <p class="error-message" id="emailError">
                            <% if (error != null && error.equals("email_exists")) { %>
                                Email già registrata.
                            <% } %>
                        </p>
                        
                        <input type="password" id="password" placeholder="Password" name="password" required>
                        <p class="error-message" id="passwordError"></p>
                        
                        <input type="password" id="password2" placeholder="Ripeti Password" name="password2" required>
                        <p class="error-message" id="password2Error">
                            <% if (error != null && error.equals("validation")) { %>
                                Verifica che tutti i campi siano compilati correttamente.
                            <% } else if (error != null && error.equals("server")) { %>
                                Errore del server. Riprova più tardi.
                            <% } %>
                        </p>
                        
                        <div class="toggle-password-wrapper">
                            <span id="togglePasswordIcon">
                                <svg id="eyeOpen" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                    <path stroke="#888" stroke-width="2" d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12Z"/>
                                    <circle cx="12" cy="12" r="3" stroke="#888" stroke-width="2"/>
                                </svg>
                                <svg id="eyeClosed" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" style="display:none;">
                                    <path stroke="#888" stroke-width="2" d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12Z"/>
                                    <path stroke="#888" stroke-width="2" d="M4 4l16 16"/>
                                </svg>
                            </span>
                            <span class="toggle-text">Mostra password</span>
                        </div>
                        
                        <div id="capsWarning">Caps Lock attivo!</div>
                        
                        <button type="submit" class="btn1">Registrati</button>
                        
                        <p>Hai già un account?</p>
                        <button type="button" class="btn1" onclick="window.location.href='/AniTour/login'">Accedi</button>
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
