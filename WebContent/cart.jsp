<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, it.anitour.model.Booking, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Carrello - AniTour</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="/AniTour/styles/style.css">
    <link rel="stylesheet" href="/AniTour/styles/cart.css">
    <link rel="icon" href="/AniTour/images/anitour.ico">
</head>
<body>
    <div class="page-container">
        <header id="fixed-header">
            <%@ include file="header.jsp" %>
        </header>

        <div class="main-content">
            <h1 class="page-title">Il tuo carrello</h1>
            
            <% 
                List<Booking> cartItems = (List<Booking>) request.getAttribute("cartItems");
                DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
                double total = 0;
                
                if (cartItems == null || cartItems.isEmpty()) {
            %>
                <div class="empty-cart">
                    <p>Il tuo carrello è vuoto</p>
                    <button class="btn1" onclick="window.location.href='/AniTour/tours'">Esplora i tour</button>
                </div>
            <% } else { %>
                <div class="cart-container">
                    <div class="cart-items">
                        <% for (Booking item : cartItems) { 
                            total += item.getPrice() * item.getQuantity();
                        %>
                            <div class="cart-item">
                                <div class="item-image">
                                    <img src="<%= item.getTourImagePath() %>" alt="<%= item.getTourName() %>">
                                </div>
                                <div class="item-details">
                                    <h3><%= item.getTourName() %></h3>
                                    <p class="item-price"><%= priceFormat.format(item.getPrice()) %> €</p>
                                    <div class="quantity-controls">
                                        <form action="/AniTour/cart/update" method="post" class="quantity-form">
                                            <input type="hidden" name="bookingId" value="<%= item.getId() %>">
                                            <label for="quantity-<%= item.getId() %>">Quantità:</label>
                                            <input type="number" id="quantity-<%= item.getId() %>" 
                                                name="quantity" value="<%= item.getQuantity() %>" 
                                                min="1" max="10" class="quantity-input">
                                            <button type="submit" class="btn-update">Aggiorna</button>
                                        </form>
                                        <a href="/AniTour/cart/remove?tourId=<%= item.getTourId() %>" class="btn-remove">
                                            Rimuovi
                                        </a>
                                    </div>
                                </div>
                                <div class="item-total">
                                    <%= priceFormat.format(item.getPrice() * item.getQuantity()) %> €
                                </div>
                            </div>
                        <% } %>
                    </div>
                    
                    <div class="cart-summary">
                        <div class="summary-row">
                            <span>Totale:</span>
                            <span class="total-price"><%= priceFormat.format(total) %> €</span>
                        </div>
                        <div class="cart-actions">
                            <a href="/AniTour/tours" class="btn-continue">Continua lo shopping</a>
                            
                            <% if (session.getAttribute("username") != null) { %>
                                <a href="/AniTour/checkout" class="btn-checkout">Procedi al checkout</a>
                            <% } else { %>
                                <a href="/AniTour/login?redirect=checkout" class="btn-checkout">Accedi per procedere all'acquisto</a>
                            <% } %>
                        </div>
                        <div class="clear-cart">
                            <a href="/AniTour/cart/clear" class="btn-clear">Svuota carrello</a>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>

        <footer>
            <%@ include file="footer.jsp" %>
        </footer>
    </div>
</body>
</html>