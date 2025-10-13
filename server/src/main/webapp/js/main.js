/**
 * Главный модуль приложения
 * Инициализирует все компоненты и координирует их работу
 */

// Инициализация при загрузке страницы
document.addEventListener('DOMContentLoaded', function() {
    // Создаем экземпляры классов
    const validator = new FormValidator();
    const graphRenderer = new GraphRenderer();
    const formHandler = new FormHandler(validator, graphRenderer);

    // Инициализируем компоненты
    formHandler.init();

    // Очищаем индикатор загрузки если он есть
    formHandler.clearLoadingIndicator();
    
    // Инициализируем график
    graphRenderer.redrawGraph(window.resultsData || []);
});

// Очистка индикатора загрузки при возврате на страницу
window.addEventListener('pageshow', function() {
    const loadingIndicator = document.getElementById('loading-indicator');
    if (loadingIndicator) {
        loadingIndicator.remove();
    }
});
