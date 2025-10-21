<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="programming.model.ResultBean" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.enterprise.inject.spi.CDI" %>
<%@ page import="javax.enterprise.context.spi.CreationalContext" %>
<%@ page import="javax.enterprise.inject.spi.BeanManager" %>
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
        <jsp:include page="components/header.jsp" />
        
        <div class="content">
            <div class="left-panel">
                <jsp:include page="components/form.jsp" />
            </div>

            <div class="right-panel">
                <jsp:include page="components/graph.jsp" />
            </div>
        </div>
        <jsp:include page="components/results.jsp" />
    </div>

    <script>
        window.resultsData = [];
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
                for (ResultBean.ResultData result : results) {
        %>
        window.resultsData.push({x: <%= result.getX() %>, y: <%= result.getY() %>, r: <%= result.getR() %>, hit: <%= result.isHit() %>});
        <%
                }
            }
        } catch (Exception e) {
            // Если CDI не работает, используем пустой массив
        }
        %>
        console.log('Загружено результатов:', window.resultsData.length);
        console.log('Данные результатов:', window.resultsData);
    </script>
    <script src="js/validation.js?v=2"></script>
    <script src="js/graph.js?v=2"></script>
    <script src="js/form.js?v=2"></script>
    <script src="js/main.js?v=2"></script>
</body>
</html>