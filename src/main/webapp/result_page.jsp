<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="programming.model.ResultBean" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.enterprise.inject.spi.CDI" %>
<%@ page import="javax.enterprise.context.spi.CreationalContext" %>
<%@ page import="javax.enterprise.inject.spi.BeanManager" %>

<%
    ResultBean.ResultData currentResult = (ResultBean.ResultData) request.getAttribute("currentResult");
    if (currentResult == null) {
        response.sendRedirect("controller");
        return;
    }
%>

<!DOCTYPE html>
<html lang='ru'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Результат проверки</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #000000; text-align: center; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border: 1px solid #ddd; }
        th { background-color: #ffffff; color: black; }
        .result { font-size: 24px; font-weight: bold; text-align: center; 
                padding: 20px; margin: 20px 0; border-radius: 4px; color: #000000 }
        .hit { background-color: #d4edda; color: #155724; }
        .miss { background-color: #f8d7da; color: #721c24; }
        .link { text-align: center; margin-top: 20px; }
        .link a { display: inline-block; padding: 10px 20px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 4px; }
        .link a:hover { background-color: #45a049; }
        .results-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .results-table th, .results-table td { padding: 8px; text-align: center; border: 1px solid #ddd; }
        .results-table th { background-color: #667eea; color: white; }
        .hit-yes { color: #28a745; font-weight: bold; }
        .hit-no { color: #dc3545; font-weight: bold; }
    </style>
</head>
<body>
    <div class='container'>
        <h1>Результат проверки</h1>
    
        <table>
            <tr><th>Параметр</th><th>Значение</th></tr>
            <tr><td>Координата X</td><td><%= currentResult.getX() %></td></tr>
            <tr><td>Координата Y</td><td><%= currentResult.getY() %></td></tr>
            <tr><td>Радиус R</td><td><%= currentResult.getR() %></td></tr>
            <tr><td>Время выполнения</td><td><%= currentResult.getExecutionTime() %> нс</td></tr>
            <tr><td>Время запроса</td><td><%= currentResult.getTimestamp() %></td></tr>
        </table>
        

        <% if (currentResult.isHit()) { %>
            <div class='result hit'>точка попала в область</div>
        <% } else { %>
            <div class='result miss'>точка не попала в область</div>
        <% } %>

       
        <h2>История проверок</h2>
        <table class='results-table'>
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
                try {
                    // Получаем ResultBean через CDI
                    BeanManager beanManager = CDI.current().getBeanManager();
                    CreationalContext<ResultBean> creationalContext = beanManager.createCreationalContext(null);
                    javax.enterprise.inject.spi.Bean<ResultBean> bean = 
                        (javax.enterprise.inject.spi.Bean<ResultBean>) beanManager.getBeans(ResultBean.class).iterator().next();
                    ResultBean resultBean = (ResultBean) beanManager.getReference(bean, ResultBean.class, creationalContext);
                    
                    if (resultBean != null && resultBean.getResultsCount() > 0) {
                        List<ResultBean.ResultData> allResults = resultBean.getResults();
                        int index = 1;
                        for (ResultBean.ResultData res : allResults) {
                %>
                    <tr>
                        <td><%= index++ %></td>
                        <td><%= res.getX() %></td>
                        <td><%= res.getY() %></td>
                        <td><%= res.getR() %></td>
                        <td class='<%= res.isHit() ? "hit-yes" : "hit-no" %>'>
                            <%= res.isHit() ? "Попадание" : "Промах" %>
                        </td>
                        <td><%= res.getExecutionTime() %></td>
                        <td><%= res.getTimestamp() %></td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan='7' style='text-align: center; color: #999;'>
                            Нет результатов проверки
                        </td>
                    </tr>
                <%
                    }
                } catch (Exception e) {
                    // Если CDI не работает, показываем сообщение об ошибке
                %>
                    <tr>
                        <td colspan='7' style='text-align: center; color: #999;'>
                            Ошибка загрузки результатов
                        </td>
                    </tr>
                <%
                }
                %>
            </tbody>
        </table>

        <div class='link'>
            <a href='controller'>← Вернуться к форме</a>
        </div>
    </div>
</body>
</html>


