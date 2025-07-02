<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Controlla se la sessione è valida e contiene i dati necessari
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    String type = (String) session.getAttribute("type");
    if (username == null || email == null) {
        response.sendRedirect("/AniTour/login");
        return;
    }
    boolean isAdmin = "admin".equals(type);
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
        <% if (isAdmin) { %>
        <script src="/AniTour/scripts/profileAdmin.js"></script>
        <% } %>
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
                    <p><strong>Tipo account:</strong> <%= type %></p>
                </div>
                
                <% if (isAdmin) { %>
                <div class="admin-section">
                    <h3>Pannello Amministratore</h3>
                    
                    <div class="admin-card">
                        <h4>Aggiungi Nuovo Tour</h4>
                        <form action="/AniTour/add-tour" method="post" enctype="multipart/form-data" id="addTourForm">
                            <div class="form-group">
                                <label for="tourName">Nome del Tour:</label>
                                <input type="text" id="tourName" name="name" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="tourDescription">Descrizione:</label>
                                <textarea id="tourDescription" name="description" rows="4" required></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label for="tourPrice">Prezzo (€):</label>
                                <input type="number" id="tourPrice" name="price" min="0" step="0.01" required>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group half">
                                    <label for="tourStartDate">Data inizio:</label>
                                    <input type="date" id="tourStartDate" name="startDate" required>
                                </div>
                                
                                <div class="form-group half">
                                    <label for="tourEndDate">Data fine:</label>
                                    <input type="date" id="tourEndDate" name="endDate" required>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="tourImage">Immagine:</label>
                                <input type="file" id="tourImage" name="image" accept="image/*">
                            </div>
                            
                            <div id="stopsContainer">
                                <h4>Tappe del Tour</h4>
                                <div class="tour-stop">
                                    <div class="form-group">
                                        <label for="stopName1">Nome tappa 1:</label>
                                        <input type="text" id="stopName1" name="stopName1" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="stopDescription1">Descrizione tappa 1:</label>
                                        <textarea id="stopDescription1" name="stopDescription1" rows="2" required></textarea>
                                    </div>
                                </div>
                            </div>
                            
                            <button type="button" class="btn2" id="addStopButton">Aggiungi Tappa</button>
                            <button type="submit" class="btn1">Crea Tour</button>
                        </form>
                    </div>
                </div>
                <% } %>
                
                <form action="/AniTour/logout" method="post" class="logout-form">
                    <button type="submit" class="btn1">Logout</button>
                </form>
            </div>

            <footer>
                <%@ include file="footer.jsp" %>
            </footer>
        </div>
    </body>
</html>