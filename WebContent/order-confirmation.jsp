<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Conferma Ordine - AniTour</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="/AniTour/styles/style.css">
    <link rel="stylesheet" href="/AniTour/styles/order-confirmation.css">
    <link rel="icon" href="/AniTour/images/anitour.ico">
</head>
<body>
    <div class="page-container">
        <header id="fixed-header">
            <%@ include file="header.jsp" %>
        </header>

        <div class="main-content">
            <div class="confirmation-container">
                <div class="confirmation-icon">
                    <img src="/AniTour/images/check-circle.svg" alt="Confermato">
                </div>
                
                <h1>Ordine completato con successo!</h1>
                
                <p class="confirmation-message">
                    Grazie per il tuo acquisto. Ti abbiamo inviato una email con i dettagli dell'ordine.
                </p>
                
                <div class="order-details">
                    <h2>Informazioni sull'ordine</h2>
                    <p>Il tuo ordine è stato registrato e sarà processato a breve. L'addebito sulla tua carta di credito avverrà nelle prossime ore.</p>
                </div>
                
                <div class="next-steps">
                    <h2>Cosa succede ora?</h2>
                    <ul>
                        <li>Riceverai una email di conferma con i dettagli dell'ordine</li>
                        <li>Lo stato del tuo ordine sarà aggiornato nella sezione "I miei ordini"</li>
                        <li>Ti contatteremo per eventuali aggiornamenti o informazioni aggiuntive</li>
                    </ul>
                </div>
                
                <div class="confirmation-actions">
                    <a href="/AniTour/home" class="btn-home">Torna alla home</a>
                    <a href="/AniTour/profile" class="btn-profile">Vai al profilo</a>
                </div>
            </div>
        </div>

        <footer>
            <%@ include file="footer.jsp" %>
        </footer>
    </div>
</body>
</html>