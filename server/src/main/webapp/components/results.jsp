<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lab2.model.ResultsStorage" %>
<%@ page import="com.lab2.model.Result" %>
<%@ page import="java.util.List" %>

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
