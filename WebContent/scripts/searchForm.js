document.addEventListener('DOMContentLoaded', function() {
    // Seleziona elementi DOM
    const searchForm = document.getElementById('searchForm');
    const searchLabels = document.querySelectorAll('.search-element');
    const searchInputs = document.querySelectorAll('.search-input');
    
    const minPriceInput = document.getElementById('minPrice');
    const maxPriceInput = document.getElementById('maxPrice');
    const minPriceError = document.getElementById('minPriceError');
    const maxPriceError = document.getElementById('maxPriceError');
    
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    const dateError = document.createElement('p');
    dateError.className = 'error-message';
    dateError.id = 'dateError';
    if (endDateInput && endDateInput.parentNode) {
        endDateInput.parentNode.appendChild(dateError);
    }
    
    // Gestione click sulle etichette di ricerca
    searchLabels.forEach(label => {
        label.addEventListener('click', function() {
            // Rimuovi classe active da tutte le etichette
            searchLabels.forEach(l => l.classList.remove('active'));
            // Aggiungi classe active all'etichetta cliccata
            this.classList.add('active');
            
            // Ottieni il tipo di ricerca
            const searchType = this.getAttribute('data-type');
            
            // Nascondi tutti gli input di ricerca
            searchInputs.forEach(input => input.classList.remove('active'));
            
            // Mostra l'input corrispondente al tipo di ricerca
            document.getElementById(`${searchType}-search`).classList.add('active');
            
            // Reset dei messaggi di errore
            if (dateError) dateError.textContent = '';
            if (minPriceError) minPriceError.textContent = '';
            if (maxPriceError) maxPriceError.textContent = '';
        });
    });
    
    // Impostazione data minima per le date (oggi)
    const today = new Date();
    const todayFormatted = today.toISOString().split('T')[0];
    if(startDateInput) {
        startDateInput.min = todayFormatted;
    }
    if(endDateInput) {
        endDateInput.min = todayFormatted;
    }
    
    // Gestione validazione date
    if(startDateInput && endDateInput) {
        startDateInput.addEventListener('change', function() {
            if(this.value) {
                endDateInput.min = this.value;
                if (endDateInput.value && new Date(endDateInput.value) < new Date(this.value)) {
                    endDateInput.value = '';
                    dateError.textContent = 'La data di fine non può essere precedente alla data di inizio';
                } else {
                    dateError.textContent = '';
                }
            }
        });
        
        endDateInput.addEventListener('change', function() {
            if(this.value && startDateInput.value && new Date(this.value) < new Date(startDateInput.value)) {
                this.value = '';
                dateError.textContent = 'La data di fine non può essere precedente alla data di inizio';
            } else {
                dateError.textContent = '';
            }
        });
    }
    
    // Validazione prezzi per assicurarsi che il minimo sia inferiore al massimo
    if (minPriceInput && maxPriceInput) {
        minPriceInput.addEventListener('change', function() {
            const minValue = parseFloat(this.value);
            const maxValue = parseFloat(maxPriceInput.value);
            
            if (minValue < 0) {
                this.value = 0;
                minPriceError.textContent = 'Il prezzo minimo non può essere negativo';
            } else if (minValue > maxValue) {
                this.value = 0;
                minPriceError.textContent = 'Il prezzo minimo non può essere maggiore del prezzo massimo';
            } else {
                minPriceError.textContent = '';
            }
        });
        
        maxPriceInput.addEventListener('change', function() {
            const minValue = parseFloat(minPriceInput.value);
            const maxValue = parseFloat(this.value);
            
            if (maxValue < minValue) {
                this.value = minValue * 2 || 1;
                maxPriceError.textContent = 'Il prezzo massimo non può essere inferiore al prezzo minimo';
            } else {
                maxPriceError.textContent = '';
            }
        });
    }
    
    // Gestione submit del form
    searchForm.addEventListener('submit', function(event) {
        event.preventDefault();
        
        // Determina quale tipo di ricerca è attivo
        const activeSearchType = document.querySelector('.search-element.active').getAttribute('data-type');
        
        // Crea l'URL con i parametri corretti
        let url = "/AniTour/tours?";
        
        if(activeSearchType === 'theme') {
            const themeValue = document.querySelector('input[name="theme"]').value.trim();
            if(themeValue) {
                url += `theme=${encodeURIComponent(themeValue)}`;
            }
        } else if(activeSearchType === 'date') {
            const startDate = startDateInput.value;
            const endDate = endDateInput.value;
            
            if(startDate || endDate) {
                if(startDate) url += `startDate=${startDate}`;
                if(startDate && endDate) url += `&endDate=${endDate}`;
                else if(endDate) url += `endDate=${endDate}`;
            }
        } else if(activeSearchType === 'budget') {
            const minPrice = minPriceInput.value;
            const maxPrice = maxPriceInput.value;
            
            url += `minPrice=${minPrice}&maxPrice=${maxPrice}`;
        }
        
        // Reindirizza alla pagina dei risultati
        window.location.href = url;
    });
});