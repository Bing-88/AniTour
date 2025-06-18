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
        <header class="fixed-header">
            <div class="header-content">
                <div class="header-left">

                </div> 
                <div class="header-center">
                  <a href="/AniTour/home.jsp">
                    <img src="/AniTour/images/logo_anitour_full.png" alt="Logo" class="img-center" id="logo-full">
                  </a> 
                </div>
                <div class="header-right">
                    <a href="login.jsp">
                        <img src="/AniTour/images/user-icon.png" alt="icona" class="login-icon">
                    </a>
                </div>
            </div>
        </header>
        <div class="main-content" id="main-content">
        <div class="title-wrapper">
            <p class="title1">Travel with your</p>
            <p class="title1 highlighted-text">FANTASY</p>
        </div>
        <form action="" method="POST" class="search-form">
            <div class="search-labels">
            <p class="search-element">Dove</p>
            <p class="search-element">Tema</p>
            <p class="search-element">Date</p>
            <p class="search-element">Budget</p>
            </div>
            <div class="search-bar-wrapper">
                <input name="search-bar" class="search-bar" type="text" placeholder="Dove ti porta la tua fantasia?">
                <img src="/AniTour/images/search-icon.png" alt="Search" class="search-icon">
            </div>
        </form>
        </div>
    </body>
</html>