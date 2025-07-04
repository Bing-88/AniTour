<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List, it.anitour.model.Tour" %>
<%@ page import="java.text.SimpleDateFormat, java.text.DecimalFormat" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Tours - AniTour</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/AniTour/styles/style.css">
        <link rel="stylesheet" href="/AniTour/styles/tours.css">
        <link rel="icon" href="/AniTour/images/anitour.ico">
    </head>
    <body>
        <div class="page-container">
            <header id="fixed-header">
                <%@ include file="header.jsp" %>
            </header>

            <div class="main-content" id="main-content">
                <%
                    String searchType = (String) request.getAttribute("searchType");
                    if (searchType != null) {
                        if (searchType.equals("theme")) {
                            String searchQuery = (String) request.getAttribute("searchQuery");
                %>
                    <h1 class="title1" style="color: var(--primary);">RISULTATI RICERCA: "<%= searchQuery %>"</h1>
                <% 
                        } else if (searchType.equals("date")) {
                            String startDate = (String) request.getAttribute("startDate");
                            String endDate = (String) request.getAttribute("endDate");
                %>
                    <h1 class="title1" style="color: var(--primary);">TOUR PER DATE</h1>
                    <p class="search-info">
                        <% if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) { %>
                            Dal <%= startDate %> al <%= endDate %>
                        <% } else if (startDate != null && !startDate.isEmpty()) { %>
                            A partire dal <%= startDate %>
                        <% } else if (endDate != null && !endDate.isEmpty()) { %>
                            Fino al <%= endDate %>
                        <% } %>
                    </p>
                <% 
                        } else if (searchType.equals("budget")) {
                            Double minPrice = (Double) request.getAttribute("minPrice");
                            Double maxPrice = (Double) request.getAttribute("maxPrice");
                            DecimalFormat currencyFormat = new DecimalFormat("#,##0.00");
                %>
                    <h1 class="title1" style="color: var(--primary);">TOUR PER BUDGET</h1>
                    <p class="search-info">
                        Da <%= currencyFormat.format(minPrice) %>€ a <%= currencyFormat.format(maxPrice) %>€
                    </p>
                <% 
                        }
                    } else {
                %>
                    <h1 class="title1" style="color: var(--primary);">TOUR DISPONIBILI</h1>
                <% } %>
                
                <div class="card-container">
                <%
                    //per eseguire la servlet quando si va in questa pagina (se non è già stata eseguita)
                    if (request.getAttribute("tours") == null) {
                        response.sendRedirect("tours");
                        return;
                    }

                    List<Tour> tours = (List<Tour>) request.getAttribute("tours");
                    if (tours == null || tours.isEmpty()) {
                        out.println("<p class='no-tours'>Nessun tour disponibile per questa ricerca.</p>");
                    } else {
                        // Formattatori per date e prezzi
                        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                        DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
                        
                        for (Tour tour : tours) {
                            // Formattazione delle date
                            String startDateFormatted = dateFormat.format(tour.getStartDate());
                            String endDateFormatted = dateFormat.format(tour.getEndDate());
                            
                            // Formattazione del prezzo
                            String priceFormatted = priceFormat.format(tour.getPrice());
                %>
                    <a href="/AniTour/tour/<%= tour.getSlug() %>">
                        <div class="card">
                            <img class="card-img" src="<%= tour.getImagePath() %>" alt="<%= tour.getName() %>">
                            <div class="card-title"><%= tour.getName() %></div>
                            <div class="card-text">
                                <%= tour.getDescription() %>
                                <div class="date">
                                    Dal <%= startDateFormatted %> al <%= endDateFormatted %>
                                </div>
                            </div>
                            <div class="prezzo">da <%= priceFormatted %>&euro;</div>
                        </div>
                    </a>
                <%
                        }
                    }
                %>
                </div>
                
                <div class="back-button">
                    <button class="btn1" onclick="window.location.href='/AniTour/home'">Torna alla ricerca</button>
                </div>
            </div>
            
            <footer>
                <%@ include file="footer.jsp" %>
            </footer>
        </div>
    </body>
</html>