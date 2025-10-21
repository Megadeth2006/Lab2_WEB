<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programming.model.ResultBean" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.enterprise.inject.spi.CDI" %>
<%@ page import="javax.enterprise.context.spi.CreationalContext" %>
<%@ page import="javax.enterprise.inject.spi.BeanManager" %>

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
                try {
                    // Получаем ResultBean через CDI
                    BeanManager beanManager = CDI.current().getBeanManager();
                    CreationalContext<ResultBean> creationalContext = beanManager.createCreationalContext(null);
                    javax.enterprise.inject.spi.Bean<ResultBean> bean = 
                        (javax.enterprise.inject.spi.Bean<ResultBean>) beanManager.getBeans(ResultBean.class).iterator().next();
                    ResultBean resultBean = (ResultBean) beanManager.getReference(bean, ResultBean.class, creationalContext);
                    
                    if (resultBean != null && resultBean.getResultsCount() > 0) {
                        List<ResultBean.ResultData> results = resultBean.getResults();
                        int index = 1;
                        for (ResultBean.ResultData result : results) {
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
                } catch (Exception e) {
                    // Если CDI не работает, показываем сообщение об ошибке
                %>
                <tr>
                    <td colspan="7" style="text-align: center; color: #999;">
                        Ошибка загрузки результатов
                    </td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>
    </div>
</div>
