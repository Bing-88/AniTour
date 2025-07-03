// Globale
// Funzione per espandere/comprimere i dettagli degli ordini
function toggleDetails(button) {
    // Trova la riga dei dettagli (la riga successiva)
    const detailsRow = button.parentNode.nextElementSibling;
    
    // Toggle la visualizzazione e la classe expanded
    if (detailsRow.classList.contains('expanded')) {
        button.textContent = '+';
        detailsRow.classList.remove('expanded');
        
        // Rimuove il display: table-row dopo la transizione per nasconderlo completamente
        setTimeout(() => {
            if (!detailsRow.classList.contains('expanded')) {
                detailsRow.style.display = 'none';
            }
        }, 500); // Corrisponde alla durata della transizione CSS
    } else {
        detailsRow.style.display = 'table-row';
        
        // Piccolo ritardo per permettere al browser di applicare il display: table-row prima di aggiungere la classe expanded
        setTimeout(() => {
            button.textContent = '-';
            detailsRow.classList.add('expanded');
        }, 10);
    }
}

// Funzione per aggiornare l'altezza del contenuto collassabile
function updateCollapsibleHeight(collapsibleHeader) {
    if (collapsibleHeader.classList.contains('active')) {
        const content = collapsibleHeader.nextElementSibling;
        content.style.maxHeight = content.scrollHeight + "px";
    }
}

// Il resto del file all'interno dell'evento DOMContentLoaded
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
                const content = this.nextElementSibling;
                content.style.maxHeight = content.scrollHeight + "px";
            } else {
                icon.textContent = '+';
                const content = this.nextElementSibling;
                content.style.maxHeight = null;
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
            
            // Aggiorna l'altezza del collapsible dopo l'aggiunta di una nuova tappa
            const collapsible = stopsContainer.closest('.collapsible-content');
            if (collapsible) {
                collapsible.style.maxHeight = collapsible.scrollHeight + "px";
            }
            
            // Trova l'elemento collapsible header padre e aggiorna l'altezza
            const collapsibleHeader = stopsContainer.closest('.collapsible-content').previousElementSibling;
            if (collapsibleHeader && collapsibleHeader.classList.contains('collapsible')) {
                updateCollapsibleHeight(collapsibleHeader);
            }
        });
    }
    
    // Validazione date
    const startDateInput = document.getElementById('tourStartDate');
    const endDateInput = document.getElementById('tourEndDate');
    
    // Gestione form di errore
    const addTourForm = document.getElementById('addTourForm');
    const addTourFormError = document.getElementById('addTourFormError');
    
    if (startDateInput && endDateInput) {
        // Creazione del messaggio di errore
        const dateErrorElement = document.createElement('p');
        dateErrorElement.className = 'error-message';
        dateErrorElement.id = 'tourDateError';
        if (endDateInput.parentNode) {
            endDateInput.parentNode.appendChild(dateErrorElement);
        }
        
        endDateInput.addEventListener('change', function() {
            if (startDateInput.value && this.value) {
                const startDate = new Date(startDateInput.value);
                const endDate = new Date(this.value);
                
                if (endDate < startDate) {
                    this.value = '';
                    dateErrorElement.textContent = 'La data di fine deve essere successiva alla data di inizio.';
                    
                    // Mostra anche il messaggio nel box di errore generale
                    if (addTourFormError) {
                        addTourFormError.textContent = 'La data di fine deve essere successiva alla data di inizio.';
                        addTourFormError.style.display = 'block';
                    }
                } else {
                    dateErrorElement.textContent = '';
                    
                    // Nascondi il messaggio di errore generale
                    if (addTourFormError) {
                        addTourFormError.textContent = '';
                        addTourFormError.style.display = 'none';
                    }
                }
            }
        });
    }
    
    // Funzione per mostrare i dettagli di un ordine
    function showOrderDetails(orderId) {
        // Verifica se il modal esiste già
        let modal = document.getElementById('orderModal');
        
        // Se non esiste, crealo
        if (!modal) {
            modal = document.createElement('div');
            modal.id = 'orderModal';
            modal.className = 'order-modal';
            
            const modalContent = document.createElement('div');
            modalContent.className = 'modal-content';
            
            modalContent.innerHTML = `
                <div class="modal-header">
                    <h3>Dettagli Ordine #<span id="modalOrderId"></span></h3>
                    <button type="button" class="modal-close" onclick="closeOrderModal()">&times;</button>
                </div>
                <div id="orderDetails"></div>
            `;
            
            modal.appendChild(modalContent);
            document.body.appendChild(modal);
        }
        
        // Recupera i dettagli dell'ordine tramite AJAX
        fetch('/AniTour/api/order-details?id=' + orderId)
            .then(response => response.json())
            .then(data => {
                document.getElementById('modalOrderId').textContent = data.id;
                
                const detailsContainer = document.getElementById('orderDetails');
                detailsContainer.innerHTML = '';
                
                // Informazioni generali
                const generalSection = document.createElement('div');
                generalSection.className = 'modal-section';
                generalSection.innerHTML = `
                    <h4>Informazioni generali</h4>
                    <div class="detail-row">
                        <div class="detail-label">Data ordine:</div>
                        <div>${formatDate(data.bookingDate)}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Stato:</div>
                        <div>${getStatusText(data.status)}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Tour:</div>
                        <div>${data.tourName}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Quantità:</div>
                        <div>${data.quantity}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Prezzo unitario:</div>
                        <div>${formatCurrency(data.price)}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Totale:</div>
                        <div>${formatCurrency(data.price * data.quantity)}</div>
                    </div>
                `;
                detailsContainer.appendChild(generalSection);
                
                // Informazioni cliente
                const customerSection = document.createElement('div');
                customerSection.className = 'modal-section';
                customerSection.innerHTML = `
                    <h4>Informazioni cliente</h4>
                    <div class="detail-row">
                        <div class="detail-label">Nome:</div>
                        <div>${data.shippingName || 'N/A'}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Email:</div>
                        <div>${data.shippingEmail || 'N/A'}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Telefono:</div>
                        <div>${data.shippingPhone || 'N/A'}</div>
                    </div>
                `;
                detailsContainer.appendChild(customerSection);
                
                // Informazioni spedizione
                const shippingSection = document.createElement('div');
                shippingSection.className = 'modal-section';
                shippingSection.innerHTML = `
                    <h4>Informazioni spedizione</h4>
                    <div class="detail-row">
                        <div class="detail-label">Indirizzo:</div>
                        <div>${data.shippingAddress || 'N/A'}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Città:</div>
                        <div>${data.shippingCity || 'N/A'}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Paese:</div>
                        <div>${data.shippingCountry || 'N/A'}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">CAP:</div>
                        <div>${data.shippingPostalCode || 'N/A'}</div>
                    </div>
                `;
                detailsContainer.appendChild(shippingSection);
                
                // Informazioni pagamento
                const paymentSection = document.createElement('div');
                paymentSection.className = 'modal-section';
                paymentSection.innerHTML = `
                    <h4>Informazioni pagamento</h4>
                    <div class="detail-row">
                        <div class="detail-label">Metodo:</div>
                        <div>${data.paymentMethod || 'N/A'}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Stato pagamento:</div>
                        <div>${getPaymentStatusText(data.paymentStatus)}</div>
                    </div>
                `;
                detailsContainer.appendChild(paymentSection);
                
                // Mostra il modal
                modal.style.display = 'flex';
            })
            .catch(error => {
                console.error('Errore nel recupero dei dettagli dell\'ordine:', error);
                alert('Errore nel recupero dei dettagli dell\'ordine. Riprova più tardi.');
            });
    }
    
    // Funzione per chiudere il modal
    function closeOrderModal() {
        const modal = document.getElementById('orderModal');
        if (modal) {
            modal.style.display = 'none';
        }
    }
    
    // Funzione per inizializzare e gestire il messaggio di errore nel form Aggiungi Tour
    function initAddTourForm() {
        if (addTourFormError) {
            // Assicurati che il messaggio di errore sia nascosto e vuoto all'inizio
            addTourFormError.textContent = '';
            addTourFormError.style.display = 'none';
            
            // Aggiungi listener per reset del form per nascondere il messaggio di errore
            if (addTourForm) {
                addTourForm.addEventListener('reset', function() {
                    addTourFormError.textContent = '';
                    addTourFormError.style.display = 'none';
                });
            }
        }
    }
    
    // Inizializza il form
    initAddTourForm();
    
    // Utility per formattare la data
    function formatDate(dateString) {
        if (!dateString) return 'N/A';
        const date = new Date(dateString);
        return date.toLocaleDateString('it-IT', { 
            day: '2-digit', 
            month: '2-digit', 
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }
    
    // Utility per formattare la valuta
    function formatCurrency(amount) {
        if (amount == null) return 'N/A';
        return new Intl.NumberFormat('it-IT', {
            style: 'currency',
            currency: 'EUR'
        }).format(amount);
    }
    
    // Utility per il testo dello stato
    function getStatusText(status) {
        switch (status) {
            case 'ordered': return 'In attesa';
            case 'completed': return 'Completato';
            case 'cancelled': return 'Cancellato';
            default: return status;
        }
    }
    
    // Utility per il testo dello stato pagamento
    function getPaymentStatusText(status) {
        switch (status) {
            case 'pending': return 'In attesa';
            case 'completed': return 'Completato';
            case 'failed': return 'Fallito';
            default: return status || 'N/A';
        }
    }
    
    // Chiudi il modal cliccando all'esterno
    window.onclick = function(event) {
        const modal = document.getElementById('orderModal');
        if (event.target === modal) {
            closeOrderModal();
        }
    }
});