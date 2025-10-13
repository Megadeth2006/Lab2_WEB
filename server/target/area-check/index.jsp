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
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="container">
        <!-- Шапка страницы -->
        <jsp:include page="components/header.jsp" />
        
        <div class="content">
            <div class="left-panel">
                <!-- Форма ввода данных -->
                <jsp:include page="components/form.jsp" />
            </div>

            <div class="right-panel">
                <!-- График с областью -->
                <jsp:include page="components/graph.jsp" />
            </div>
        </div>

        <!-- Таблица результатов -->
        <jsp:include page="components/results.jsp" />
    </div>

    <script>
        // Данные результатов из сессии для отображения на графике
        const resultsData = [];
        <%
        ResultsStorage storage = (ResultsStorage) application.getAttribute("resultsStorage");
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
    </script>
    
    <!-- Подключение JavaScript модулей -->
    <script src="js/validation.js"></script>
    <script src="js/graph.js"></script>
    <script src="js/form.js"></script>
    <script src="js/main.js"></script>
</body>
</html>