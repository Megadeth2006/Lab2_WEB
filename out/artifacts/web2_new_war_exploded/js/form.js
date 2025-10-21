/**
 * Модуль для работы с формой
 * Отвечает за обработку отправки формы и кликов по графику
 */

class FormHandler {
    constructor(validator, graphRenderer) {
        this.validator = validator;
        this.graphRenderer = graphRenderer;
    }

    /**
     * Инициализация обработчиков формы
     */
    init() {
        this.initFormSubmit();
        this.initGraphClick();
        this.initRadiusChange();
    }

    /**
     * Обработчик отправки формы
     */
    initFormSubmit() {
        document.getElementById('check-form').addEventListener('submit', (event) => {
            // Валидация на клиенте
            if (!this.validator.validateForm()) {
                event.preventDefault();
                return;
            }
            
            // Сохраняем значения формы перед отправкой
            if (typeof saveFormValues === 'function') {
                saveFormValues();
            }
            
            // Если валидация прошла, форма отправится обычным способом
            // Показываем индикатор загрузки
            this.showLoadingIndicator();
        });
    }

    /**
     * Обработчик клика по графику
     */
    initGraphClick() {
        document.getElementById('svg-graph').addEventListener('click', (event) => {
            const r = this.graphRenderer.getCurrentR();
            
            if (!r) {
                this.validator.showError('Пожалуйста, выберите радиус R перед кликом по графику!');
                return;
            }

            const svg = event.currentTarget;
            const rect = svg.getBoundingClientRect();
            const svgX = event.clientX - rect.left;
            const svgY = event.clientY - rect.top;

            // Преобразуем координаты SVG в координаты графика
            const scale = this.graphRenderer.GRAPH_SCALE;
            const x = (svgX - this.graphRenderer.CENTER_X) / scale;
            const y = (this.graphRenderer.CENTER_Y - svgY) / scale;

            // Показываем временную точку в месте клика
            this.graphRenderer.showTemporaryPoint(svg, svgX, svgY);

            // Валидация координат
            if (!this.validator.validateCoordinates(x, y)) {
                return;
            }

            // Заполняем форму и отправляем
            this.fillAndSubmitForm(x, y, r);
        });
    }

    /**
     * Обработчик изменения радиуса
     */
    initRadiusChange() {
        document.querySelectorAll('input[name="r"]').forEach(radio => {
            radio.addEventListener('change', () => {
                this.graphRenderer.redrawGraph(window.resultsData || []);
            });
        });
    }

    /**
     * Заполнение формы и отправка
     */
    fillAndSubmitForm(x, y, r) {
        // Заполняем поля формы
        const xSelect = document.getElementById('x-select');
        const yInput = document.getElementById('y-input');
        const rRadios = document.querySelectorAll('input[name="r"]');
        
        // Устанавливаем X
        xSelect.value = x.toString();
        
        // Устанавливаем Y
        yInput.value = y.toString();
        
        // Устанавливаем R
        rRadios.forEach(radio => {
            if (parseFloat(radio.value) === r) {
                radio.checked = true;
            }
        });
        
        // Сохраняем значения формы
        if (typeof saveFormValues === 'function') {
            saveFormValues();
        }
        
        // Показываем индикатор загрузки
        this.showLoadingIndicator();
        
        // Отправляем форму
        document.getElementById('check-form').submit();
    }

    /**
     * Показ индикатора загрузки
     */
    showLoadingIndicator() {
        const loadingDiv = document.createElement('div');
        loadingDiv.id = 'loading-indicator';
        loadingDiv.style.cssText = `
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(0,0,0,0.8);
            color: white;
            padding: 20px;
            border-radius: 8px;
            z-index: 10000;
            font-size: 16px;
            font-weight: bold;
        `;
        loadingDiv.textContent = 'Обработка запроса...';
        document.body.appendChild(loadingDiv);
    }

    /**
     * Очистка индикатора загрузки
     */
    clearLoadingIndicator() {
        const loadingIndicator = document.getElementById('loading-indicator');
        if (loadingIndicator) {
            loadingIndicator.remove();
        }
    }
}
