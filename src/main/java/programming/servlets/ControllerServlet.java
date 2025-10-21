package programming.servlets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;



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
        

        if (xParam != null && yParam != null && rParam != null && 
            !xParam.isEmpty() && !yParam.isEmpty() && !rParam.isEmpty()) {
            
            System.out.println("Делегируем обработку AreaCheckServlet");

            request.getRequestDispatcher("/check-area").forward(request, response);
            
        } else {
            System.out.println("Перенаправляем на index.jsp");

            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
    
}

