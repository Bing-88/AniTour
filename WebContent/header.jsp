<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="header-content">
    <div id="header-left"></div> 
    <div id="header-center">
        <a href="/AniTour/home">
            <img src="/AniTour/images/logo_anitour_full.png" alt="Logo" class="img-center" id="logo-full">
            <img src="/AniTour/images/logo_anitour.png" alt="Logo" class="img-center" id="logo-small">
        </a> 
    </div>
    <div id="header-right">
        <% if (session.getAttribute("username") != null) { %>
            <a href="/AniTour/profile">
                <img src="/AniTour/images/user-icon.png" alt="icona" class="login-icon">
            </a>
        <% } else { %>
            <a href="/AniTour/login">
                <img src="/AniTour/images/user-icon.png" alt="icona" class="login-icon">
            </a>
        <% } %>
    </div>
</div>

<style>
    /* Stili inline per il caricamento iniziale del logo */
    @media (max-width: 600px) {
        #logo-full {
            display: none !important;
        }
        #logo-small {
            display: block !important;
            height: 40px;
            transition: transform 0.3s ease;
        }
    }
    
    @media (min-width: 601px) {
        #logo-small {
            display: none !important;
        }
        #logo-full {
            display: block !important;
        }
    }
</style>

<script src="/AniTour/scripts/logo-responsive.js"></script>
