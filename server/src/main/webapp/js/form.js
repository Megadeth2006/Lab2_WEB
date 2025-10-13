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
        document.getElementById('check-form').addEventListener('submit', async (event) => {
            event.preventDefault(); // Предотвращаем стандартную отправку формы
            
            if (!this.validator.validateForm()) {
                return;
            }

            // Получаем данные из формы
            const formData = new FormData(event.target);
            const x = parseFloat(formData.get('x'));
            const y = parseFloat(formData.get('y'));
            const r = parseFloat(formData.get('r'));

            // Показываем индикатор загрузки
            this.showLoadingIndicator();

            // Отправляем данные
            await this.submitForm(x, y, r);
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

            // Показываем индикатор загрузки
            this.showLoadingIndicator();

            // Отправляем запрос на сервер
            this.submitForm(x, y, r);
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
     * Отправка формы с данными через AJAX
     */
    async submitForm(x, y, r) {
        try {
            console.log('Отправляем данные:', {x, y, r});
            
            // Создаем URLSearchParams для отправки
            const params = new URLSearchParams();
            params.append('x', x.toString());
            params.append('y', y.toString());
            params.append('r', r.toString());

            console.log('Отправляем запрос на controller...');
            console.log('Параметры:', params.toString());
            
            // Отправляем AJAX запрос (убираем заголовок Content-Type)
            const response = await fetch('controller', {
                method: 'POST',
                body: params
            });

            console.log('Получен ответ:', response.status, response.statusText);

            if (response.ok) {
                const responseText = await response.text();
                console.log('Текст ответа:', responseText);
                
                try {
                    const result = JSON.parse(responseText);
                    console.log('JSON ответ:', result);
                    
                    if (result.success) {
                        // Успешный ответ - перезагружаем страницу для обновления таблицы
                        window.location.reload();
                    } else {
                        // Ошибка от сервера
                        this.clearLoadingIndicator();
                        this.validator.showError(result.error || 'Неизвестная ошибка сервера');
                    }
                } catch (parseError) {
                    console.error('Ошибка парсинга JSON:', parseError);
                    console.log('Ответ не является JSON:', responseText);
                    this.clearLoadingIndicator();
                    this.validator.showError('Сервер вернул некорректный ответ');
                }
            } else {
                this.clearLoadingIndicator();
                this.validator.showError(`Ошибка сервера: ${response.status} ${response.statusText}`);
            }
        } catch (error) {
            console.error('Ошибка при отправке запроса:', error);
            this.clearLoadingIndicator();
            this.validator.showError('Ошибка сети при отправке запроса: ' + error.message);
        }
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
