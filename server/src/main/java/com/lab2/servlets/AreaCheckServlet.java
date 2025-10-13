package com.lab2.servlets;

import com.lab2.model.Result;
import com.lab2.model.ResultsStorage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Сервлет для проверки попадания точки в область
 * Обрабатывает запросы, содержащие координаты точки и радиус
 */
public class AreaCheckServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("AreaCheckServlet: получен запрос");
        System.out.println("Метод: " + request.getMethod());
        System.out.println("Параметры: x=" + request.getParameter("x") + 
                          ", y=" + request.getParameter("y") + 
                          ", r=" + request.getParameter("r"));
        
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
                sendErrorResponse(response, "Некорректные значения параметров: X должен быть от -5 до 3, Y от -5 до 5, R от 1 до 4");
                return;
            }
            
            // Проверка попадания в область
            boolean hit = checkArea(x, y, r);
            
            long executionTime = System.nanoTime() - startTime;
            
            // Создаем результат
            Result result = new Result(x, y, r, hit, executionTime);
            
            // Получаем или создаем хранилище результатов в контексте приложения
            ResultsStorage storage = (ResultsStorage) getServletContext().getAttribute("resultsStorage");
            if (storage == null) {
                storage = new ResultsStorage();
                getServletContext().setAttribute("resultsStorage", storage);
            }
            
            // Добавляем результат в хранилище
            storage.addResult(result);
            
            // Возвращаем JSON ответ вместо HTML страницы
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
     * Область состоит из:
     * 1. Прямоугольник во 2-м квадранте (x ≤ 0, y ≥ 0): от (-R, 0) до (0, R)
     * 2. Четверть круга в 3-м квадранте (x ≤ 0, y ≤ 0): радиус R, центр (0,0)
     * 3. Треугольник в 1-м квадранте (x ≥ 0, y ≥ 0): вершины (0,0), (R,0), (0, R/2)
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
            // Уравнение прямой, соединяющей (R, 0) и (0, R/2): y = -x/2 + R/2
            return y <= (-x / 2 + r / 2) && x <= r && y <= r / 2;
        }
        
        // 4-й квадрант - нет фигур
        return false;
    }
    
    /**
     * Валидация координаты X
     * Допустимые значения: -5, -4, -3, -2, -1, 0, 1, 2, 3
     */
    private boolean isValidX(double x) {
        return x >= -5 && x <= 3;
    }
    
    /**
     * Валидация координаты Y
     * Допустимый диапазон: (-5; 5)
     */
    private boolean isValidY(double y) {
        return y > -5 && y < 5;
    }
    
    /**
     * Валидация радиуса R
     * Допустимые значения: 1, 2, 3, 4
     */
    private boolean isValidR(double r) {
        return r >= 1 && r <= 4;
    }
    
    /**
     * Отправка JSON ответа с результатом
     */
    private void sendJsonResponse(HttpServletResponse response, Result result) 
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // Формируем JSON ответ
        String json = String.format(
            "{\"success\": true, \"result\": {\"x\": %.2f, \"y\": %.2f, \"r\": %.2f, \"hit\": %s, \"executionTime\": %d, \"timestamp\": \"%s\"}}",
            result.getX(), result.getY(), result.getR(), result.isHit(), result.getExecutionTime(), result.getTimestamp()
        );
        
        out.println(json);
    }

    /**
     * Формирование HTML-страницы с результатом
     */
    private void sendResultResponse(HttpServletResponse response, Result result) 
            throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='ru'>");
        out.println("<head>");
        out.println("    <meta charset='UTF-8'>");
        out.println("    <meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("    <title>Результат проверки</title>");
        out.println("    <style>");
        out.println("        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }");
        out.println("        .container { max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }");
        out.println("        h1 { color: #333; text-align: center; }");
        out.println("        table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
        out.println("        th, td { padding: 12px; text-align: left; border: 1px solid #ddd; }");
        out.println("        th { background-color: #4CAF50; color: white; }");
        out.println("        .result { font-size: 24px; font-weight: bold; text-align: center; padding: 20px; margin: 20px 0; border-radius: 4px; }");
        out.println("        .hit { background-color: #d4edda; color: #155724; }");
        out.println("        .miss { background-color: #f8d7da; color: #721c24; }");
        out.println("        .link { text-align: center; margin-top: 20px; }");
        out.println("        .link a { display: inline-block; padding: 10px 20px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 4px; }");
        out.println("        .link a:hover { background-color: #45a049; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("    <div class='container'>");
        out.println("        <h1>Результат проверки</h1>");
        out.println("        <table>");
        out.println("            <tr><th>Параметр</th><th>Значение</th></tr>");
        out.println("            <tr><td>Координата X</td><td>" + result.getX() + "</td></tr>");
        out.println("            <tr><td>Координата Y</td><td>" + result.getY() + "</td></tr>");
        out.println("            <tr><td>Радиус R</td><td>" + result.getR() + "</td></tr>");
        out.println("            <tr><td>Время выполнения</td><td>" + result.getExecutionTime() + " нс</td></tr>");
        out.println("            <tr><td>Время запроса</td><td>" + result.getTimestamp() + "</td></tr>");
        out.println("        </table>");
        
        if (result.isHit()) {
            out.println("        <div class='result hit'>✓ Точка попадает в область</div>");
        } else {
            out.println("        <div class='result miss'>✗ Точка НЕ попадает в область</div>");
        }
        
        out.println("        <div class='link'>");
        out.println("            <a href='controller'>← Вернуться к форме</a>");
        out.println("        </div>");
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
    }
    
    /**
     * Отправка JSON ошибки
     */
    private void sendJsonErrorResponse(HttpServletResponse response, String errorMessage) 
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String json = String.format("{\"success\": false, \"error\": \"%s\"}", errorMessage);
        out.println(json);
    }

    /**
     * Отправка страницы с ошибкой
     */
    private void sendErrorResponse(HttpServletResponse response, String errorMessage) 
            throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='ru'>");
        out.println("<head>");
        out.println("    <meta charset='UTF-8'>");
        out.println("    <title>Ошибка</title>");
        out.println("    <style>");
        out.println("        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }");
        out.println("        .container { max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 8px; }");
        out.println("        .error { color: #721c24; background-color: #f8d7da; padding: 20px; border-radius: 4px; margin: 20px 0; }");
        out.println("        .link { text-align: center; margin-top: 20px; }");
        out.println("        .link a { display: inline-block; padding: 10px 20px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 4px; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("    <div class='container'>");
        out.println("        <h1>Ошибка</h1>");
        out.println("        <div class='error'>" + errorMessage + "</div>");
        out.println("        <div class='link'><a href='controller'>← Вернуться к форме</a></div>");
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
    }
}

