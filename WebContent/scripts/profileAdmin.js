document.addEventListener('DOMContentLoaded', function() {
    // Gestione delle sezioni collassabili
    const collapsibles = document.querySelectorAll('.collapsible');
    
    collapsibles.forEach(collapsible => {
        collapsible.addEventListener('click', function() {
            this.classList.toggle('active');
            
            // Aggiorna l'icona
            const icon = this.querySelector('.collapse-icon');
            if (this.classList.contains('active')) {
                icon.textContent = '-';
            } else {
                icon.textContent = '+';
            }
        });
        
        // All'inizio tutte le sezioni sono chiuse
        const icon = collapsible.querySelector('.collapse-icon');
        icon.textContent = '+';
    });
    
    // Gestione dinamica delle tappe del tour
    const stopsContainer = document.getElementById('stopsContainer');
    const addStopButton = document.getElementById('addStopButton');
    let stopCount = 1;
    
    if (addStopButton) {
        addStopButton.addEventListener('click', function() {
            stopCount++;
            const newStop = document.createElement('div');
            newStop.className = 'tour-stop';
            newStop.innerHTML = `
                <div class="form-group">
                    <label for="stopName${stopCount}">Nome tappa ${stopCount}:</label>
                    <input type="text" id="stopName${stopCount}" name="stopName${stopCount}" required>
                </div>
                
                <div class="form-group">
                    <label for="stopDescription${stopCount}">Descrizione tappa ${stopCount}:</label>
                    <textarea id="stopDescription${stopCount}" name="stopDescription${stopCount}" rows="2" required></textarea>
                </div>
            `;
            stopsContainer.appendChild(newStop);
        });
    }
    
    // Validazione date
    const startDateInput = document.getElementById('tourStartDate');
    const endDateInput = document.getElementById('tourEndDate');
    
    if (startDateInput && endDateInput) {
        endDateInput.addEventListener('change', function() {
            if (startDateInput.value && this.value) {
                const startDate = new Date(startDateInput.value);
                const endDate = new Date(this.value);
                
                if (endDate < startDate) {
                    alert('La data di fine deve essere successiva alla data di inizio.');
                    this.value = '';
                }
            }
        });
    }
});