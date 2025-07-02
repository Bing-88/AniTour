<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, it.anitour.model.Tour, it.anitour.model.TourDAO" %>
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
    
    // Se l'utente è admin
    List<Tour> tourList = null;
    if (isAdmin) {
        try {
            // recupero tutti i tour dal db
            TourDAO tourDAO = new TourDAO();
            tourList = tourDAO.findAll();
        } catch (Exception e) {
            e.printStackTrace();
        }
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
                
                <% 
                    String error = request.getParameter("error");
                    String success = request.getParameter("success");
                    if (error != null) {
                %>
                    <div class="alert alert-error">
                        <% if (error.equals("unauthorized")) { %>
                            Non hai i permessi per accedere a questa funzione.
                        <% } else if (error.equals("tour_exists")) { %>
                            Esiste già un tour con lo stesso nome. Scegli un nome diverso.
                        <% } else if (error.equals("add_tour_failed")) { %>
                            Si è verificato un errore durante l'aggiunta del tour.
                        <% } else if (error.equals("delete_tour_failed")) { %>
                            Si è verificato un errore durante l'eliminazione del tour.
                        <% } %>
                    </div>
                <% } %>
                
                <% if (success != null) { %>
                    <div class="alert alert-success">
                        <% if (success.equals("tour_added")) { %>
                            Tour aggiunto con successo!
                        <% } else if (success.equals("tour_deleted")) { %>
                            Tour eliminato con successo!
                        <% } %>
                    </div>
                <% } %>
                
                <% if (isAdmin) { %>
                <div class="admin-section">
                    <h3>Pannello Amministratore</h3>
                    
                    <div class="admin-card">
                        <h4 class="collapsible">Aggiungi Nuovo Tour <span class="collapse-icon">+</span></h4>
                        <div class="collapsible-content">
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
                    
                    <div class="admin-card">
                        <h4 class="collapsible">Rimuovi Tour <span class="collapse-icon">+</span></h4>
                        <div class="collapsible-content">
                            <form action="/AniTour/delete-tour" method="post" id="deleteTourForm">
                                <div class="form-group">
                                    <label for="tourId">Seleziona il tour da eliminare:</label>
                                    <select id="tourId" name="tourId" required class="form-select">
                                        <option value="" disabled selected>-- Seleziona un tour --</option>
                                        <% if (tourList != null && !tourList.isEmpty()) {
                                            for (Tour tour : tourList) { %>
                                                <option value="<%= tour.getId() %>"><%= tour.getName() %></option>
                                            <% }
                                        } %>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <div class="confirmation-checkbox">
                                        <input type="checkbox" id="confirmDelete" required>
                                        <label for="confirmDelete">Confermo di voler eliminare questo tour</label>
                                    </div>
                                </div>
                                
                                <button type="submit" class="btn-delete">Elimina Tour</button>
                            </form>
                        </div>
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