document.addEventListener('DOMContentLoaded', function() {
    const checkoutForm = document.getElementById('checkoutForm');
    const shippingName = document.getElementById('shippingName');
    const shippingEmail = document.getElementById('shippingEmail');
    const shippingPhone = document.getElementById('shippingPhone');
    const shippingCity = document.getElementById('shippingCity');
    const shippingPostalCode = document.getElementById('shippingPostalCode');
    const cardHolder = document.getElementById('cardHolder');
    const cardNumber = document.getElementById('cardNumber');
    const cardExpiry = document.getElementById('cardExpiry');
    const cardCvv = document.getElementById('cardCvv');
    
    // Regex di validazione
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const phoneRegex = /^(\+\d{1,3}[-\s]?)?\d{3,}[-\s]?\d{3,}[-\s]?\d{3,}$/;
    const fullNameRegex = /^[A-Za-zÀ-ÿ\s'-]+\s+[A-Za-zÀ-ÿ\s'-]+$/; // Almeno due parole
    const cityRegex = /^[A-Za-zÀ-ÿ\s'-]+$/; // Solo lettere, spazi e alcuni caratteri speciali
    const postalCodeRegex = /^\d{4,6}$/; // Da 4 a 6 cifre
    const cardNumberRegex = /^\d{16}$|^(\d{4} ){3}\d{4}$/; // Formati carta di credito
    const cvvRegex = /^\d{2,4}$/; // Minimo 2 cifre, massimo 4
    
    // Funzione per aggiungere formattazione al numero della carta
    cardNumber.addEventListener('input', function(e) {
        // Rimuove tutto tranne le cifre
        let value = this.value.replace(/\D/g, '');
        
        // Aggiunge spazi ogni 4 cifre
        if (value.length > 0) {
            value = value.match(new RegExp('.{1,4}', 'g')).join(' ');
        }
        
        this.value = value;
    });
    
    // Funzione per formattare la data di scadenza
    cardExpiry.addEventListener('input', function(e) {
        let value = this.value.replace(/\D/g, '');
        
        if (value.length > 2) {
            value = value.substring(0, 2) + '/' + value.substring(2, 4);
        }
        
        this.value = value;
    });
    
    // Limita il CVV a 4 cifre e validazione
    cardCvv.addEventListener('input', function(e) {
        this.value = this.value.replace(/\D/g, '').substring(0, 4);
    });
    
    cardCvv.addEventListener('blur', function() {
        if (!cvvRegex.test(this.value)) {
            showError(this, 'Inserisci un CVV valido (minimo 2 cifre)');
        } else {
            clearError(this);
        }
    });
    
    // Validazione numero carta formato carta di credito
    cardNumber.addEventListener('blur', function() {
        let value = this.value.replace(/\D/g, ''); // Rimuove tutto tranne le cifre
        if (!cardNumberRegex.test(value) && !cardNumberRegex.test(this.value)) {
            showError(this, 'Inserisci un numero di carta di credito valido');
        } else {
            clearError(this);
        }
    });
    
    // Validazione email
    shippingEmail.addEventListener('blur', function() {
        if (!emailRegex.test(this.value)) {
            showError(this, 'Inserisci un indirizzo email valido');
        } else {
            clearError(this);
        }
    });
    
    // Validazione numero di telefono
    shippingPhone.addEventListener('blur', function() {
        if (!phoneRegex.test(this.value)) {
            showError(this, 'Inserisci un numero di telefono valido (es. +39 123 456 7890)');
        } else {
            clearError(this);
        }
    });
    
    // Validazione nome completo
    shippingName.addEventListener('blur', function() {
        if (!fullNameRegex.test(this.value)) {
            showError(this, 'Inserire nome e cognome completi (almeno due parole)');
        } else {
            clearError(this);
        }
    });
    
    // Validazione città (non può contenere numeri)
    shippingCity.addEventListener('blur', function() {
        if (!cityRegex.test(this.value)) {
            showError(this, 'Inserisci una città valida (senza numeri)');
        } else {
            clearError(this);
        }
    });
    
    // Validazione CAP (4-6 cifre)
    shippingPostalCode.addEventListener('blur', function() {
        if (!postalCodeRegex.test(this.value)) {
            showError(this, 'Inserisci un CAP valido (4-6 cifre)');
        } else {
            clearError(this);
        }
    });
    
    // Validazione intestatario carta (almeno due parole)
    cardHolder.addEventListener('blur', function() {
        if (!fullNameRegex.test(this.value)) {
            showError(this, 'Inserisci nome e cognome completi dell\'intestatario');
        } else {
            clearError(this);
        }
    });
    
    // Validazione al submit
    checkoutForm.addEventListener('submit', function(e) {
        let isValid = true;
        
        // Validazione nome completo
        if (!fullNameRegex.test(shippingName.value)) {
            showError(shippingName, 'Inserire nome e cognome completi (almeno due parole)');
            isValid = false;
        }
        
        // Validazione email
        if (!emailRegex.test(shippingEmail.value)) {
            showError(shippingEmail, 'Inserisci un indirizzo email valido');
            isValid = false;
        }
        
        // Validazione telefono
        if (!phoneRegex.test(shippingPhone.value)) {
            showError(shippingPhone, 'Inserisci un numero di telefono valido (es. +39 123 456 7890)');
            isValid = false;
        }
        
        // Validazione città
        if (!cityRegex.test(shippingCity.value)) {
            showError(shippingCity, 'Inserisci una città valida (senza numeri)');
            isValid = false;
        }
        
        // Validazione CAP
        if (!postalCodeRegex.test(shippingPostalCode.value)) {
            showError(shippingPostalCode, 'Inserisci un CAP valido (4-6 cifre)');
            isValid = false;
        }
        
        // Validazione intestatario carta
        if (!fullNameRegex.test(cardHolder.value)) {
            showError(cardHolder, 'Inserisci nome e cognome completi dell\'intestatario');
            isValid = false;
        }
        
        // Validazione numero carta
        const cleanCardNumber = cardNumber.value.replace(/\D/g, '');
        if (!cardNumberRegex.test(cleanCardNumber)) {
            showError(cardNumber, 'Inserisci un numero di carta di credito valido');
            isValid = false;
        }
        
        // Controlla formato data di scadenza
        const expiryRegex = /^(0[1-9]|1[0-2])\/([0-9]{2})$/;
        if (!expiryRegex.test(cardExpiry.value)) {
            showError(cardExpiry, 'Formato data non valido (deve essere MM/YY)');
            isValid = false;
        } else {
            // Controlla validità mese
            const expParts = cardExpiry.value.split('/');
            const month = parseInt(expParts[0], 10);
            const year = parseInt('20' + expParts[1], 10);
            const now = new Date();
            const currentYear = now.getFullYear();
            const currentMonth = now.getMonth() + 1;
            
            if (year < currentYear || (year === currentYear && month < currentMonth)) {
                showError(cardExpiry, 'La carta è scaduta');
                isValid = false;
            }
        }
        
        // Controlla CVV
        if (!cvvRegex.test(cardCvv.value)) {
            showError(cardCvv, 'Inserisci un CVV valido (minimo 2 cifre)');
            isValid = false;
        }
        
        if (!isValid) {
            e.preventDefault();
        }
    });
    
    function showError(element, message) {
        // Rimuove eventuali messaggi di errore esistenti
        clearError(element);
        
        // Crea e inserisce il messaggio di errore
        const errorDiv = document.createElement('div');
        errorDiv.className = 'field-error';
        errorDiv.textContent = message;
        element.parentNode.appendChild(errorDiv);
        
        // Evidenzia il campo con errore
        element.classList.add('error-input');
    }
    
    function clearError(element) {
        // Rimuove il messaggio di errore se esiste
        const error = element.parentNode.querySelector('.field-error');
        if (error) {
            error.remove();
        }
        
        // Rimuove l'evidenziazione
        element.classList.remove('error-input');
    }
    
    // Rimuove l'evidenziazione quando l'utente modifica il valore
    const formInputs = document.querySelectorAll('input');
    formInputs.forEach(input => {
        input.addEventListener('input', function() {
            clearError(this);
        });
    });
});