document.addEventListener('DOMContentLoaded', function() {
    const stopsContainer = document.getElementById('stopsContainer');
    const addStopButton = document.getElementById('addStopButton');
    let stopCount = 1;
    
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
    
    // Validazione date
    const startDateInput = document.getElementById('tourStartDate');
    const endDateInput = document.getElementById('tourEndDate');
    
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
});