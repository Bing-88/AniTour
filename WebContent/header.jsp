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
        <a href="/AniTour/cart" class="cart-icon-wrapper">
            <img src="/AniTour/images/cart.svg" alt="Carrello" class="cart-icon">
            <span class="cart-count" id="cart-count" style="opacity: 0; transition: opacity 0.3s ease;">0</span>
        </a>
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
    
    /* Stili per l'icona del carrello */
    .cart-icon-wrapper {
        position: relative;
        margin-right: 1rem;
    }
    
    .cart-icon {
        width: 28px;
        height: 28px;
        cursor: pointer;
        transition: all 0.3s ease;
    }
    
    .cart-icon:hover {
        transform: scale(1.1);
    }
    
    .cart-count {
        position: absolute;
        top: -8px;
        right: -8px;
        background-color: var(--primary);
        color: white;
        font-size: 0.7rem;
        font-weight: bold;
        width: 18px;
        height: 18px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
    }
    
    #header-right {
        display: flex;
        align-items: center;
        justify-content: flex-end;
    }
</style>

<script src="/AniTour/scripts/logo-responsive.js"></script>
<script src="/AniTour/scripts/cart-count.js"></script>
