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
        
        String xParam = request.getParameter("x");
        String yParam = request.getParameter("y");
        String rParam = request.getParameter("r");
        
        // Проверяем, содержит ли запрос информацию о координатах точки и радиусе
        if (xParam != null && yParam != null && rParam != null && 
            !xParam.isEmpty() && !yParam.isEmpty() && !rParam.isEmpty()) {
            
            // Если параметры присутствуют, передаем запрос на AreaCheckServlet
            request.getRequestDispatcher("/check-area").forward(request, response);
            
        } else {
            // Если параметров нет, передаем запрос на JSP страницу
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}

