document.addEventListener('DOMContentLoaded', function() {
    // Utilizza i nuovi ID per i selettori
    const filterForm = document.getElementById('ordersFilterFormMain');
    const resetButton = document.getElementById('resetFiltersMain');
    const startDate = document.getElementById('startDateMain');
    const endDate = document.getElementById('endDateMain');
    const clientId = document.getElementById('clientIdMain');
    const resultsContainer = document.getElementById('ordersTableContainerMain');
    const loadingSpinner = document.querySelector('#ordersResultContainerMain .loading-spinner');
    const errorMessage = document.getElementById('filterErrorMessage');
    const errorText = document.getElementById('filterErrorText');
    
    // Verifica se tutti gli elementi esistono
    if (!startDate || !endDate || !clientId || !resetButton || !resultsContainer || !loadingSpinner) {
        console.error('Alcuni elementi necessari non sono stati trovati nel DOM');
        return;
    }
    
    // Funzione per validare le date
    function validateDateRange() {
        const startDateValue = startDate.value;
        const endDateValue = endDate.value;
        
        // Se entrambe le date sono inserite
        if (startDateValue && endDateValue) {
            const startDateObj = new Date(startDateValue);
            const endDateObj = new Date(endDateValue);
            
            if (startDateObj > endDateObj) {
                showError('La data di inizio non può essere successiva alla data di fine');
                return false;
            }
        }
        
        hideError();
        return true;
    }
    
    // Funzione per mostrare errori
    function showError(message) {
        if (errorMessage && errorText) {
            errorText.textContent = message;
            errorMessage.style.display = 'flex';
        }
    }
    
    // Funzione per nascondere errori
    function hideError() {
        if (errorMessage) {
            errorMessage.style.display = 'none';
        }
    }
    
    // Funzione per aggiungere event listeners alle righe (RIMOSSA - le righe non sono più cliccabili)
    function addClickHandlersToRows() {
        // Non fa più nulla - le righe sono solo per visualizzazione
        console.log('Le righe degli ordini sono solo per visualizzazione, non cliccabili');
    }

    // Aggiungi handlers inizialmente (per le righe già presenti)
    addClickHandlersToRows();

    // Funzione per caricare gli ordini filtrati
    function loadFilteredOrders() {
        // Valida prima le date
        if (!validateDateRange()) {
            return; // Esce se la validazione fallisce
        }
        
        // Mostra lo spinner di caricamento
        loadingSpinner.style.display = 'flex';
        
        // Costruisce i parametri di query
        const queryParams = new URLSearchParams();
        
        if (startDate.value) {
            queryParams.append('startDate', startDate.value);
        }
        
        if (endDate.value) {
            queryParams.append('endDate', endDate.value);
        }
        
        if (clientId.value) {
            queryParams.append('clientId', clientId.value);
        }
        
        // Aggiunge il parametro ajax per indicare che è una richiesta AJAX
        queryParams.append('ajax', 'true');
        
        console.log('Invio richiesta con parametri:', queryParams.toString());
        
        // Esegue la richiesta AJAX con timestamp per evitare caching
        fetch('/AniTour/profile?' + queryParams.toString() + '&nocache=' + new Date().getTime())
            .then(response => {
                if (!response.ok) {
                    throw new Error('Errore nella risposta del server');
                }
                return response.text();
            })
            .then(data => {
                resultsContainer.innerHTML = data;
                loadingSpinner.style.display = 'none';
                
                // Aggiungi i click handlers alle nuove righe
                addClickHandlersToRows();
            })
            .catch(error => {
                console.error('Errore durante il caricamento degli ordini:', error);
                loadingSpinner.style.display = 'none';
                resultsContainer.innerHTML = '<div class="no-results"><p>Errore durante il caricamento degli ordini. Riprova più tardi.</p></div>';
            });
    }
    
    // Aggiungi event listener per il filtraggio automatico
    startDate.addEventListener('change', function() {
        if (validateDateRange()) {
            loadFilteredOrders();
        }
    });
    
    endDate.addEventListener('change', function() {
        if (validateDateRange()) {
            loadFilteredOrders();
        }
    });
    
    clientId.addEventListener('change', function() {
        if (validateDateRange()) {
            loadFilteredOrders();
        }
    });
    
    // Event listener per il reset dei filtri
    resetButton.addEventListener('click', function() {
        console.log('Reset filtri cliccato');
        startDate.value = '';
        endDate.value = '';
        clientId.value = '';
        hideError(); // Nasconde eventuali errori
        loadFilteredOrders(); // Ricarica tutti gli ordini
    });
    
    // Carica gli ordini al caricamento della pagina
    console.log('Caricamento iniziale ordini');
    loadFilteredOrders();
});