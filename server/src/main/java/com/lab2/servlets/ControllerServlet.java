package com.lab2.servlets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Контроллер-сервлет для маршрутизации запросов
 * Определяет тип запроса и делегирует его обработку соответствующему компоненту
 */
public class ControllerServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("ControllerServlet: получен запрос");
        System.out.println("Метод: " + request.getMethod());
        
        String xParam = request.getParameter("x");
        String yParam = request.getParameter("y");
        String rParam = request.getParameter("r");
        
        System.out.println("Параметры в ControllerServlet: x=" + xParam + 
                          ", y=" + yParam + ", r=" + rParam);
        
        // Проверяем, содержит ли запрос информацию о координатах точки и радиусе
        if (xParam != null && yParam != null && rParam != null && 
            !xParam.isEmpty() && !yParam.isEmpty() && !rParam.isEmpty()) {
            
            System.out.println("Обрабатываем запрос в ControllerServlet");
            // Обрабатываем запрос прямо в ControllerServlet
            processAreaCheck(request, response);
            
        } else {
            System.out.println("Перенаправляем на index.jsp");
            // Если параметров нет, передаем запрос на JSP страницу
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
    
    /**
     * Обработка проверки области
     */
    private void processAreaCheck(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        long startTime = System.nanoTime();
        
        try {
            // Получаем параметры с обработкой запятых
            String xStr = request.getParameter("x").replace(",", ".");
            String yStr = request.getParameter("y").replace(",", ".");
            String rStr = request.getParameter("r").replace(",", ".");
            
            System.out.println("Обработанные параметры: x=" + xStr + ", y=" + yStr + ", r=" + rStr);
            
            double x = Double.parseDouble(xStr);
            double y = Double.parseDouble(yStr);
            double r = Double.parseDouble(rStr);
            
            // Валидация данных
            if (!isValidX(x) || !isValidY(y) || !isValidR(r)) {
                sendJsonErrorResponse(response, "Некорректные значения параметров: X должен быть от -5 до 3, Y от -5 до 5, R от 1 до 4");
                return;
            }
            
            // Проверка попадания в область
            boolean hit = checkArea(x, y, r);
            
            long executionTime = System.nanoTime() - startTime;
            
            // Создаем результат
            com.lab2.model.Result result = new com.lab2.model.Result(x, y, r, hit, executionTime);
            
            // Получаем или создаем хранилище результатов в контексте приложения
            com.lab2.model.ResultsStorage storage = (com.lab2.model.ResultsStorage) getServletContext().getAttribute("resultsStorage");
            if (storage == null) {
                storage = new com.lab2.model.ResultsStorage();
                getServletContext().setAttribute("resultsStorage", storage);
            }
            
            // Добавляем результат в хранилище
            storage.addResult(result);
            
            // Возвращаем JSON ответ
            System.out.println("Отправляем JSON ответ для результата: " + result);
            sendJsonResponse(response, result);
            
        } catch (NumberFormatException e) {
            sendJsonErrorResponse(response, "Ошибка: некорректный формат числа. Убедитесь, что введены корректные числовые значения");
        } catch (Exception e) {
            sendJsonErrorResponse(response, "Ошибка сервера: " + e.getMessage());
        }
    }
    
    /**
     * Проверка попадания точки в область
     */
    private boolean checkArea(double x, double y, double r) {
        // Прямоугольник во 2-м квадранте (x ≤ 0, y ≥ 0)
        if (x <= 0 && y >= 0) {
            return x >= -r && x <= 0 && y >= 0 && y <= r;
        }
        
        // Четверть круга в 3-м квадранте (x ≤ 0, y ≤ 0)
        if (x <= 0 && y <= 0) {
            return (x * x + y * y) <= r * r;
        }
        
        // Треугольник в 1-м квадранте (x ≥ 0, y ≥ 0)
        if (x >= 0 && y >= 0) {
            return y <= (-x / 2 + r / 2) && x <= r && y <= r / 2;
        }
        
        // 4-й квадрант - нет фигур
        return false;
    }
    
    /**
     * Валидация координаты X
     */
    private boolean isValidX(double x) {
        return x >= -5 && x <= 3;
    }
    
    /**
     * Валидация координаты Y
     */
    private boolean isValidY(double y) {
        return y > -5 && y < 5;
    }
    
    /**
     * Валидация радиуса R
     */
    private boolean isValidR(double r) {
        return r >= 1 && r <= 4;
    }
    
    /**
     * Отправка JSON ответа с результатом
     */
    private void sendJsonResponse(HttpServletResponse response, com.lab2.model.Result result) 
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        java.io.PrintWriter out = response.getWriter();
        
        // Формируем JSON ответ более безопасно
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": true, ");
        json.append("\"result\": {");
        json.append("\"x\": ").append(result.getX()).append(", ");
        json.append("\"y\": ").append(result.getY()).append(", ");
        json.append("\"r\": ").append(result.getR()).append(", ");
        json.append("\"hit\": ").append(result.isHit()).append(", ");
        json.append("\"executionTime\": ").append(result.getExecutionTime()).append(", ");
        json.append("\"timestamp\": \"").append(result.getTimestamp()).append("\"");
        json.append("}");
        json.append("}");
        
        System.out.println("Отправляем JSON: " + json.toString());
        out.println(json.toString());
    }
    
    /**
     * Отправка JSON ошибки
     */
    private void sendJsonErrorResponse(HttpServletResponse response, String errorMessage) 
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        java.io.PrintWriter out = response.getWriter();
        
        // Экранируем кавычки в сообщении об ошибке
        String escapedMessage = errorMessage.replace("\"", "\\\"");
        String json = "{\"success\": false, \"error\": \"" + escapedMessage + "\"}";
        
        System.out.println("Отправляем JSON ошибки: " + json);
        out.println(json);
    }
}

