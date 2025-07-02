<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List, it.anitour.model.Tour" %>
<%@ page import="java.text.SimpleDateFormat, java.text.DecimalFormat" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>AniTour</title>
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
              <h1 class="title1" style="color: var(--primary);">TOUR DISPONIBILI</h1>
              <div class="card-container">
                <%
                    //per eseguire la servlet quando si va in questa pagina (se non è già stata eseguita)
                    if (request.getAttribute("tours") == null) {
                        response.sendRedirect("tours");
                        return;
                    }

                    List<Tour> tours = (List<Tour>) request.getAttribute("tours");
                    if (tours == null || tours.isEmpty()) {
                        out.println("<p class='no-tours'>Nessun tour disponibile al momento.</p>");
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
            </div>
        <footer>
            <%@ include file="footer.jsp" %>
        </footer>
    </body>
</html>