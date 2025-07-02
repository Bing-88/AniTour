<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="it.anitour.model.Tour, it.anitour.model.Stop, java.util.List, java.text.SimpleDateFormat, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <% Tour tour = (Tour) request.getAttribute("tour"); %>
    <title><%= tour.getName() %> - AniTour</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="/AniTour/styles/style.css">
    <link rel="stylesheet" href="/AniTour/styles/tour-details.css">
    <link rel="icon" href="/AniTour/images/anitour.ico">
</head>
<body>
    <div class="page-container">
        <header id="fixed-header">
            <%@ include file="header.jsp" %>
        </header>

        <div class="main-content">
            <div class="back-button">
                <a href="/AniTour/tours" class="back-link">
                    <img src="/AniTour/images/back-arrow.svg" alt="Torna indietro" class="back-icon">
                    <span>Torna ai tour</span>
                </a>
            </div>
            
            <div class="tour-header">
                <div class="image-container">
                    <img src="<%= tour.getImagePath() %>" alt="<%= tour.getName() %>" class="tour-image">
                    <div class="tour-title-overlay">
                        <h1><%= tour.getName() %></h1>
                    </div>
                </div>
            </div>
            
            <div class="tour-details">
                <div class="tour-description">
                    <%= tour.getDescription() %>
                </div>
                
                <div class="tour-info">
                    <%
                        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy");
                        DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
                    %>
                    <p><strong>Date:</strong> Dal <%= dateFormat.format(tour.getStartDate()) %> al <%= dateFormat.format(tour.getEndDate()) %></p>
                    <p><strong>Prezzo:</strong> <%= priceFormat.format(tour.getPrice()) %> €</p>
                </div>
                
                <div class="tour-stops">
                    <h2>Tappe del tour</h2>
                    <div class="stops-container">
                    <% 
                        List<Stop> stops = tour.getStops();
                        if (stops != null) {
                            int stopNumber = 1;
                            for (Stop stop : stops) { 
                    %>
                        <div class="stop-card">
                            <div class="stop-number"><%= stopNumber %></div>
                            <div class="stop-content">
                                <h3><%= stop.getName() %></h3>
                                <p><%= stop.getDescription() %></p>
                            </div>
                        </div>
                    <% 
                                stopNumber++;
                            }
                        }
                    %>
                    </div>
                </div>
                
                <% if (session.getAttribute("username") != null) { %>
                <div class="booking-section">
                    <form action="/AniTour/book" method="post">
                        <input type="hidden" name="tourId" value="<%= tour.getId() %>">
                        <button type="submit" class="btn1">Prenota ora</button>
                    </form>
                </div>
                <% } else { %>
                <div class="login-prompt">
                    <p>Effettua il <a href="/AniTour/login">login</a> per prenotare questo tour.</p>
                </div>
                <% } %>
            </div>
        </div>

        <footer>
            <%@ include file="footer.jsp" %>
        </footer>
    </div>
</body>
</html>