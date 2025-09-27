document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('character-form');
    const input = document.getElementById('character-name');
    const wrapper = document.getElementById('wrapper'); // Referência para a nossa nova div

    const errorMessage = document.createElement('p');
    errorMessage.className = 'error-message';
    form.appendChild(errorMessage);

    // Listener para mensagens do client.lua
    window.addEventListener('message', function(event) {
        if (event.data.type === 'ui') {
            if (event.data.status == true) {
                // Em vez de body.style.display, usamos wrapper.style.display
                wrapper.style.display = 'flex'; // Usamos 'flex' por causa do estilo no CSS
            } else {
                wrapper.style.display = 'none';
            }
        }
    });

    form.addEventListener('submit', function(event) {
        event.preventDefault();
        errorMessage.style.display = 'none';

        // ... (Toda a sua lógica de validação do nome continua exatamente igual) ...
        const fullName = input.value.trim();
        const validNameRegex = /^[a-zA-Z]+$/;
        const nameParts = fullName.split(' ').filter(part => part.length > 0);

        if (nameParts.length !== 2) {
            showError("Por favor, insira um nome e um sobrenome (ex: John Doe).");
            return;
        }
        const firstName = nameParts[0];
        const lastName = nameParts[1];
        if (!validNameRegex.test(firstName) || !validNameRegex.test(lastName)) {
            showError("O nome e o sobrenome devem conter apenas letras.");
            return;
        }
        if (firstName.length < 3 || lastName.length < 3) {
            showError("O nome e o sobrenome devem ter, cada um, pelo menos 3 letras.");
            return;
        }
        // ... (Fim da lógica de validação) ...

        // Envia os dados para o Lua
        fetch(`https://loginresource/character_creation`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                name: fullName
            })
        });
    });

    function showError(message) {
        errorMessage.textContent = message;
        errorMessage.style.display = 'block';
    }
});