<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList, java.util.HashMap" %>
<%@ page import="java.text.DecimalFormat, java.text.SimpleDateFormat, java.sql.Timestamp" %>
<%@ page import="it.anitour.model.Tour, it.anitour.model.TourDAO, it.anitour.model.User, it.anitour.model.UserDAO, it.anitour.model.Booking, it.anitour.model.BookingDAO" %>
<%
    // Inizializzazione dei formattatori e DAO
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
    UserDAO userDAO = new UserDAO();
    BookingDAO bookingDAO = new BookingDAO();
    
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
                            Tipo utente aggiornato con successo!
                        <% } %>
                    </div>
                <% } %>
                
                <% if (isAdmin) { %>
                <div class="admin-section">
                    <h3>Pannello Amministratore</h3>
                    
                    <div class="admin-card">
                        <h4 class="collapsible">Aggiungi Nuovo Tour <span class="collapse-icon">+</span></h4>
                        <div class="collapsible-content">
                            <!-- Div per i messaggi di errore del form -->
                            <div id="addTourFormError" class="form-error-message form-error-hidden" style="display:none !important; visibility:hidden !important; opacity:0 !important; height:0 !important; position:absolute !important; overflow:hidden !important; clip:rect(0,0,0,0) !important;" hidden aria-hidden="true"></div>
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
                                        <!-- Messaggio di errore per le date -->
                                        <p class="error-message" id="tourDateError" style="display: none; color: #e74c3c; font-size: 0.85rem; margin-top: 0.5rem;"></p>
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
                                
                                <button type="submit" class="btn1">Elimina Tour</button>
                            </form>
                        </div>
                    </div>
                    
                    <div class="admin-card">
                        <h4 class="collapsible">Modifica Tour <span class="collapse-icon">+</span></h4>
                        <div class="collapsible-content">
                            <!-- Messaggi di errore/successo per l'aggiornamento -->
                            <% String updateTourError = (String) request.getAttribute("updateTourError"); %>
                            <% if (updateTourError != null) { %>
                                <div class="alert alert-error">
                                    <%= updateTourError %>
                                </div>
                            <% } %>
                            
                            <% String updateTourSuccess = (String) request.getAttribute("updateTourSuccess"); %>
                            <% if (updateTourSuccess != null) { %>
                                <div class="alert alert-success">
                                    <%= updateTourSuccess %>
                                </div>
                            <% } %>
                            
                            <div id="updateTourFormError" class="form-error-message form-error-hidden" style="display:none !important; visibility:hidden !important; opacity:0 !important; height:0 !important; position:absolute !important; overflow:hidden !important; clip:rect(0,0,0,0) !important;" hidden aria-hidden="true"></div>
                            
                            <form action="/AniTour/update-tour" method="post" enctype="multipart/form-data" id="updateTourForm">
                                <!-- Campo hidden per mantenere il tourId -->
                                <input type="hidden" id="updateTourIdHidden" name="tourId" value="">
                                
                                <div class="form-group">
                                    <label for="updateTourSelect">Seleziona il tour da modificare:</label>
                                    <select id="updateTourSelect" required class="form-select">
                                        <option value="" disabled selected>-- Seleziona un tour --</option>
                                        <% if (tourList != null && !tourList.isEmpty()) {
                                            for (Tour tour : tourList) { %>
                                                <option value="<%= tour.getId() %>"><%= tour.getName() %></option>
                                            <% }
                                        } %>
                                    </select>
                                </div>
                                
                                <div id="updateTourFields" style="display: none;">
                                    <div class="form-group">
                                        <label for="updateTourName">Nome del Tour:</label>
                                        <input type="text" id="updateTourName" name="name" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="updateTourDescription">Descrizione:</label>
                                        <textarea id="updateTourDescription" name="description" rows="4" required></textarea>
                                    </div>
                                    
                                    <div class="form-row">
                                        <div class="form-group half">
                                            <label for="updateTourPrice">Prezzo (€):</label>
                                            <input type="number" id="updateTourPrice" name="price" step="0.01" min="0" required>
                                        </div>
                                        
                                        <div class="form-group half">
                                            <label for="updateTourImage">Nuova Immagine (opzionale):</label>
                                            <input type="file" id="updateTourImage" name="image" accept="image/*">
                                        </div>
                                    </div>
                                    
                                    <div class="form-row">
                                        <div class="form-group half">
                                            <label for="updateTourStartDate">Data di Inizio:</label>
                                            <input type="date" id="updateTourStartDate" name="startDate" required>
                                        </div>
                                        
                                        <div class="form-group half">
                                            <label for="updateTourEndDate">Data di Fine:</label>
                                            <input type="date" id="updateTourEndDate" name="endDate" required>
                                            <!-- Messaggio di errore per le date -->
                                            <p class="error-message" id="updateTourDateError" style="display: none; color: #e74c3c; font-size: 0.85rem; margin-top: 0.5rem;"></p>
                                        </div>
                                    </div>
                                    
                                    <button type="submit" class="btn1">Aggiorna Tour</button>
                                </div>
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
                    
                    <div class="admin-card">
                        <h4 class="collapsible">Gestione Ordini <span class="collapse-icon">+</span></h4>
                        <div class="collapsible-content">
                            <div class="orders-dashboard">
                                <% 
                                    Map<String, Object> orderStats = (Map<String, Object>) request.getAttribute("orderStats");
                                    if (orderStats != null) {
                                        DecimalFormat currencyFormat = new DecimalFormat("#,##0.00");
                                %>
                                    <div class="stat-card">
                                        <div class="stat-value"><%= orderStats.get("totalOrders") %></div>
                                        <div class="stat-label">Totale prodotti acquistati</div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-value"><%= currencyFormat.format(orderStats.get("totalRevenue")) %>€</div>
                                        <div class="stat-label">Ricavi totali</div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-value"><%= orderStats.get("recentOrders") %></div>
                                        <div class="stat-label">Ultimi 30 giorni</div>
                                    </div>
                                <% } %>
                            </div>
                
                            <div class="orders-filter">
                                <h5>Filtra ordini</h5>
                                
                                <!-- Area per messaggi di errore -->
                                <div id="filterErrorMessage" class="filter-error-message" style="display: none;">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <span id="filterErrorText"></span>
                                </div>
                                
                                <form id="ordersFilterFormMain" action="/AniTour/profile" method="get">
                                    <div class="form-row">
                                        <div class="form-group half">
                                            <label for="startDateMain">Da data:</label>
                                            <input type="date" id="startDateMain" name="startDate" class="form-control filter-input"
                                                value="<%= request.getAttribute("startDateFilter") != null ? request.getAttribute("startDateFilter") : "" %>">
                                        </div>
                                        <div class="form-group half">
                                            <label for="endDateMain">A data:</label>
                                            <input type="date" id="endDateMain" name="endDate" class="form-control filter-input"
                                                value="<%= request.getAttribute("endDateFilter") != null ? request.getAttribute("endDateFilter") : "" %>">
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="clientIdMain">Cliente:</label>
                                        <select id="clientIdMain" name="clientId" class="form-select filter-input">
                                            <option value="">Tutti i clienti</option>
                                            <% 
                                                List<User> usersWithOrders = (List<User>) request.getAttribute("usersWithOrders");
                                                if (usersWithOrders != null) {
                                                    for (User orderUser : usersWithOrders) {
                                                        String selected = "";
                                                        String clientIdFilter = (String)request.getAttribute("clientIdFilter");
                                                        if (clientIdFilter != null && clientIdFilter.equals(String.valueOf(orderUser.getId()))) {
                                                            selected = "selected";
                                                        }
                                            %>
                                                <option value="<%= orderUser.getId() %>" <%= selected %>>

                                                    <%= orderUser.getUsername() %> (<%= orderUser.getEmail() %>)
                                                </option>
                                            <% 
                                                    }
                                                }
                                            %>
                                        </select>
                                    </div>
                                    
                                    <div class="form-actions">
                                        <button type="button" id="resetFiltersMain" class="btn-clear">
                                            <i class="fas fa-undo-alt"></i> Resetta filtri
                                        </button>
                                    </div>
                                </form>
                            </div>
                            
                            <!-- Container per la tabella dei risultati - caricato dinamicamente con AJAX -->
                            <div id="ordersResultContainerMain">
                                <div class="loading-spinner" style="display: none;">
                                    <div class="spinner"></div>
                                    <p>Caricamento dati...</p>
                                </div>
                                <div id="ordersTableContainerMain">
                                    <!-- Il contenuto della tabella viene caricato qui -->
                                    <% 
                                        List<Booking> filteredOrders = (List<Booking>)request.getAttribute("filteredOrders");
                                        if (filteredOrders != null && !filteredOrders.isEmpty()) {
                                    %>
                                    <div class="orders-table-container">
                                        <h5>Risultati ordini (<%= filteredOrders.size() %> ordini trovati)</h5>
                                        <table class="orders-table">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Data</th>
                                                    <th>Cliente</th>
                                                    <th>Tour</th>
                                                    <th>Quantità</th>
                                                    <th>Totale</th>
                                                    <th>Stato</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% 
                                                Map<String, List<Booking>> filteredOrdersGrouped = (Map<String, List<Booking>>) request.getAttribute("filteredOrdersGrouped");
                                                if (filteredOrdersGrouped != null && !filteredOrdersGrouped.isEmpty()) {
                                                    for (Map.Entry<String, List<Booking>> entry : filteredOrdersGrouped.entrySet()) {
                                                        String orderIdentifier = entry.getKey();
                                                        List<Booking> orderItems = entry.getValue();
                                                        
                                                        // Controllo di sicurezza per evitare orderIdentifier null o vuoto
                                                        if (orderIdentifier == null || orderIdentifier.trim().isEmpty() || orderItems == null || orderItems.isEmpty()) {
                                                            continue;
                                                        }
                                                        
                                                        Booking firstItem = orderItems.get(0);

                                                        // Calcolo quantità e totale
                                                        int totalQuantity = 0;
                                                        double totalAmount = 0;
                                                        for (Booking item : orderItems) {
                                                            totalQuantity += item.getQuantity();
                                                            totalAmount += item.getPrice() * item.getQuantity();
                                                        }
                                                %>
                                                    <tr class="order-row">
                                                        <td><%= orderIdentifier %></td>
                                                        <td><%= dateFormat.format(firstItem.getBookingDate()) %></td>
                                                        <td>
                                                            <% if (firstItem.getUserId() != null) { 
                                                                try {
                                                                    User orderUser = userDAO.findById(firstItem.getUserId());
                                                                    if (orderUser != null) { %>
                                                                        <%= orderUser.getUsername() %>
                                                                    <% } else { %>
                                                                        ID: <%= firstItem.getUserId() %>
                                                                    <% }
                                                                } catch (Exception e) { %>
                                                                    ID: <%= firstItem.getUserId() %>
                                                                <% }
                                                            } else { %>
                                                                Guest
                                                            <% } %>
                                                        </td>
                                                        <td><%= orderItems.size() == 1 ? firstItem.getTourName() : orderItems.size() + " prodotti" %></td>
                                                        <td><%= totalQuantity %></td>
                                                        <td><%= priceFormat.format(totalAmount) %> €</td>
                                                        <td>
                                                            <span class="order-status completed">
                                                                Completato
                                                            </span>
                                                        </td>
                                                    </tr>
                                                <% 
                                                    }
                                                } else {
                                                %>
                                                    <tr>
                                                        <td colspan="7" style="text-align: center;">Nessun ordine trovato con i filtri selezionati.</td>
                                                    </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                    <% } else { %>
                                        <div class="no-results">
                                            <p>Nessun ordine trovato con i filtri selezionati.</p>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <%-- Logout per admin --%>
                <form action="/AniTour/logout" method="post" class="logout-form admin-logout">
                    <button type="submit" class="btn1">Logout</button>
                </form>
                <% } %>
                
                <%-- Mostra "I miei ordini" solo per utenti non-admin --%>
                <% if (!isAdmin) { %>
                <div class="orders-section">
                    <h3>I miei ordini</h3>
                    
                    <% 
                    List<Map<String, Object>> orderGroups = (List<Map<String, Object>>) request.getAttribute("orderGroups");
                    if (orderGroups != null && !orderGroups.isEmpty()) {
                        for (Map<String, Object> orderGroup : orderGroups) {
                            String orderIdentifier = (String) orderGroup.get("identifier");
                            Timestamp orderDate = (Timestamp) orderGroup.get("date");
                            double totalAmount = (double) orderGroup.get("totalAmount");
                            List<Booking> orderItems = (List<Booking>) orderGroup.get("items");
                    %>
                    
                    <div class="order-card">
                        <div class="order-header">
                            <div class="order-header-top">
                                <div class="order-id">Ordine: <%= orderIdentifier %></div>
                                <div class="order-date"><%= dateFormat.format(orderDate) %></div>
                            </div>
                            <div class="order-status completed">
                                <i class="fas fa-check-circle"></i> Completato
                            </div>
                        </div>
                        
                        <div class="order-items">
                            <% for (Booking item : orderItems) { %>
                                <div class="order-item">
                                    <div class="item-image">
                                        <img src="<%= item.getTourImagePath() %>" alt="<%= item.getTourName() %>">
                                    </div>
                                    <div class="item-details">
                                        <h4><%= item.getTourName() %></h4>
                                        <p>Quantità: <%= item.getQuantity() %></p>
                                        <p>Prezzo: <%= priceFormat.format(item.getPrice()) %> €</p>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="order-footer">
                            <div class="order-total">
                                Totale: <%= priceFormat.format(totalAmount) %> €
                            </div>
                        </div>
                    </div>
                    
                    <% 
                        }
                    } else {
                    %>
                        <p class="no-orders">Non hai ancora effettuato ordini.</p>
                    <% } %>
                    
                    <%-- Logout sempre visibile sotto la sezione ordini --%>
                    <form action="/AniTour/logout" method="post" class="logout-form">
                        <button type="submit" class="btn1">Logout</button>
                    </form>
                </div>
                <% } %>
            </div>
        </div>
        
        <% if (isAdmin) { %>
        <script src="/AniTour/scripts/profileAdmin.js"></script>
        <script src="/AniTour/scripts/ordersFilter.js"></script>
        <% } %>
    </body>
</html>