<!DOCTYPE <!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]>      <html class="no-js"> <!--<![endif]-->
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Login</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/AniTour/styles/style.css">
        <link rel="icon" href="/AniTour/images/anitour.ico">
    </head>
    
    <body id="login-style">
        <div id="login-box">
        <h2>Login</h2>
            <form>
                <input type="text" placeholder="Nome utente" name="username" required>
                <input type="password" placeholder="Password" name="password" required>
                    <input type="checkbox" id="togglePassword"> Mostra password
                <button type="submit">Accedi</button>
                <br>
                <p>Non hai ancora un Account?</p>
                <button type="submit">Registati</buttom>
            </form>
        </div>

        <header class="fixed-header">
            <div class="header-content">
                <a href="tours.html" target="_blank">
                <img src="/AniTour/images/logo_anitour_extended.png" alt="Marchio" class="img-center">
                </a>
            </div>
        </header>
        
        <script>
            document.getElementById("loginForm").addEventListener("submit", function(event) {
            const username = document.getElementById("username").value.trim();
            const password = document.getElementById("password").value.trim();

            if (username === "" || password === "") {
                event.preventDefault(); // blocca l'invio del form
                alert("Inserisci sia nome utente che password.");
            } else {
                // tutto ok, eventualmente puoi fare altre verifiche o inviare
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

    </body>
</html>