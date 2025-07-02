document.addEventListener('DOMContentLoaded', function() {
    const logoFull = document.getElementById('logo-full');
    const logoSmall = document.getElementById('logo-small');
    
    // Funzione che gestisce la visualizzazione del logo basata sulla larghezza della finestra
    function handleLogoVisibility() {
        if (window.innerWidth <= 600) {
            logoFull.style.display = 'none';
            logoSmall.style.display = 'block';
        } else {
            logoFull.style.display = 'block';
            logoSmall.style.display = 'none';
        }
    }
    
    // Ascoltatore per il ridimensionamento della finestra
    window.addEventListener('resize', handleLogoVisibility);
    
    // Chiamata iniziale per impostare la corretta visibilità
    handleLogoVisibility();
});