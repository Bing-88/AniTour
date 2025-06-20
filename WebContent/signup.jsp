<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE <!DOCTYPE html>
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
                    <h2>Registrazione</h2>
                        <form>
                            <input type="text" id="username" placeholder="Nome utente" name="username" required>
                            <input type="email" id="email" placeholder="Email" name="email" required>
                            <div style="position:relative;">
                                <input type="password" id="password" placeholder="Password" name="password" required style="padding-right: 2.2rem;">
                            </div>
                            <div style="position:relative;">
                                <input type="password" id="password2" placeholder="Ripeti Password" name="password2" required style="padding-right: 2.2rem;">
                                <span id="togglePasswordIcon2" style="position: absolute; right: 10px; top: 42%; transform: translateY(-50%); cursor: pointer;">
                                    <svg id="eyeOpen2" xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="none" viewBox="0 0 24 24" style="vertical-align: middle;">
                                        <path stroke="#888" stroke-width="2" d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12Z"/>
                                        <circle cx="12" cy="12" r="3" stroke="#888" stroke-width="2"/>
                                    </svg>
                                    <svg id="eyeClosed2" xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="none" viewBox="0 0 24 24" style="display:none;vertical-align: middle;">
                                        <path stroke="#888" stroke-width="2" d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12Z"/>
                                        <path stroke="#888" stroke-width="2" d="M4 4l16 16"/>
                                    </svg>
                                </span>
                            </div>
                            <div id="capsWarning" style="display:none; color: violet; font-weight: 700;">Caps Lock attivo!</div>
                            <br><br>
                            <button type="submit" class="btn1">Registrati</button>
                            <br>
                            <p>Hai già un account?</p>
                            <button type="button" class="btn1" onclick="window.location.href='/AniTour/login.jsp'">Accedi</button>
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
            document.getElementById("togglePasswordIcon1").addEventListener("click", function() {
                const pwd = document.getElementById("password");
                const eyeOpen = document.getElementById("eyeOpen1");
                const eyeClosed = document.getElementById("eyeClosed1");
                const isPassword = pwd.getAttribute("type") === "password";

                pwd.setAttribute("type", isPassword ? "text" : "password");
                eyeOpen.style.display = isPassword ? "none" : "inline";
                eyeClosed.style.display = isPassword ? "inline" : "none";
            });
        </script>
        <script>
            document.getElementById("togglePasswordIcon2").addEventListener("click", function() {
                const pwd1 = document.getElementById("password");
                const pwd2 = document.getElementById("password2");
                const eyeOpen2 = document.getElementById("eyeOpen2");
                const eyeClosed2 = document.getElementById("eyeClosed2");
                const isPassword = pwd2.type === "password";

                pwd1.type = isPassword ? "text" : "password";
                pwd2.type = isPassword ? "text" : "password";
                eyeOpen2.style.display = isPassword ? "none" : "inline";
                eyeClosed2.style.display = isPassword ? "inline" : "none";
            });
        </script>
        <script>
            document.getElementById("password").addEventListener("keyup", function(e) {
            const warning = document.getElementById("capsWarning");
            warning.style.display = e.getModifierState("CapsLock") ? "block" : "none";
            });
        </script>

        <
        <footer id="footer-login">
            <%@ include file="footer.jsp" %>
        </footer>
    </div>
    </body>
</html>
