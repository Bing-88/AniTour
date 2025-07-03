package it.anitour.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import it.anitour.model.Booking;
import it.anitour.model.BookingDAO;
import it.anitour.model.User;
import it.anitour.model.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Flag per assicurarsi che la riparazione avvenga solo una volta
    private static boolean repairExecuted = false;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Ripara gli order_identifier mancanti solo al primo accesso
        if (!repairExecuted) {
            try {
                BookingDAO bookingDAO = new BookingDAO();
                bookingDAO.repairMissingOrderIdentifiers();
                repairExecuted = true;
            } catch (SQLException e) {
                System.err.println("Errore durante la riparazione degli order_identifier: " + e.getMessage());
            }
        }
        
        // Verifica se l'utente è loggato
        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null) {
            response.sendRedirect("/AniTour/login");
            return;
        }
        
        String userType = (String) session.getAttribute("type");
        boolean isAdmin = "admin".equals(userType);
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Gestione messaggi di successo/errore per l'aggiornamento tour
        String updateTourSuccess = request.getParameter("updateTourSuccess");
        String updateTourError = request.getParameter("updateTourError");
        
        if ("true".equals(updateTourSuccess)) {
            request.setAttribute("updateTourSuccess", "Tour aggiornato con successo!");
        } else if (updateTourError != null) {
            String errorMessage;
            switch (updateTourError) {
                case "missing_id":
                    errorMessage = "ID tour non specificato";
                    break;
                case "tour_not_found":
                    errorMessage = "Tour non trovato";
                    break;
                case "missing_fields":
                    errorMessage = "Tutti i campi sono obbligatori";
                    break;
                case "invalid_dates":
                    errorMessage = "La data di fine deve essere successiva alla data di inizio";
                    break;
                case "no_stops":
                    errorMessage = "È necessario specificare almeno una tappa";
                    break;
                case "format":
                    errorMessage = "Formato prezzo o date non valido";
                    break;
                case "database":
                    errorMessage = "Errore del database";
                    break;
                case "unexpected":
                    errorMessage = "Errore imprevisto";
                    break;
                default:
                    errorMessage = "Errore sconosciuto";
                    break;
            }
            request.setAttribute("updateTourError", errorMessage);
        }
        
        // Se l'utente è admin, carica dati aggiuntivi
        if (isAdmin) {
            try {
                // Carica la lista degli utenti
                UserDAO userDAO = new UserDAO();
                List<User> userList = userDAO.findAll();
                request.setAttribute("userList", userList);
                
                // Carica gli utenti che hanno effettuato ordini (per il filtro)
                BookingDAO bookingDAO = new BookingDAO();
                List<User> usersWithOrders = bookingDAO.getUsersWithOrders();
                request.setAttribute("usersWithOrders", usersWithOrders);
                
                // Carica statistiche generali
                Map<String, Object> orderStats = bookingDAO.getOrdersStatistics();
                request.setAttribute("orderStats", orderStats);
                
                // Gestione dei parametri di filtro ordini
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                String clientIdStr = request.getParameter("clientId");
                String ajaxParam = request.getParameter("ajax");
                boolean isAjaxRequest = ajaxParam != null && "true".equals(ajaxParam);
                
                Date startDate = null;
                Date endDate = null;
                Integer clientId = null;
                
                if (startDateStr != null && !startDateStr.isEmpty()) {
                    try {
                        startDate = Date.valueOf(startDateStr);
                    } catch (IllegalArgumentException e) {
                        e.printStackTrace();
                    }
                }
                
                if (endDateStr != null && !endDateStr.isEmpty()) {
                    try {
                        endDate = Date.valueOf(endDateStr);
                    } catch (IllegalArgumentException e) {
                        e.printStackTrace();
                    }
                }
                
                if (clientIdStr != null && !clientIdStr.isEmpty()) {
                    try {
                        clientId = Integer.parseInt(clientIdStr);
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    }
                }
                
                List<Booking> filteredOrders = new ArrayList<>();
                // Carica gli ordini filtrati e raggruppati
                try {
                    Map<String, List<Booking>> filteredOrdersGrouped = bookingDAO.getFilteredOrdersGrouped(startDate, endDate, clientId);
                    request.setAttribute("filteredOrdersGrouped", filteredOrdersGrouped);
                    
                    // Crea la lista semplificata per la visualizzazione
                    for (List<Booking> orderItems : filteredOrdersGrouped.values()) {
                        if (!orderItems.isEmpty()) {
                            filteredOrders.add(orderItems.get(0));
                        }
                    }
                    request.setAttribute("filteredOrders", filteredOrders);
                    
                    // Se è una richiesta AJAX, rispondi con il frammento HTML della tabella
                    if (isAjaxRequest) {
                        response.setContentType("text/html");
                        response.setCharacterEncoding("UTF-8");
                        
                        // Genera l'HTML della tabella direttamente
                        StringBuilder htmlBuilder = new StringBuilder();
                        SimpleDateFormat dateFormatter = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        DecimalFormat priceFormatter = new DecimalFormat("#,##0.00");
                        
                        if (filteredOrders.isEmpty()) {
                            htmlBuilder.append("<div class=\"no-results\">");
                            htmlBuilder.append("<p>Nessun ordine trovato con i filtri selezionati.</p>");
                            htmlBuilder.append("</div>");
                        } else {
                            htmlBuilder.append("<table class=\"orders-table\">");
                            htmlBuilder.append("<thead>");
                            htmlBuilder.append("<tr>");
                            htmlBuilder.append("<th>ID Ordine</th>");
                            htmlBuilder.append("<th>Cliente</th>");
                            htmlBuilder.append("<th>Data</th>");
                            htmlBuilder.append("<th>Totale</th>");
                            htmlBuilder.append("<th>Stato</th>");
                            htmlBuilder.append("</tr>");
                            htmlBuilder.append("</thead>");
                            htmlBuilder.append("<tbody>");
                            
                            for (Booking order : filteredOrders) {
                                String orderIdentifier = order.getOrderIdentifier();
                                List<Booking> orderItems = filteredOrdersGrouped.get(orderIdentifier);
                                double totalAmount = orderItems.stream().mapToDouble(item -> item.getPrice() * item.getQuantity()).sum();
                                
                                htmlBuilder.append("<tr>");
                                htmlBuilder.append("<td>").append(orderIdentifier).append("</td>");
                                htmlBuilder.append("<td>").append(order.getShippingName() != null ? order.getShippingName() : "N/D").append("</td>");
                                htmlBuilder.append("<td>").append(dateFormatter.format(order.getBookingDate())).append("</td>");
                                htmlBuilder.append("<td>").append(priceFormatter.format(totalAmount)).append(" €</td>");
                                htmlBuilder.append("<td><span class=\"order-status completed\">Completato</span></td>");
                                htmlBuilder.append("</tr>");
                            }
                            
                            htmlBuilder.append("</tbody>");
                            htmlBuilder.append("</table>");
                        }
                        
                        response.getWriter().write(htmlBuilder.toString());
                        return;
                    }
                    
                    request.setAttribute("startDateFilter", startDateStr);
                    request.setAttribute("endDateFilter", endDateStr);
                    request.setAttribute("clientIdFilter", clientIdStr);
                    
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Si è verificato un errore durante il caricamento degli ordini");
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Errore nel caricamento dei dati amministratore");
            }
        } else {
            // Per gli utenti normali, carica gli ordini raggruppati usando la stessa logica dell'admin
            if (userId != null) {
                try {
                    BookingDAO bookingDAO = new BookingDAO();
                    
                    // Usa getFilteredOrdersGrouped senza filtri, solo per questo utente
                    Map<String, List<Booking>> allOrdersGrouped = bookingDAO.getFilteredOrdersGrouped(null, null, userId);
                    
                    // Converte il Map in List<Map<String, Object>> come si aspetta la JSP
                    List<Map<String, Object>> orderGroups = new ArrayList<>();
                    for (Map.Entry<String, List<Booking>> entry : allOrdersGrouped.entrySet()) {
                        String orderIdentifier = entry.getKey();
                        List<Booking> orderItems = entry.getValue();
                        
                        if (orderItems != null && !orderItems.isEmpty()) {
                            Map<String, Object> orderGroup = new HashMap<>();
                            orderGroup.put("identifier", orderIdentifier);
                            orderGroup.put("items", orderItems);
                            
                            Booking firstItem = orderItems.get(0);
                            orderGroup.put("date", firstItem.getBookingDate());
                            orderGroup.put("status", firstItem.getStatus());
                            
                            // Calcola il totale
                            double totalAmount = 0;
                            for (Booking item : orderItems) {
                                totalAmount += item.getPrice() * item.getQuantity();
                            }
                            orderGroup.put("totalAmount", totalAmount);
                            
                            orderGroups.add(orderGroup);
                        }
                    }
                    
                    request.setAttribute("orderGroups", orderGroups);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        // Solo per richieste non-AJAX
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}