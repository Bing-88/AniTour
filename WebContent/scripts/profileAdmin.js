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
    const tourDateError = document.getElementById('tourDateError');
    
    // Gestione form di errore
    const addTourForm = document.getElementById('addTourForm');
    const addTourFormError = document.getElementById('addTourFormError');
    
    if (startDateInput && endDateInput && tourDateError) {
        function validateDates() {
            // Nascondi il messaggio di errore inizialmente
            tourDateError.style.display = 'none';
            tourDateError.textContent = '';
            
            if (startDateInput.value && endDateInput.value) {
                const startDate = new Date(startDateInput.value);
                const endDate = new Date(endDateInput.value);
                
                if (endDate < startDate) {
                    // Mostra messaggio di errore specifico per le date
                    tourDateError.textContent = 'La data di fine deve essere successiva alla data di inizio.';
                    tourDateError.style.display = 'block';
                    
                    // Mostra anche nel box di errore generale
                    if (addTourFormError) {
                        addTourFormError.textContent = 'La data di fine deve essere successiva alla data di inizio.';
                        addTourFormError.style.display = 'block';
                        addTourFormError.classList.remove('form-error-hidden');
                    }
                    
                    // Resetta il campo data di fine
                    endDateInput.value = '';
                    return false;
                } else {
                    // Nasconde i messaggi di errore se le date sono valide
                    tourDateError.style.display = 'none';
                    if (addTourFormError) {
                        addTourFormError.textContent = '';
                        addTourFormError.style.display = 'none';
                        addTourFormError.classList.add('form-error-hidden');
                    }
                    return true;
                }
            }
            return true;
        }
        
        startDateInput.addEventListener('change', validateDates);
        endDateInput.addEventListener('change', validateDates);
    }
    
    // Gestione del submit del form "Aggiungi Tour"
    if (addTourForm) {
        addTourForm.addEventListener('submit', function(e) {
            // Valida le date prima di inviare il form
            if (startDateInput && endDateInput && tourDateError) {
                if (!validateDates()) {
                    e.preventDefault();
                    return false;
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
                    
                    // Nascondi anche il messaggio di errore delle date
                    const tourDateError = document.getElementById('tourDateError');
                    if (tourDateError) {
                        tourDateError.style.display = 'none';
                        tourDateError.textContent = '';
                    }
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
    
    // Gestione della sezione "Modifica Tour"
    const updateTourSelect = document.getElementById('updateTourSelect');
    const updateTourFields = document.getElementById('updateTourFields');
    const updateTourForm = document.getElementById('updateTourForm');
    const updateTourFormError = document.getElementById('updateTourFormError');
    
    console.log('Debug elementi modifica tour:');
    console.log('updateTourSelect:', updateTourSelect);
    console.log('updateTourFields:', updateTourFields);
    console.log('updateTourForm:', updateTourForm);
    
    if (updateTourSelect) {
        console.log('Evento change aggiunto a updateTourSelect');
        updateTourSelect.addEventListener('change', function() {
            const tourId = this.value;
            console.log('Selezionato tour ID:', tourId);
            
            if (tourId) {
                // Aggiorna il campo hidden con il tourId selezionato
                const hiddenTourId = document.getElementById('updateTourIdHidden');
                if (hiddenTourId) {
                    hiddenTourId.value = tourId;
                    console.log('Campo hidden aggiornato con tourId:', tourId);
                } else {
                    console.error('Campo hidden updateTourIdHidden non trovato!');
                }
                
                // Mostra i campi del form
                console.log('Mostrando updateTourFields...');
                
                // Prima assicuriamoci che la sezione collassabile sia aperta
                const updateTourCollapsible = document.querySelector('.admin-card h4.collapsible');
                let collapsibleContent = null;
                
                if (updateTourCollapsible && updateTourCollapsible.textContent.includes('Modifica Tour')) {
                    collapsibleContent = updateTourCollapsible.nextElementSibling;
                    if (collapsibleContent && !updateTourCollapsible.classList.contains('active')) {
                        console.log('Aprendo sezione collassabile...');
                        updateTourCollapsible.classList.add('active');
                        const icon = updateTourCollapsible.querySelector('.collapse-icon');
                        if (icon) {
                            icon.textContent = '-';
                        }
                        collapsibleContent.style.maxHeight = collapsibleContent.scrollHeight + "px";
                    }
                }
                
                updateTourFields.style.display = 'block';
                updateTourFields.style.visibility = 'visible';
                updateTourFields.style.opacity = '1';
                
                // Aggiorna l'altezza della sezione collassabile dopo aver mostrato i campi
                if (collapsibleContent) {
                    // Aggiungi classe CSS per forzare l'espansione
                    collapsibleContent.classList.add('expanded-for-update');
                    
                    // Forza il ricalcolo dell'altezza in modo più aggressivo
                    setTimeout(() => {
                        // Salva la transizione originale
                        const originalTransition = collapsibleContent.style.transition;
                        
                        // Disabilita temporaneamente la transizione per evitare conflitti
                        collapsibleContent.style.transition = 'none';
                        
                        // Rimuovi temporaneamente maxHeight per permettere l'espansione naturale
                        collapsibleContent.style.maxHeight = 'none';
                        
                        // Forza il reflow del DOM
                        collapsibleContent.offsetHeight;
                        
                        // Riapplica maxHeight con il nuovo valore
                        const newHeight = collapsibleContent.scrollHeight;
                        collapsibleContent.style.maxHeight = newHeight + "px";
                        
                        // Riabilita la transizione dopo un breve ritardo
                        setTimeout(() => {
                            collapsibleContent.style.transition = originalTransition;
                        }, 10);
                        
                        console.log('Altezza collapsible aggiornata da auto a:', newHeight + "px");
                    }, 50); // Aumentato il timeout per dare più tempo al DOM
                }
                
                console.log('updateTourFields display dopo impostazione:', updateTourFields.style.display);
                console.log('updateTourFields computed style:', getComputedStyle(updateTourFields).display);
                
                // Carica i dati del tour selezionato
                console.log('Caricando dati tour...');
                fetch('/AniTour/update-tour?action=getTourData&tourId=' + tourId)
                    .then(response => {
                        console.log('Risposta ricevuta:', response);
                        return response.json();
                    })
                    .then(data => {
                        console.log('Dati tour ricevuti:', data);
                        if (data.error) {
                            throw new Error(data.error);
                        }
                        
                        // Popola i campi del form
                        document.getElementById('updateTourName').value = data.name || '';
                        document.getElementById('updateTourDescription').value = data.description || '';
                        document.getElementById('updateTourPrice').value = data.price || '';
                        document.getElementById('updateTourStartDate').value = data.startDate || '';
                        document.getElementById('updateTourEndDate').value = data.endDate || '';
                        
                        console.log('Campi popolati con successo');
                        
                        // Nascondi eventuali messaggi di errore
                        if (updateTourFormError) {
                            updateTourFormError.style.display = 'none';
                            updateTourFormError.textContent = '';
                        }
                        
                        // Nascondi anche il messaggio di errore delle date
                        const updateTourDateError = document.getElementById('updateTourDateError');
                        if (updateTourDateError) {
                            updateTourDateError.style.display = 'none';
                            updateTourDateError.textContent = '';
                        }
                    })
                    .catch(error => {
                        console.error('Errore nel caricamento dei dati del tour:', error);
                        if (updateTourFormError) {
                            updateTourFormError.textContent = 'Errore nel caricamento dei dati del tour: ' + error.message;
                            updateTourFormError.style.display = 'block';
                            updateTourFormError.classList.remove('form-error-hidden');
                        }
                        updateTourFields.style.display = 'none';
                    });
            } else {
                // Reset del campo hidden quando nessun tour è selezionato
                const hiddenTourId = document.getElementById('updateTourIdHidden');
                if (hiddenTourId) {
                    hiddenTourId.value = '';
                }
                updateTourFields.style.display = 'none';
                
                // Rimuovi la classe CSS per l'espansione forzata
                const updateTourCollapsible = document.querySelector('.admin-card h4.collapsible');
                if (updateTourCollapsible && updateTourCollapsible.textContent.includes('Modifica Tour')) {
                    const collapsibleContent = updateTourCollapsible.nextElementSibling;
                    if (collapsibleContent) {
                        collapsibleContent.classList.remove('expanded-for-update');
                        
                        // Aggiorna l'altezza della sezione collassabile dopo aver nascosto i campi
                        if (updateTourCollapsible.classList.contains('active')) {
                            setTimeout(() => {
                                collapsibleContent.style.maxHeight = collapsibleContent.scrollHeight + "px";
                            }, 10);
                        }
                    }
                }
            }
        });
    } else {
        console.error('updateTourSelect non trovato!');
    }
    
    // Validazione delle date per il form di aggiornamento
    const updateStartDateInput = document.getElementById('updateTourStartDate');
    const updateEndDateInput = document.getElementById('updateTourEndDate');
    const updateTourDateError = document.getElementById('updateTourDateError');
    
    if (updateStartDateInput && updateEndDateInput && updateTourDateError) {
        function validateUpdateDates() {
            // Nascondi il messaggio di errore inizialmente
            updateTourDateError.style.display = 'none';
            updateTourDateError.textContent = '';
            
            if (updateStartDateInput.value && updateEndDateInput.value) {
                const startDate = new Date(updateStartDateInput.value);
                const endDate = new Date(updateEndDateInput.value);
                
                if (endDate < startDate) {
                    // Mostra messaggio di errore specifico per le date
                    updateTourDateError.textContent = 'La data di fine deve essere successiva alla data di inizio.';
                    updateTourDateError.style.display = 'block';
                    
                    // Mostra anche nel box di errore generale
                    if (updateTourFormError) {
                        updateTourFormError.textContent = 'La data di fine deve essere successiva alla data di inizio.';
                        updateTourFormError.style.display = 'block';
                        updateTourFormError.classList.remove('form-error-hidden');
                    }
                    
                    // Resetta il campo data di fine
                    updateEndDateInput.value = '';
                    return false;
                } else {
                    // Nasconde i messaggi di errore se le date sono valide
                    updateTourDateError.style.display = 'none';
                    if (updateTourFormError) {
                        updateTourFormError.textContent = '';
                        updateTourFormError.style.display = 'none';
                        updateTourFormError.classList.add('form-error-hidden');
                    }
                    return true;
                }
            }
            return true;
        }
        
        updateStartDateInput.addEventListener('change', validateUpdateDates);
        updateEndDateInput.addEventListener('change', validateUpdateDates);
    }
    
    // Gestione del submit del form di aggiornamento
    if (updateTourForm) {
        updateTourForm.addEventListener('submit', function(e) {
            // Controlla che sia stato selezionato un tour
            const tourId = document.getElementById('updateTourIdHidden').value;
            if (!tourId) {
                e.preventDefault();
                if (updateTourFormError) {
                    updateTourFormError.textContent = 'È necessario selezionare un tour da modificare.';
                    updateTourFormError.style.display = 'block';
                    updateTourFormError.classList.remove('form-error-hidden');
                }
                return false;
            }
            
            // Valida le date
            if (!validateUpdateDates()) {
                e.preventDefault();
                return false;
            }
            
            // Debug: stampa il valore del campo hidden prima del submit
            console.log('Submitting form with tourId:', tourId);
            
            // Assicurati che il campo hidden abbia il valore corretto
            document.getElementById('updateTourIdHidden').value = tourId;
        });
    }
    
    // Chiudi il modal cliccando all'esterno
    window.onclick = function(event) {
        const modal = document.getElementById('orderModal');
        if (event.target === modal) {
            closeOrderModal();
        }
    }
});