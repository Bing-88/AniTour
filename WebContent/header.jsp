<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="header-content">
    <div id="header-left"></div> 
    <div id="header-center">
        <a href="/AniTour/home">
            <img src="/AniTour/images/logo_anitour_full.png" alt="Logo" class="img-center" id="logo-full">
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
<script src="/AniTour/scripts/logo-responsive.js"></script>
