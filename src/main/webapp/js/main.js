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
    
    // Восстанавливаем сохраненные значения формы
    restoreFormValues();
    
    // Инициализируем график
    graphRenderer.redrawGraph(window.resultsData || []);
});

/**
 * Восстановление сохраненных значений формы
 */
function restoreFormValues() {
    // Восстанавливаем X
    const savedX = sessionStorage.getItem('formX');
    if (savedX) {
        const xSelect = document.getElementById('x-select');
        if (xSelect) {
            xSelect.value = savedX;
        }
    }
    
    // Восстанавливаем Y
    const savedY = sessionStorage.getItem('formY');
    if (savedY) {
        const yInput = document.getElementById('y-input');
        if (yInput) {
            yInput.value = savedY;
        }
    }
    
    // Восстанавливаем R
    const savedR = sessionStorage.getItem('formR');
    if (savedR) {
        const rInput = document.getElementById('r-input');
        if (rInput) {
            rInput.value = savedR;
        }
    }
}

/**
 * Сохранение значений формы
 */
function saveFormValues() {
    // Сохраняем X
    const xSelect = document.getElementById('x-select');
    if (xSelect && xSelect.value) {
        sessionStorage.setItem('formX', xSelect.value);
    }
    
    // Сохраняем Y
    const yInput = document.getElementById('y-input');
    if (yInput && yInput.value) {
        sessionStorage.setItem('formY', yInput.value);
    }
    
    // Сохраняем R
    const rInput = document.getElementById('r-input');
    if (rInput && rInput.value) {
        sessionStorage.setItem('formR', rInput.value);
    }
}

// Очистка индикатора загрузки при возврате на страницу
window.addEventListener('pageshow', function() {
    const loadingIndicator = document.getElementById('loading-indicator');
    if (loadingIndicator) {
        loadingIndicator.remove();
    }
});
