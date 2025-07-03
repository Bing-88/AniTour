<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, it.anitour.model.Booking, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Checkout - AniTour</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="/AniTour/styles/style.css">
    <link rel="stylesheet" href="/AniTour/styles/checkout.css">
    <link rel="icon" href="/AniTour/images/anitour.ico">
</head>
<body>
    <div class="page-container">
        <header id="fixed-header">
            <%@ include file="header.jsp" %>
        </header>

        <div class="main-content">
            <h1 class="page-title">Checkout</h1>
            
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <div class="error-banner">
                <%= error %>
            </div>
            <% } %>
            
            <% 
                List<Booking> cartItems = (List<Booking>) request.getAttribute("cartItems");
                if (cartItems == null || cartItems.isEmpty()) {
                    response.sendRedirect("/AniTour/cart");
                    return;
                }
                
                DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
                double total = 0;
                for (Booking item : cartItems) {
                    total += item.getPrice() * item.getQuantity();
                }
            %>
            
            <div class="checkout-container">
                <div class="checkout-form">
                    <h2>Informazioni di spedizione</h2>
                    <form id="checkoutForm" action="/AniTour/checkout" method="post">
                        <div class="form-group">
                            <label for="shippingName">Nome completo</label>
                            <input type="text" id="shippingName" name="shippingName" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="shippingEmail">Email</label>
                            <input type="email" id="shippingEmail" name="shippingEmail" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="shippingPhone">Telefono</label>
                            <input type="tel" id="shippingPhone" name="shippingPhone" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="shippingAddress">Indirizzo</label>
                            <input type="text" id="shippingAddress" name="shippingAddress" required>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group half">
                                <label for="shippingCity">Città</label>
                                <input type="text" id="shippingCity" name="shippingCity" required>
                            </div>
                            
                            <div class="form-group half">
                                <label for="shippingPostalCode">CAP</label>
                                <input type="text" id="shippingPostalCode" name="shippingPostalCode" required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="shippingCountry">Paese</label>
                            <input type="text" id="shippingCountry" name="shippingCountry" required>
                        </div>
                        
                        <h2>Dati di pagamento</h2>
                        <div class="form-group">
                            <label for="cardNumber">Numero carta di credito</label>
                            <input type="text" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" required>
                        </div>

                        <div class="form-row">
                            <div class="form-group half">
                                <label for="cardExpiry">Data di scadenza (MM/AA)</label>
                                <input type="text" id="cardExpiry" name="cardExpiry" placeholder="MM/AA" required>
                            </div>
                            
                            <div class="form-group half">
                                <label for="cardCvv">CVV</label>
                                <input type="text" id="cardCvv" name="cardCvv" placeholder="123" required maxlength="3">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="cardHolder">Intestatario carta</label>
                            <input type="text" id="cardHolder" name="cardHolder" required>
                        </div>
                        
                        <div class="checkout-actions">
                            <a href="/AniTour/cart" class="btn-back">Torna al carrello</a>
                            <button type="submit" class="btn-place-order">Effettua ordine</button>
                        </div>
                    </form>
                </div>
                
                <div class="order-summary">
                    <h2>Riepilogo ordine</h2>
                    <div class="summary-items">
                        <% for (Booking item : cartItems) { %>
                            <div class="summary-item">
                                <div class="summary-item-details">
                                    <h3><%= item.getTourName() %></h3>
                                    <p>Quantità: <%= item.getQuantity() %></p>
                                </div>
                                <div class="summary-item-price">
                                    <%= priceFormat.format(item.getPrice() * item.getQuantity()) %> €
                                </div>
                            </div>
                        <% } %>
                    </div>
                    
                    <div class="summary-total">
                        <span>Totale:</span>
                        <span class="total-price"><%= priceFormat.format(total) %> €</span>
                    </div>
                </div>
            </div>
        </div>

        <footer>
            <%@ include file="footer.jsp" %>
        </footer>
    </div>

    <script src="/AniTour/scripts/checkout-validation.js"></script>
</body>
</html>