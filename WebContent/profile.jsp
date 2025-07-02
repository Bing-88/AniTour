<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, it.anitour.model.Tour, it.anitour.model.TourDAO, it.anitour.model.User, it.anitour.model.UserDAO" %>
<%
    // Controlla se la sessione è valida e contiene i dati necessari
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    String type = (String) session.getAttribute("type");
    Integer userId = (Integer) session.getAttribute("userId");
    if (username == null || email == null) {
        response.sendRedirect("/AniTour/login");
        return;
    }
    boolean isAdmin = "admin".equals(type);
    
    // Se l'utente è admin
    List<Tour> tourList = null;
    List<User> userList = null;
    if (isAdmin) {
        try {
            // recupero tutti i tour dal db
            TourDAO tourDAO = new TourDAO();
            tourList = tourDAO.findAll();
            
            // recupero tutti gli utenti dal db
            UserDAO userDAO = new UserDAO();
            userList = userDAO.findAll();
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
                        <% } else if (error.equals("username_exists")) { %>
                            Il nome utente è già in uso.
                        <% } else if (error.equals("email_exists")) { %>
                            L'email è già registrata.
                        <% } else if (error.equals("create_user_failed")) { %>
                            Si è verificato un errore durante la creazione dell'utente.
                        <% } else if (error.equals("delete_user_failed")) { %>
                            Si è verificato un errore durante l'eliminazione dell'utente.
                        <% } else if (error.equals("update_user_failed")) { %>
                            Si è verificato un errore durante l'aggiornamento dell'utente.
                        <% } else if (error.equals("cannot_delete_self")) { %>
                            Non puoi eliminare il tuo account.
                        <% } else if (error.equals("cannot_modify_self")) { %>
                            Non puoi modificare il tuo tipo di account.
                        <% } else if (error.equals("invalid_user_id")) { %>
                            ID utente non valido.
                        <% } else if (error.equals("invalid_user_type")) { %>
                            Tipo utente non valido.
                        <% } %>
                    </div>
                <% } %>
                
                <% if (success != null) { %>
                    <div class="alert alert-success">
                        <% if (success.equals("tour_added")) { %>
                            Tour aggiunto con successo!
                        <% } else if (success.equals("tour_deleted")) { %>
                            Tour eliminato con successo!
                        <% } else if (success.equals("user_created")) { %>
                            Utente creato con successo!
                        <% } else if (success.equals("user_deleted")) { %>
                            Utente eliminato con successo!
                        <% } else if (success.equals("user_updated")) { %>
                            Utente aggiornato con successo!
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
                    
                    <div class="admin-card">
                        <h4 class="collapsible">Gestione Utenti <span class="collapse-icon">+</span></h4>
                        <div class="collapsible-content">
                            <% if (userList != null && !userList.isEmpty()) { %>
                                <div class="users-table-container">
                                    <table class="users-table">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Username</th>
                                                <th>Email</th>
                                                <th>Tipo</th>
                                                <th>Azioni</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (User user : userList) { %>
                                                <tr>
                                                    <td><%= user.getId() %></td>
                                                    <td><%= user.getUsername() %></td>
                                                    <td><%= user.getEmail() %></td>
                                                    <td><%= user.getType() %></td>
                                                    <td class="actions-cell">
                                                        <% if (user.getId() != userId) { %>
                                                            <form action="/AniTour/update-user-type" method="post" class="inline-form">
                                                                <input type="hidden" name="userId" value="<%= user.getId() %>">
                                                                <select name="userType" class="user-type-select">
                                                                    <option value="user" <%= "user".equals(user.getType()) ? "selected" : "" %>>User</option>
                                                                    <option value="admin" <%= "admin".equals(user.getType()) ? "selected" : "" %>>Admin</option>
                                                                </select>
                                                                <button type="submit" class="btn-update">Salva</button>
                                                            </form>
                                                            <form action="/AniTour/delete-user" method="post" class="inline-form" onsubmit="return confirm('Sei sicuro di voler eliminare questo utente?');">
                                                                <input type="hidden" name="userId" value="<%= user.getId() %>">
                                                                <button type="submit" class="btn-delete-small">Elimina</button>
                                                            </form>
                                                        <% } else { %>
                                                            <span class="current-user-label">Utente corrente</span>
                                                        <% } %>
                                                    </td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            <% } else { %>
                                <p class="no-data">Nessun utente disponibile.</p>
                            <% } %>
                            
                            <div class="add-user-form">
                                <h4>Aggiungi nuovo utente</h4>
                                <form action="/AniTour/signup-action" method="post">
                                    <div class="form-row">
                                        <div class="form-group half">
                                            <label for="newUsername">Username:</label>
                                            <input type="text" id="newUsername" name="username" required>
                                        </div>
                                        
                                        <div class="form-group half">
                                            <label for="newEmail">Email:</label>
                                            <input type="email" id="newEmail" name="email" required>
                                        </div>
                                    </div>
                                    
                                    <div class="form-row">
                                        <div class="form-group half">
                                            <label for="newPassword">Password:</label>
                                            <input type="password" id="newPassword" name="password" required>
                                        </div>
                                        
                                        <div class="form-group half">
                                            <label for="newUserType">Tipo utente:</label>
                                            <select id="newUserType" name="type" class="form-select">
                                                <option value="user">User</option>
                                                <option value="admin">Admin</option>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <input type="hidden" name="adminCreate" value="true">
                                    <button type="submit" class="btn1">Crea Utente</button>
                                </form>
                            </div>
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