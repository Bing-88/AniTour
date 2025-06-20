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
                        <form action="LoginServlet" method="post" id="loginForm">
                            <%
                                String authToken = (String) session.getAttribute("authToken");
                            %>
                            <input type="hidden" name="authToken" value="<%= authToken != null ? authToken : "" %>">
                            <input type="text" id="username" placeholder="Nome utente" name="username" required>
                            <div style="position:relative;">
                                <input type="password" id="password" placeholder="Password" name="password" required style="padding-right: 2.2rem;">
                                <span id="togglePasswordIcon" style="position: absolute; right: 10px; top: 42%; transform: translateY(-50%); cursor: pointer; display: none;">
                                    <svg id="eyeOpen" xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="none" viewBox="0 0 24 24" style="vertical-align: middle;">
                                        <path stroke="#888" stroke-width="2" d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12Z"/>
                                        <circle cx="12" cy="12" r="3" stroke="#888" stroke-width="2"/>
                                    </svg>
                                    <svg id="eyeClosed" xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="none" viewBox="0 0 24 24" style="display:none;vertical-align: middle;">
                                        <path stroke="#888" stroke-width="2" d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12Z"/>
                                        <path stroke="#888" stroke-width="2" d="M4 4l16 16"/>
                                    </svg>
                                </span>
                            </div>
                            <div id="capsWarning" style="display:none; color: violet; font-weight: 700;">Caps Lock attivo!</div>
                            <br>
                            <button type="submit" class="btn1">Accedi</button>
                            <br><br>
                            <p>Non hai ancora un account?</p>
                            <button type="button" class="btn1" onclick="window.location.href='/AniTour/signup.jsp'">Registrati</button>
                        </form>
                    </div>
            </div>
        </div>
        <script>
            document.getElementById("loginForm").addEventListener("submit", function(event) {
            const username = document.getElementById("username").value.trim();
            const password = document.getElementById("password").value.trim();

            if (username === "" || password === "") {
                event.preventDefault(); 
                alert("Inserisci sia nome utente che password.");
            } else {
                
                console.log("Nome utente:", username);
                console.log("Password:", password);
            }
            });
        </script>
        <script>
            // Icona occhio per mostra/nascondi password
            const pwdInput = document.getElementById("password");
            const toggleIcon = document.getElementById("togglePasswordIcon");
            const eyeOpen = document.getElementById("eyeOpen");
            const eyeClosed = document.getElementById("eyeClosed");

            // Mostra l'icona solo quando il campo password è attivo e modificabile
            pwdInput.addEventListener("focus", function() {
                toggleIcon.style.display = "block";
            });

            pwdInput.addEventListener("blur", function() {
                toggleIcon.style.display = "none";
            });

            toggleIcon.addEventListener("click", function() {
                const isPwd = pwdInput.type === "password";
                pwdInput.type = isPwd ? "text" : "password";
                eyeOpen.style.display = isPwd ? "none" : "inline";
                eyeClosed.style.display = isPwd ? "inline" : "none";
            });
        </script>

        <script>
            document.getElementById("password").addEventListener("keyup", function(e) {
            const warning = document.getElementById("capsWarning");
            warning.style.display = e.getModifierState("CapsLock") ? "block" : "none";
            });
        </script>
        <footer id="footer-login">
            <%@ include file="footer.jsp" %>
        </footer>
    </div>
    </body>
</html>

