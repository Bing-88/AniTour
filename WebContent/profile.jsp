<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Controlla se la sessione è valida e contiene i dati necessari
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    if (username == null || email == null) {
        response.sendRedirect("/AniTour/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Profilo</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/AniTour/styles/style.css">
        <link rel="stylesheet" href="/AniTour/styles/profile.css">
        <link rel="icon" href="/AniTour/images/anitour.ico">
    </head>
    <body>
        <div class="page-container">
            <header id="fixed-header">
                <%@ include file="header.jsp" %>
            </header>

            <div class="main-content">
                <h2>Profilo Utente</h2>
                <div class="profile-info">
                    <p><strong>Nome utente:</strong> <%= username %></p>
                    <p><strong>Email:</strong> <%= email %></p>
                </div>
                <form action="/AniTour/logout" method="post">
                    <button type="submit" class="btn1">Logout</button>
                </form>
            </div>

            <footer>
                <%@ include file="footer.jsp" %>
            </footer>
        </div>
    </body>
</html>