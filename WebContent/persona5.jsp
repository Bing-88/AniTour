<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Persona 5</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/AniTour/styles/style.css">
        <link rel="icon" href="/AniTour/images/anitour.ico">
    </head>
    <body class="bg">
        <div class="page-container">
            <header id="fixed-header">
                <%@ include file="header.jsp" %>
            </header>
            <div class="main-content" id="main-content">
                <div class="cardp5">
                    <div class="persona5-balloon">
                        <div class="persona5-balloon-border"></div>
                        <div class="persona5-balloon-shape">
                            <h1 class="persona5-balloon-title">
                              TOUR PER<span>S</span>ONA 5
                            </h1>
                        </div>
                    </div>
                    <h2>Cuori da Rubare: Viaggio tra Maschere e Metropoli</h2>
                    <div class="p5-date">
                        🗓️ Dal 
                        <span class="p5-date-box date-only">
                            <span class="p5-date-inner">24</span>
                        </span> 
                        giugno al 
                        <span class="p5-date-box date-only">
                            <span class="p5-date-inner">7</span>
                        </span> 
                        luglio<br>
                        📍 Tok<span class="p5-date-box" style="margin: 0"><!-- Rimozione spazio -->
                            <span class="p5-date-inner">y</span>
                        </span>o e din<span class="p5-date-box" style="margin: 0"><!-- Rimozione spazio -->
                            <span class="p5-date-inner">t</span>
                        </span>orni<br>
                    </div>
                    <div class="card-text" id="p5-main-text">
                        <p>Unisciti a noi in un viaggio tra le strade pulsanti di Tokyo,
                        dove realtà e Metaverso si intrecciano.</p>
                        
                        <p>Scoprirai i luoghi che hanno ispirato l'iconico Persona 5, 
                        tra caffè nascosti, quartieri pieni di luci e misteri,
                        e atmosfere sospese tra ribellione e introspezione.</p>
                        
                        <p>Indossa la tua maschera. Il cuore della città ti aspetta.</p>
                    </div>
                    <div>
                        <ol id="p5-locations">
                            <li>
                                <strong>Shibuya Crossing & Station – "La Porta del Metaverso"</strong><br>
                                Dove tutto ha inizio: esplora il famoso incrocio, la statua di Hachikō, e l'area intorno all'iconica stazione, proprio come i protagonisti.
                            </li>
                            <li>
                                <strong>Yongen-Jaya – "Il Quartiere Segreto"</strong><br>
                                Visita il quartiere reale di Sangenjaya, che ha ispirato la zona di casa del protagonista e il Café Leblanc. Caffè artigianale incluso.
                            </li>
                            <li>
                                <strong>Shinjuku – "Tra Luci e Inganni"</strong><br>
                                Passeggiata tra le luci al neon, il distretto a lucirossse e i vicoli pieni di segreti. 
                                Cena tematica in un locale ispirato al Jazz Jin.
                            </li>
                            <li>
                                <strong>Akihabara – "Maschere e Ribellione"</strong><br>
                                Tappa otaku per eccellenza: gadget, cosplay e un mini evento Phantom Thieves Fan Club con quiz e photo booth.
                            </li>
                            <li>
                                <strong>Mitaka – "I Sogni oltre il Velo"</strong><br>
                                Gita al <em>Museo Ghibli</em>, tra sogno e realtà: una deviazione simbolica, perfetta per evocare l'atmosfera alternativa del Metaverso.
                            </li>
                            <li>
                                <strong>Tokyo Metropolitan Government Building – "Il Palazzo del Potere"</strong><br>
                                Salita panoramica con vista su Tokyo: simbolo della verticalità e corruzione dei "Palazzi" mentali. Briefing finale in stile Ladri Fantasma.
                            </li>
                        </ol>
                    </div>
                    <div class="p5-buy-container">
                        <button class="p5-buy-btn">
                            <span class="p5-texteffect" style="--letter-index: 0;">A</span>C<span class="p5-texteffect" style="--letter-index: 1;">Q</span>UIST<span class="p5-texteffect" style="--letter-index: 2;">A</span> OR<span class="p5-texteffect" style="--letter-index: 3;">A</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <footer class="footerp5">
            <%@ include file="footer.jsp" %>
        </footer>
        
        <script src="/AniTour/scripts/persona5.js"></script>
    </body>
</html>
