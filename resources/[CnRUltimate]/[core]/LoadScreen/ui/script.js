document.addEventListener('DOMContentLoaded', () => {
    // --- Elementos da UI ---
    const progressBar = document.getElementById('progress-bar');
    const loadingStatus = document.getElementById('loading-status');
    const backgroundMusic = document.getElementById('background-music');

    // --- Controle de Música ---
    // Tenta tocar a música assim que a página carrega.
    // O volume é definido para um nível razoável.
    if (backgroundMusic) {
        backgroundMusic.volume = 0.2;
        backgroundMusic.play().catch(e => console.log("O browser bloqueou o autoplay. O utilizador precisa de interagir com a página primeiro."));
    }

    // --- Lógica de Loading do FiveM ---
    let count = 0;
    let thisCount = 0;

    // Objeto que mapeia os eventos do FiveM para funções
    const handlers = {
        // Inicia um grupo de funções de inicialização
        startInitFunctionOrder(data) {
            count = data.count;
            // Atualiza o status para indicar o que está a ser carregado
            loadingStatus.textContent = `Preparing ${data.type}...`;
        },

        // Chamado para cada função de inicialização
        initFunctionInvoking(data) {
            const percent = ((data.idx / count) * 100).toFixed(0);
            progressBar.style.width = percent + '%';
        },

        // Inicia o carregamento dos arquivos de dados
        startDataFileEntries(data) {
            count = data.count;
            loadingStatus.textContent = 'Loading Data Files...';
        },

        // Chamado para cada arquivo de mapa carregado
        performMapLoadFunction(data) {
            ++thisCount;
            const percent = ((thisCount / count) * 100).toFixed(0);
            progressBar.style.width = percent + '%';
        },

        // Exibe mensagens de log do cliente
        onLogLine(data) {
            // Remove a pontuação extra para não ficar "mensagem..!"
            loadingStatus.textContent = data.message;
        }
    };

    // Listener que recebe as mensagens do cliente do FiveM
    window.addEventListener('message', function(e) {
        // Encontra e executa o handler correspondente ao evento
        // Se o handler não existir, executa uma função vazia para evitar erros
        (handlers[e.data.eventName] || function() {})(e.data);
    });
});