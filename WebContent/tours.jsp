<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List, it.anitour.model.Tour" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>AniTour</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/AniTour/styles/style.css">
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
                    List<Tour> tours = (List<Tour>) request.getAttribute("tours");
                    if (tours == null || tours.isEmpty()) {
                        out.println("<p class='no-tours'>Nessun tour disponibile al momento.</p>");
                    } else {
                        for (Tour tour : tours) {
                %>
                    <div class="card">
                        <img class="card-img" src="<%= tour.getImagePath() %>" alt="<%= tour.getName() %>">
                        <div class="card-title"><%= tour.getName() %></div>
                        <div class="card-text">
                            <%= tour.getDescription() %>
                            <div class="date">
                                Dal <%= tour.getStartDate() %> al <%= tour.getEndDate() %>
                            </div>
                        </div>
                        <div class="prezzo">da <%= tour.getPrice() %>&euro;</div>
                    </div>
                <%
                        }
                    }
                %>
              </div>

        <footer>
            <%@ include file="footer.jsp" %>
        </footer>
    </body>
</html>