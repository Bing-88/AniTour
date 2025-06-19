<!DOCTYPE <!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Login</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/AniTour/styles/style.css">
        <link rel="icon" href="/AniTour/images/anitour.ico">
    </head>
    
    <body>
        <div id="login-style">
            <div id="login-box">
            <h2>Login</h2>
                <form>
                    <input type="text" id="username" placeholder="Nome utente" name="username" required>
                    <input type="password" id="password" placeholder="Password" name="password" required>
                    <div id="capsWarning" style="display:none; color: violet; font-weight: 700;">Caps Lock attivo!</div>
                    <label>Mostra password
                        <input type="checkbox" id="togglePassword">
                    </label>
                    <br><br>
                    <button type="submit" class="btn1">Accedi</button>
                    <br>
                    <p>Non hai ancora un account?</p>
                    <button type="submit" class="btn1">Registrati</button>
                </form>
            </div>
        </div>
        <header class="fixed-header">
            <div class="header-content">
                <div class="header-left">
                    
                </div> 
                <div class="header-center">
                  <a href="/AniTour/home.jsp">
                    <img src="/AniTour/images/logo_anitour_full.png" alt="Logo" class="img-center" id="logo-full">
                  </a> 
                </div>
                <div class="header-right">

                </div>
            </div>
        </header>
        
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
            document.getElementById("togglePassword").addEventListener("change", function() {
            const pwd = document.getElementById("password");
            pwd.type = this.checked ? "text" : "password";
            });
        </script>

        <script>
            document.getElementById("password").addEventListener("keyup", function(e) {
            const warning = document.getElementById("capsWarning");
            warning.style.display = e.getModifierState("CapsLock") ? "block" : "none";
            });
        </script>
    </body>
</html>