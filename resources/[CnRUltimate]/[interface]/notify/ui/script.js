// script.js

function parseTextWithColors(text) {
    const colorMap = {
        'r': '#f44336', 
        'g': '#4CAF50', 
        'b': '#2196F3', 
        'y': '#ffeb3b',
        'o': '#ff9800', 
        'p': '#9c27b0', 
        'w': '#f1f1f1', 
    };

    let formattedText = text.replace(/~([a-zA-Z])~/g, (match, char) => {
        if (char === 's') {
            return '</span>'; // Fecha a tag de cor
        }
        const color = colorMap[char.toLowerCase()];
        if (color) {
            return `</span><span style="color: ${color};">`;
        }
        return match; 
    });
    
    return `<span style="color: #f1f1f1;">${formattedText}</span>`;
}


window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'show') {
        createNotification(data.text, data.type);
    }
});

function createNotification(text, type) {
    const container = document.getElementById('notification-container');

    const notificationTypes = {
        success: { icon: 'fas fa-check-circle' },
        error: { icon: 'fas fa-times-circle' },
        info: { icon: null }
    };

    const notifDetails = notificationTypes[type] || notificationTypes.info; 
    
    const notif = document.createElement('div');
    notif.classList.add('notification', type);

    const formattedText = parseTextWithColors(text);

    let innerHTML = '';
    if (notifDetails.icon) {
        innerHTML = `<i class="${notifDetails.icon}"></i> ${formattedText}`;
    } else {
        innerHTML = formattedText;
    }
    notif.innerHTML = innerHTML;

    container.appendChild(notif);

    setTimeout(() => {
        notif.style.opacity = '0';
        setTimeout(() => {
            notif.remove();
        }, 500);
    }, 5000);
}