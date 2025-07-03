document.addEventListener('DOMContentLoaded', function() {
    const cartCount = document.getElementById('cart-count');
    if (!cartCount) return; // Esce se l'elemento non esiste
    
    // Carica il valore dal localStorage immediatamente
    const lastKnownCount = localStorage.getItem('cartCount') || '0';
    
    // Prima imposta il testo senza renderlo visibile
    cartCount.textContent = lastKnownCount;
    
    // Imposta la classe appropriata
    if (parseInt(lastKnownCount) > 0) {
        cartCount.classList.remove('empty-cart-count');
    } else {
        cartCount.classList.add('empty-cart-count');
    }
    
    // Mostra il contatore con un breve ritardo per garantire che il DOM sia pronto
    setTimeout(() => {
        cartCount.style.opacity = '1';
    }, 50);
    
    // Recupera il conteggio aggiornato dal server
    updateCartCount();
    
    function updateCartCount() {
        fetch('/AniTour/cart/count')
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                // Ottimizzazione: aggiorna solo se il valore è cambiato
                if (cartCount.textContent !== data.count.toString()) {
                    // Applica una transizione fluida
                    cartCount.style.opacity = '0';
                    
                    setTimeout(() => {
                        cartCount.textContent = data.count;
                        
                        if (data.count > 0) {
                            cartCount.classList.remove('empty-cart-count');
                        } else {
                            cartCount.classList.add('empty-cart-count');
                        }
                        
                        // Salva in localStorage per usi futuri
                        localStorage.setItem('cartCount', data.count);
                        
                        // Mostra il contatore con transizione
                        cartCount.style.opacity = '1';
                    }, 200); // Breve ritardo per l'animazione
                }
            })
            .catch(error => {
                console.error('Error fetching cart count:', error);
                // In caso di errore, mantiene visibile il valore precedente
                cartCount.style.opacity = '1';
            });
    }

    // Aggiorna il conteggio del carrello ogni 30 secondi
    setInterval(updateCartCount, 30000);
});