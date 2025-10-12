<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lab2.model.ResultsStorage" %>
<%@ page import="com.lab2.model.Result" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Лабораторная работа №2 - Проверка попадания точки в область</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }

        .header-info {
            font-size: 16px;
            opacity: 0.9;
        }

        .content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            padding: 30px;
        }

        .left-panel, .right-panel {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .form-container, .graph-container {
            background-color: #f8f9fa;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .form-container h2, .graph-container h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 22px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
        }

        .form-group input[type="text"],
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .form-group input[type="text"]:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }

        .radio-group {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }

        .radio-group label {
            display: flex;
            align-items: center;
            font-weight: normal;
            cursor: pointer;
        }

        .radio-group input[type="radio"] {
            margin-right: 5px;
        }

        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        .error-message.show {
            display: block;
        }

        .submit-btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        #svg-graph {
            display: block;
            margin: 0 auto;
            border: 2px solid #ddd;
            border-radius: 4px;
            background-color: white;
            cursor: crosshair;
        }

        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
        }

        .results-table th,
        .results-table td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
        }

        .results-table th {
            background-color: #667eea;
            color: white;
            font-weight: 600;
        }

        .results-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .hit-yes {
            color: #28a745;
            font-weight: bold;
        }

        .hit-no {
            color: #dc3545;
            font-weight: bold;
        }

        @media (max-width: 968px) {
            .content {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Лабораторная работа №2</h1>
            <div class="header-info">
                <p><strong>Студент:</strong> Григорьев Даниил Александрович</p>
                <p><strong>Группа:</strong> P3216 | <strong>Вариант:</strong> 1</p>
            </div>
        </div>

        <div class="content">
            <div class="left-panel">
                <!-- Форма ввода данных -->
                <div class="form-container">
                    <h2>Параметры точки</h2>
                    <form id="check-form" method="POST" action="controller">
                        
                        <!-- Выбор координаты X -->
                        <div class="form-group">
                            <label for="x-select">Координата X:</label>
                            <select id="x-select" name="x" required>
                                <option value="">-- Выберите значение --</option>
                                <option value="-5">-5</option>
                                <option value="-4">-4</option>
                                <option value="-3">-3</option>
                                <option value="-2">-2</option>
                                <option value="-1">-1</option>
                                <option value="0">0</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                            </select>
                            <div class="error-message" id="x-error"></div>
                        </div>

                        <!-- Ввод координаты Y -->
                        <div class="form-group">
                            <label for="y-input">Координата Y (от -5 до 5):</label>
                            <input type="text" id="y-input" name="y" placeholder="Введите число от -5 до 5" required>
                            <div class="error-message" id="y-error"></div>
                        </div>

                        <!-- Выбор радиуса R -->
                        <div class="form-group">
                            <label>Радиус R:</label>
                            <div class="radio-group">
                                <label><input type="radio" name="r" value="1"> 1</label>
                                <label><input type="radio" name="r" value="2"> 2</label>
                                <label><input type="radio" name="r" value="3"> 3</label>
                                <label><input type="radio" name="r" value="4"> 4</label>
                            </div>
                            <div class="error-message" id="r-error"></div>
                        </div>

                        <button type="submit" class="submit-btn">Проверить точку</button>
                    </form>
                </div>
            </div>

            <div class="right-panel">
                <!-- График с областью -->
                <div class="graph-container">
                    <h2>График области</h2>
                    <svg id="svg-graph" width="400" height="400" xmlns="http://www.w3.org/2000/svg">
                        <!-- График будет отрисован через JavaScript -->
                    </svg>
                </div>
            </div>
        </div>

        <!-- Таблица результатов -->
        <div style="padding: 0 30px 30px 30px;">
            <h2 style="color: #333; margin-bottom: 15px;">История проверок</h2>
            <div style="overflow-x: auto;">
                <table class="results-table" id="results-table">
                    <thead>
                        <tr>
                            <th>№</th>
                            <th>X</th>
                            <th>Y</th>
                            <th>R</th>
                            <th>Результат</th>
                            <th>Время выполнения (нс)</th>
                            <th>Время запроса</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            ResultsStorage storage = (ResultsStorage) application.getAttribute("resultsStorage");
                            if (storage != null && storage.getResultsCount() > 0) {
                                List<Result> results = storage.getResults();
                                int index = 1;
                                for (Result result : results) {
                        %>
                        <tr>
                            <td><%= index++ %></td>
                            <td><%= result.getX() %></td>
                            <td><%= result.getY() %></td>
                            <td><%= result.getR() %></td>
                            <td class="<%= result.isHit() ? "hit-yes" : "hit-no" %>">
                                <%= result.isHit() ? "Попадание" : "Промах" %>
                            </td>
                            <td><%= result.getExecutionTime() %></td>
                            <td><%= result.getTimestamp() %></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: #999;">
                                Нет результатов проверки
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        // Данные результатов из сессии для отображения на графике
        const resultsData = [];
        <%
            if (storage != null && storage.getResultsCount() > 0) {
                List<Result> results = storage.getResults();
                for (Result result : results) {
        %>
        resultsData.push({x: <%= result.getX() %>, y: <%= result.getY() %>, r: <%= result.getR() %>, hit: <%= result.isHit() %>});
        <%
                }
            }
        %>
        
        // Отладочная информация
        console.log('Загружено результатов:', resultsData.length);
        console.log('Данные результатов:', resultsData);

        // Функция для показа ошибок
        function showError(message) {
            // Создаем элемент для ошибки
            let errorDiv = document.getElementById('error-message');
            if (!errorDiv) {
                errorDiv = document.createElement('div');
                errorDiv.id = 'error-message';
                errorDiv.style.cssText = 'position: fixed; top: 20px; right: 20px; background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; border: 1px solid #f5c6cb; z-index: 1000; max-width: 300px;';
                document.body.appendChild(errorDiv);
            }
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
            
            // Автоматически скрываем через 5 секунд
            setTimeout(() => {
                errorDiv.style.display = 'none';
            }, 5000);
        }

        // Константы для SVG
        const SVG_WIDTH = 400;
        const SVG_HEIGHT = 400;
        const CENTER_X = SVG_WIDTH / 2;
        const CENTER_Y = SVG_HEIGHT / 2;
        const GRAPH_SCALE = 60; // пикселей на единицу R

        let currentR = null;

        // Получение текущего значения R
        function getCurrentR() {
            const rRadio = document.querySelector('input[name="r"]:checked');
            return rRadio ? parseFloat(rRadio.value) : null;
        }

        // Отрисовка координатных осей
        function drawAxes(svg) {
            // Ось X
            const axisX = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            axisX.setAttribute('x1', '0');
            axisX.setAttribute('y1', CENTER_Y);
            axisX.setAttribute('x2', SVG_WIDTH);
            axisX.setAttribute('y2', CENTER_Y);
            axisX.setAttribute('stroke', '#000');
            axisX.setAttribute('stroke-width', '2');
            svg.appendChild(axisX);

            // Стрелка оси X
            const arrowX = document.createElementNS('http://www.w3.org/2000/svg', 'polygon');
            arrowX.setAttribute('points', `${SVG_WIDTH-5},${CENTER_Y-5} ${SVG_WIDTH},${CENTER_Y} ${SVG_WIDTH-5},${CENTER_Y+5}`);
            arrowX.setAttribute('fill', '#000');
            svg.appendChild(arrowX);

            // Ось Y
            const axisY = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            axisY.setAttribute('x1', CENTER_X);
            axisY.setAttribute('y1', '0');
            axisY.setAttribute('x2', CENTER_X);
            axisY.setAttribute('y2', SVG_HEIGHT);
            axisY.setAttribute('stroke', '#000');
            axisY.setAttribute('stroke-width', '2');
            svg.appendChild(axisY);

            // Стрелка оси Y
            const arrowY = document.createElementNS('http://www.w3.org/2000/svg', 'polygon');
            arrowY.setAttribute('points', `${CENTER_X-5},5 ${CENTER_X},0 ${CENTER_X+5},5`);
            arrowY.setAttribute('fill', '#000');
            svg.appendChild(arrowY);

            // Подписи осей
            const labelX = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            labelX.setAttribute('x', SVG_WIDTH - 15);
            labelX.setAttribute('y', CENTER_Y - 10);
            labelX.setAttribute('font-size', '16');
            labelX.setAttribute('font-weight', 'bold');
            labelX.textContent = 'X';
            svg.appendChild(labelX);

            const labelY = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            labelY.setAttribute('x', CENTER_X + 10);
            labelY.setAttribute('y', '15');
            labelY.setAttribute('font-size', '16');
            labelY.setAttribute('font-weight', 'bold');
            labelY.textContent = 'Y';
            svg.appendChild(labelY);
        }

        // Отрисовка области
        function drawArea(svg, r) {
            if (!r || r <= 0) return;

            const scale = GRAPH_SCALE;
            const rScaled = r * scale;

            // Прямоугольник во 2-м квадранте (x ≤ 0, y ≥ 0): от (-R, 0) до (0, R)
            const rect2 = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
            rect2.setAttribute('x', CENTER_X - rScaled);
            rect2.setAttribute('y', CENTER_Y - rScaled);
            rect2.setAttribute('width', rScaled);
            rect2.setAttribute('height', rScaled);
            rect2.setAttribute('fill', 'rgba(66, 135, 245, 0.5)');
            rect2.setAttribute('stroke', 'rgba(66, 135, 245, 0.8)');
            rect2.setAttribute('stroke-width', '2');
            svg.appendChild(rect2);

            // Четверть круга в 3-м квадранте (x ≤ 0, y ≤ 0): радиус R, центр (0,0)
            const circle = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            const circlePath = `M ${CENTER_X},${CENTER_Y} L ${CENTER_X - rScaled},${CENTER_Y} A ${rScaled},${rScaled} 0 0,1 ${CENTER_X},${CENTER_Y - rScaled} Z`;
            circle.setAttribute('d', circlePath);
            circle.setAttribute('fill', 'rgba(66, 135, 245, 0.5)');
            circle.setAttribute('stroke', 'rgba(66, 135, 245, 0.8)');
            circle.setAttribute('stroke-width', '2');
            svg.appendChild(circle);

            // Треугольник в 1-м квадранте (x ≥ 0, y ≥ 0): вершины (0,0), (R,0), (0, R/2)
            const triangle = document.createElementNS('http://www.w3.org/2000/svg', 'polygon');
            const trianglePoints = `${CENTER_X},${CENTER_Y} ${CENTER_X + rScaled},${CENTER_Y} ${CENTER_X},${CENTER_Y - rScaled/2}`;
            triangle.setAttribute('points', trianglePoints);
            triangle.setAttribute('fill', 'rgba(66, 135, 245, 0.5)');
            triangle.setAttribute('stroke', 'rgba(66, 135, 245, 0.8)');
            triangle.setAttribute('stroke-width', '2');
            svg.appendChild(triangle);

            // Метки на осях
            drawAxisMarks(svg, r);
        }

        // Отрисовка меток на осях
        function drawAxisMarks(svg, r) {
            const scale = GRAPH_SCALE;
            const marks = [
                { val: r, label: 'R' },
                { val: r/2, label: 'R/2' },
                { val: -r, label: '-R' },
                { val: -r/2, label: '-R/2' }
            ];

            marks.forEach(mark => {
                const scaled = mark.val * scale;

                // Метка на оси X (положительная)
                const markXPos = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                markXPos.setAttribute('x1', CENTER_X + scaled);
                markXPos.setAttribute('y1', CENTER_Y - 5);
                markXPos.setAttribute('x2', CENTER_X + scaled);
                markXPos.setAttribute('y2', CENTER_Y + 5);
                markXPos.setAttribute('stroke', '#000');
                markXPos.setAttribute('stroke-width', '2');
                svg.appendChild(markXPos);

                const labelXPos = document.createElementNS('http://www.w3.org/2000/svg', 'text');
                labelXPos.setAttribute('x', CENTER_X + scaled);
                labelXPos.setAttribute('y', CENTER_Y + 20);
                labelXPos.setAttribute('text-anchor', 'middle');
                labelXPos.setAttribute('font-size', '12');
                labelXPos.textContent = mark.label;
                svg.appendChild(labelXPos);

                // Метка на оси X (отрицательная)
                const markXNeg = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                markXNeg.setAttribute('x1', CENTER_X - scaled);
                markXNeg.setAttribute('y1', CENTER_Y - 5);
                markXNeg.setAttribute('x2', CENTER_X - scaled);
                markXNeg.setAttribute('y2', CENTER_Y + 5);
                markXNeg.setAttribute('stroke', '#000');
                markXNeg.setAttribute('stroke-width', '2');
                svg.appendChild(markXNeg);

                const labelXNeg = document.createElementNS('http://www.w3.org/2000/svg', 'text');
                labelXNeg.setAttribute('x', CENTER_X - scaled);
                labelXNeg.setAttribute('y', CENTER_Y + 20);
                labelXNeg.setAttribute('text-anchor', 'middle');
                labelXNeg.setAttribute('font-size', '12');
                labelXNeg.textContent = '-' + mark.label;
                svg.appendChild(labelXNeg);

                // Метка на оси Y (положительная)
                const markYPos = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                markYPos.setAttribute('x1', CENTER_X - 5);
                markYPos.setAttribute('y1', CENTER_Y - scaled);
                markYPos.setAttribute('x2', CENTER_X + 5);
                markYPos.setAttribute('y2', CENTER_Y - scaled);
                markYPos.setAttribute('stroke', '#000');
                markYPos.setAttribute('stroke-width', '2');
                svg.appendChild(markYPos);

                const labelYPos = document.createElementNS('http://www.w3.org/2000/svg', 'text');
                labelYPos.setAttribute('x', CENTER_X - 20);
                labelYPos.setAttribute('y', CENTER_Y - scaled + 5);
                labelYPos.setAttribute('text-anchor', 'middle');
                labelYPos.setAttribute('font-size', '12');
                labelYPos.textContent = mark.label;
                svg.appendChild(labelYPos);

                // Метка на оси Y (отрицательная)
                const markYNeg = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                markYNeg.setAttribute('x1', CENTER_X - 5);
                markYNeg.setAttribute('y1', CENTER_Y + scaled);
                markYNeg.setAttribute('x2', CENTER_X + 5);
                markYNeg.setAttribute('y2', CENTER_Y + scaled);
                markYNeg.setAttribute('stroke', '#000');
                markYNeg.setAttribute('stroke-width', '2');
                svg.appendChild(markYNeg);

                const labelYNeg = document.createElementNS('http://www.w3.org/2000/svg', 'text');
                labelYNeg.setAttribute('x', CENTER_X - 20);
                labelYNeg.setAttribute('y', CENTER_Y + scaled + 5);
                labelYNeg.setAttribute('text-anchor', 'middle');
                labelYNeg.setAttribute('font-size', '12');
                labelYNeg.textContent = '-' + mark.label;
                svg.appendChild(labelYNeg);
            });
        }

        // Отрисовка точек из результатов
        function drawPoints(svg, r) {
            if (!r || r <= 0) return;

            const scale = GRAPH_SCALE;
            const filteredResults = resultsData.filter(result => result.r === r);
            
            console.log('Текущий радиус R:', r);
            console.log('Отфильтрованные результаты для R=' + r + ':', filteredResults);

            filteredResults.forEach(result => {
                const svgX = CENTER_X + result.x * scale;
                const svgY = CENTER_Y - result.y * scale;

                const point = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
                point.setAttribute('cx', svgX);
                point.setAttribute('cy', svgY);
                point.setAttribute('r', '4');
                point.setAttribute('fill', result.hit ? '#28a745' : '#dc3545');
                point.setAttribute('stroke', '#fff');
                point.setAttribute('stroke-width', '1');
                point.setAttribute('opacity', '0.8');
                svg.appendChild(point);
            });
        }

        // Отрисовка всех точек (для отображения при смене радиуса)
        function drawAllPoints(svg) {
            const scale = GRAPH_SCALE;
            
            resultsData.forEach(result => {
                const svgX = CENTER_X + result.x * scale;
                const svgY = CENTER_Y - result.y * scale;

                const point = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
                point.setAttribute('cx', svgX);
                point.setAttribute('cy', svgY);
                point.setAttribute('r', '3');
                point.setAttribute('fill', result.hit ? '#28a745' : '#dc3545');
                point.setAttribute('stroke', '#fff');
                point.setAttribute('stroke-width', '1');
                point.setAttribute('opacity', '0.6');
                svg.appendChild(point);
            });
        }

        // Полная перерисовка графика
        function redrawGraph() {
            const svg = document.getElementById('svg-graph');
            svg.innerHTML = ''; // Очищаем SVG

            const r = getCurrentR();
            currentR = r;

            drawAxes(svg);
            
            if (r) {
                drawArea(svg, r);
                drawPoints(svg, r);
            } else {
                // Если радиус не выбран, показываем все точки
                drawAllPoints(svg);
            }
        }

        // Обработчик клика по SVG
        document.getElementById('svg-graph').addEventListener('click', function(event) {
            const r = getCurrentR();
            
            if (!r) {
                showError('Пожалуйста, выберите радиус R перед кликом по графику!');
                return;
            }

            const svg = event.currentTarget;
            const rect = svg.getBoundingClientRect();
            const svgX = event.clientX - rect.left;
            const svgY = event.clientY - rect.top;

            // Преобразуем координаты SVG в координаты графика
            const scale = GRAPH_SCALE;
            const x = (svgX - CENTER_X) / scale;
            const y = (CENTER_Y - svgY) / scale;

            // Отправляем запрос на сервер
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'controller';

            const inputX = document.createElement('input');
            inputX.type = 'hidden';
            inputX.name = 'x';
            // Сохраняем точное значение без ограничения точности
            inputX.value = x.toString();
            form.appendChild(inputX);

            const inputY = document.createElement('input');
            inputY.type = 'hidden';
            inputY.name = 'y';
            // Сохраняем точное значение без ограничения точности
            inputY.value = y.toString();
            form.appendChild(inputY);

            const inputR = document.createElement('input');
            inputR.type = 'hidden';
            inputR.name = 'r';
            inputR.value = r;
            form.appendChild(inputR);

            document.body.appendChild(form);
            form.submit();
        });

        // Обработчик изменения радиуса
        document.querySelectorAll('input[name="r"]').forEach(radio => {
            radio.addEventListener('change', function() {
                redrawGraph();
            });
        });

        // Валидация формы
        document.getElementById('check-form').addEventListener('submit', function(event) {
            let isValid = true;

            // Сброс ошибок
            document.querySelectorAll('.error-message').forEach(el => el.classList.remove('show'));

            // Проверка X
            const xSelect = document.getElementById('x-select');
            if (!xSelect.value) {
                document.getElementById('x-error').textContent = 'Выберите значение X';
                document.getElementById('x-error').classList.add('show');
                isValid = false;
            } else {
                const xValue = parseFloat(xSelect.value);
                if (xValue < -5 || xValue > 3) {
                    document.getElementById('x-error').textContent = 'X должно быть от -5 до 3';
                    document.getElementById('x-error').classList.add('show');
                    isValid = false;
                }
            }

            // Проверка Y
            const yInput = document.getElementById('y-input');
            const yValue = yInput.value.trim().replace(',', '.');
            
            if (!yValue) {
                document.getElementById('y-error').textContent = 'Введите значение Y';
                document.getElementById('y-error').classList.add('show');
                isValid = false;
            } else if (isNaN(yValue)) {
                document.getElementById('y-error').textContent = 'Y должно быть числом';
                document.getElementById('y-error').classList.add('show');
                isValid = false;
            } else {
                const y = parseFloat(yValue);
                if (y <= -5 || y >= 5) {
                    document.getElementById('y-error').textContent = 'Y должно быть в диапазоне (-5; 5)';
                    document.getElementById('y-error').classList.add('show');
                    isValid = false;
                } else {
                    // Сохраняем точное значение без ограничения точности
                    yInput.value = yValue;
                }
            }

            // Проверка R
            const rRadio = document.querySelector('input[name="r"]:checked');
            if (!rRadio) {
                document.getElementById('r-error').textContent = 'Выберите значение R';
                document.getElementById('r-error').classList.add('show');
                isValid = false;
            } else {
                const rValue = parseFloat(rRadio.value);
                if (rValue < 1 || rValue > 4) {
                    document.getElementById('r-error').textContent = 'R должно быть от 1 до 4';
                    document.getElementById('r-error').classList.add('show');
                    isValid = false;
                }
            }

            if (!isValid) {
                event.preventDefault();
            }
        });

        // Инициализация графика при загрузке страницы
        window.addEventListener('load', function() {
            redrawGraph();
        });
    </script>
</body>
</html>


