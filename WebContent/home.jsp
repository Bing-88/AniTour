<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>AniTour</title>
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
                
                <form action="/AniTour/search" method="GET" class="search-form">
                    <div class="search-labels">
                        <span class="search-element">Dove</span>
                        <span class="search-element">Tema</span>
                        <span class="search-element">Date</span>
                        <span class="search-element">Budget</span>
                    </div>
                    <div class="search-bar-wrapper">
                        <input 
                            name="search-bar" 
                            class="search-bar" 
                            type="text" 
                            placeholder="Dove ti porta la tua fantasia?">
                        <img src="/AniTour/images/search-icon.png" alt="" class="search-icon">
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
    </body>
</html>