
class FormHandler {
    constructor(validator, graphRenderer) {
        this.validator = validator;
        this.graphRenderer = graphRenderer;
    }


    init() {
        this.initFormSubmit();
        this.initGraphClick();
        this.initRadiusChange();
    }


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
            const scale = this.graphRenderer.getScale(r);
            const x = (svgX - this.graphRenderer.CENTER_X) / scale;
            const y = (this.graphRenderer.CENTER_Y - svgY) / scale;

            console.log('Клик по графику:', {
                svgX, svgY,
                centerX: this.graphRenderer.CENTER_X,
                centerY: this.graphRenderer.CENTER_Y,
                scale,
                x, y, r
            });

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


    initRadiusChange() {
        const rInput = document.getElementById('r-input');
        if (rInput) {
            // Обновляем график при вводе
            rInput.addEventListener('input', () => {
                this.graphRenderer.redrawGraph(window.resultsData || []);
            });
            
            // Обновляем график при потере фокуса (когда пользователь закончил ввод)
            rInput.addEventListener('change', () => {
                this.graphRenderer.redrawGraph(window.resultsData || []);
            });
        }
    }


    fillAndSubmitForm(x, y, r) {
        console.log('Заполняем форму с координатами:', {x, y, r});
        
        // Заполняем поля формы
        const xSelect = document.getElementById('x-select');
        const yInput = document.getElementById('y-input');
        const rInput = document.getElementById('r-input');
        
        // Устанавливаем X - нужно найти ближайшее значение из select
        const xValues = [-5, -4, -3, -2, -1, 0, 1, 2, 3];
        let closestX = xValues[0];
        let minDiff = Math.abs(x - closestX);
        
        for (let val of xValues) {
            const diff = Math.abs(x - val);
            if (diff < minDiff) {
                minDiff = diff;
                closestX = val;
            }
        }
        
        xSelect.value = closestX.toString();
        
        // Устанавливаем Y
        yInput.value = y.toString();
        
        // Устанавливаем R
        rInput.value = r.toString();
        
        console.log('Значения формы установлены:', {
            x: xSelect.value,
            y: yInput.value,
            r: rInput.value
        });
        
        // Сохраняем значения формы
        if (typeof saveFormValues === 'function') {
            saveFormValues();
        }
        
        // Показываем индикатор загрузки
        this.showLoadingIndicator();
        
        console.log('Отправляем форму на check-area...');
        
        // Отправляем форму
        document.getElementById('check-form').submit();
    }


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


    clearLoadingIndicator() {
        const loadingIndicator = document.getElementById('loading-indicator');
        if (loadingIndicator) {
            loadingIndicator.remove();
        }
    }
}
