<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Home - AniTour</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="AniTour is an e-commerce service that provides nerd-themed tours all around the world!">
        <link rel="stylesheet" href="/AniTour/styles/style.css">
        <link rel="stylesheet" href="/AniTour/styles/home.css">
        <link rel="icon" href="/AniTour/images/anitour.ico">
    </head>
    <body>
        <div class="page-container">
            <header id="fixed-header">
                <%@ include file="header.jsp" %>
            </header>

            <main class="main-content" id="main-content">
                <div class="title-wrapper">
                    <h1 class="title1">Travel with your</h1>
                    <h1 class="title1 highlighted-text">FANTASY</h1>
                </div>
                
                <form action="/AniTour/tours" method="GET" class="search-form" id="searchForm">
                    <div class="search-labels">
                        <span class="search-element active" data-type="theme">Tema</span>
                        <span class="search-element" data-type="date">Date</span>
                        <span class="search-element" data-type="budget">Budget</span>
                    </div>
                    
                    <div class="search-inputs-container">
                        <div class="search-input active" id="theme-search">
                            <div class="search-bar-wrapper">
                                <input 
                                    name="theme" 
                                    class="search-bar" 
                                    type="text" 
                                    placeholder="Dove ti porta la tua fantasia?">
                            </div>
                        </div>
                        
                        <!-- Ricerca per date -->
                        <div class="search-input" id="date-search">
                            <div class="date-inputs">
                                <div class="date-input-group">
                                    <label for="startDate">Data inizio</label>
                                    <input type="date" id="startDate" name="startDate" class="date-picker">
                                </div>
                                <div class="date-input-group">
                                    <label for="endDate">Data fine</label>
                                    <input type="date" id="endDate" name="endDate" class="date-picker">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Ricerca per budget -->
                        <div class="search-input" id="budget-search">
                            <div class="budget-inputs">
                                <div class="price-inputs">
                                    <div class="price-input-group">
                                        <label for="minPrice">Prezzo minimo (€)</label>
                                        <input type="number" id="minPrice" name="minPrice" min="0" step="any" value="0" class="price-number">
                                        <p class="error-message" id="minPriceError"></p>
                                    </div>
                                    <div class="price-input-group">
                                        <label for="maxPrice">Prezzo massimo (€)</label>
                                        <input type="number" id="maxPrice" name="maxPrice" min="0" step="any" value="1" class="price-number">
                                        <p class="error-message" id="maxPriceError"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="search-button-wrapper">
                        <button type="submit" class="btn1">Cerca</button>
                    </div>
                </form>
                
                <div class="tours-button-wrapper">
                    <button type="button" class="btn1" onclick="window.location.href='/AniTour/tours'">
                        Esplora tutti i tour
                    </button>
                </div>
            </main>

            <footer>
                <%@ include file="footer.jsp" %>
            </footer>
        </div>
        
        <script src="/AniTour/scripts/searchForm.js"></script>
    </body>
</html>