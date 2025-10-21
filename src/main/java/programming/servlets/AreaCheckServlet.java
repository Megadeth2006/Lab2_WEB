package programming.servlets;

import programming.model.ResultBean;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.enterprise.inject.spi.CDI;
import javax.enterprise.context.spi.CreationalContext;
import javax.enterprise.inject.spi.BeanManager;
import javax.enterprise.inject.spi.Bean;
import java.io.IOException;
import java.util.Set;

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

        String xParam = request.getParameter("x");
        String yParam = request.getParameter("y");
        String rParam = request.getParameter("r");

        if (xParam == null || yParam == null || rParam == null ||
                xParam.isEmpty() || yParam.isEmpty() || rParam.isEmpty()) {
            System.out.println("AreaCheckServlet: параметры пустые, перенаправляем на controller");
            response.sendRedirect("controller");
            return;
        }

        long startTime = System.nanoTime();

        try {
            String xStr = xParam.replace(",", ".");
            String yStr = yParam.replace(",", ".");
            String rStr = rParam.replace(",", ".");

            System.out.println("Обработанные параметры: x=" + xStr + ", y=" + yStr + ", r=" + rStr);

            double x = Double.parseDouble(xStr);
            double y = Double.parseDouble(yStr);
            double r = Double.parseDouble(rStr);

            if (!isValidX(x) || !isValidY(y) || !isValidR(r)) {
                System.out.println("Ошибка валидации параметров");
                return;
            }

            boolean hit = checkArea(x, y, r);
            long executionTime = System.nanoTime() - startTime;


            ResultBean resultBean = getResultBean();
            System.out.println("Получен ResultBean");
            System.out.println("Количество результатов до добавления: " + resultBean.getResultsCount());

            resultBean.addResult(x, y, r, hit, executionTime);
            System.out.println("Количество результатов после добавления: " + resultBean.getResultsCount());

            ResultBean.ResultData resultData = new ResultBean.ResultData(x, y, r, hit, executionTime);
            sendResultResponse(request, response, resultData);

        } catch (NumberFormatException e) {
            System.out.println("Ошибка ввода: некорректные числовые значения");
        } catch (Exception e) {
            System.out.println("Ошибка обработки запроса: " + e.getMessage());
        }
    }

    private boolean checkArea(double x, double y, double r) {
        // Прямоугольник во 2 четверти (x ≤ 0, y ≥ 0)
        if (x <= 0 && y >= 0) {
            return x >= -r && y <= r;
        }

        // Четверть круга в 3-й четверти (x ≤ 0, y ≤ 0)
        if (x <= 0 && y <= 0) {
            return (x * x + y * y) <= r * r;
        }

        // Треугольник в 1 четверти (x ≥ 0, y ≥ 0)
        if (x >= 0 && y >= 0) {
            // Уравнение прямой: y = -x/2 + r/2
            return y <= (-x / 2 + r / 2) && x <= r && y <= r / 2;
        }

        return false;
    }

    private boolean isValidX(double x) {
        return x >= -5 && x <= 3;
    }

    private boolean isValidY(double y) {
        return y > -5 && y < 5;
    }

    private boolean isValidR(double r) {
        return r >= 1 && r <= 4;
    }

    private void sendResultResponse(HttpServletRequest request, HttpServletResponse response,
                                    ResultBean.ResultData resultData)
            throws ServletException, IOException {
        request.setAttribute("currentResult", resultData);
        request.getRequestDispatcher("/result_page.jsp").forward(request, response);
    }

    private ResultBean getResultBean() {
        try {
            BeanManager beanManager = CDI.current().getBeanManager();

            Set<Bean<?>> beans = beanManager.getBeans(ResultBean.class);
            if (beans == null || beans.isEmpty()) {
                System.out.println("ResultBean не найден в CDI-контейнере");
                return new ResultBean();
            }


            Bean<?> bean = beans.iterator().next();

            CreationalContext<?> ctx = beanManager.createCreationalContext(bean);

            Object reference = beanManager.getReference(bean, ResultBean.class, ctx);
            if (reference instanceof ResultBean) {
                return (ResultBean) reference;
            } else {
                return new ResultBean();
            }

        } catch (Exception e) {
            return new ResultBean();
        }
    }

}
