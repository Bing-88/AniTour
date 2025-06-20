document.addEventListener("DOMContentLoaded", function() {
    const colorStyles = {
        red: "p5-texteffect",
        white: "p5-texteffect-white",
        yellow: "p5-texteffect-yellow"
    };
    

    function isValidLetter(char) {
        return /^[a-zA-Z]$/.test(char);
    }
    
    function isInsideP5Date(element) {
        let parent = element;
        while (parent) {
            if (parent.classList && parent.classList.contains('p5-date')) {
                return true;
            }
            parent = parent.parentElement;
        }
        return false;
    }
    
    function applyRandomHighlights(element, colorClass, frequency = 0.1) {
        if (!element || isInsideP5Date(element)) return;
        const isMobile = window.innerWidth <= 768;
        if (isMobile) {
            frequency *= 0.7; 
        }
        
        let text = element.textContent;
        let result = '';
        let usedPositions = [];
        
        for (let i = 0; i < text.length; i++) {
            let char = text[i];
            
            let minDistance = isMobile ? 4 : 3; 
            let canAddHighlight = 
                Math.random() < frequency && 
                isValidLetter(char) &&
                !usedPositions.some(pos => Math.abs(pos - i) < minDistance);
                
            if (canAddHighlight) {
                result += `<span class="${colorClass}">${char}</span>`;
                usedPositions.push(i);
            } else {
                result += char;
            }
        }
        
        element.innerHTML = result;
    }
    
    const subtitle = document.querySelector(".cardp5 h2");
    if (subtitle) {
        applyRandomHighlights(subtitle, colorStyles.red, 0.2);
    }
    
    const mainText = document.querySelector("#p5-main-text");
    if (mainText) {
        applyRandomHighlights(mainText, colorStyles.white, 0.15);
    }
    
    const locationTitles = document.querySelectorAll("#p5-locations li strong");
    locationTitles.forEach((title, index) => {
        const titleColor = index % 2 === 0 ? colorStyles.red : colorStyles.yellow;
        applyRandomHighlights(title, titleColor, 0.2);
    });
    
    const locationDescriptions = document.querySelectorAll("#p5-locations li");
    locationDescriptions.forEach(item => {
        const textNodes = [];
        const walker = document.createTreeWalker(
            item,
            NodeFilter.SHOW_TEXT,
            { acceptNode: node => {
                if (node.parentNode.nodeName !== 'STRONG' && 
                    node.parentNode.parentNode.nodeName !== 'STRONG' &&
                    node.nodeValue.trim().length > 0) {
                    return NodeFilter.FILTER_ACCEPT;
                }
                return NodeFilter.FILTER_REJECT;
            }},
            false
        );

        while (walker.nextNode()) {
            const node = walker.currentNode;
            const span = document.createElement('span');
            span.textContent = node.nodeValue;
            node.parentNode.replaceChild(span, node);
            applyRandomHighlights(span, colorStyles.white, 0.15);
        }

        const emElements = item.querySelectorAll('em');
        emElements.forEach(em => {
            const span = document.createElement('span');
            span.textContent = em.textContent;
            em.innerHTML = '';
            em.appendChild(span);
            applyRandomHighlights(span, colorStyles.white, 0.15);
        });
    });

    window.addEventListener('load', function() {
        
        const dateBoxes = document.querySelectorAll('.p5-date-box.date-only');
        dateBoxes.forEach(box => {
            box.style.transition = 'transform 0.3s ease';
        });
        
        
        const buyButton = document.querySelector('.p5-buy-btn');
        if (buyButton) {
            buyButton.addEventListener('click', function() {
                
                this.style.backgroundColor = 'rgba(40, 40, 40, 0.9)';
                this.style.transform = 'translateY(3px)';
                setTimeout(() => {
                    this.style.backgroundColor = '';
                    this.style.transform = '';
                }, 200);
                
                // reindirizzamento per l'acquisto provvisorio
                // setTimeout(() => { window.location.href = '/AniTour/checkout.jsp'; }, 300);
            });
            
           
            const buttonText = buyButton.querySelector('.p5-buy-text');
            if (buttonText && !buttonText.querySelector('.p5-texteffect')) {
                const text = buttonText.textContent.trim();
                let result = '';
                
               
                for (let i = 0; i < text.length; i++) {
                    const char = text[i];
                    if (Math.random() < 0.3 && /[A-Za-z]/.test(char)) {
                        const effectClass = Math.random() < 0.5 ? 'p5-texteffect' : 'p5-texteffect-yellow';
                        result += `<span class="${effectClass}">${char}</span>`;
                    } else {
                        result += char;
                    }
                }
                
                buttonText.innerHTML = result + '<span class="p5-buy-icon">⚡</span>';
            }
        }
    });
});