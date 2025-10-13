<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
