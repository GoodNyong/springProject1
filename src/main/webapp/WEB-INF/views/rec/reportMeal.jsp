<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />

<main class="container mt-4" data-page="reportMeal">
	<h2 class="mb-4">식단 리포트</h2>

	<section class="mb-5">
		<h4>📅 날짜별 섭취 열량</h4>
		<div class="mb-3">
			<canvas id="mealChart" height="120"></canvas>
		</div>
	</section>

	<section>
		<h4>🎯 목표별 달성률</h4>
		<table class="table table-striped text-center">
			<thead class="table-light">
				<tr>
					<th>목표명</th>
					<th>목표 수치</th>
					<th>실제 섭취</th>
					<th>달성률 (%)</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="goal" items="${goalList}">
					<tr>
						<td>${goal.goal_name}</td>
						<td><fmt:formatNumber value="${goal.target_value}" pattern="#" />${goal.goal_unit_label}</td>
						<td><fmt:formatNumber value="${goal.actual_value}" pattern="#" />${goal.goal_unit_label}</td>
						<td>${goal.progress_rate}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</section>
</main>

<script>
var labels = [
  <c:forEach items="${dailyList}" var="d" varStatus="s">
    "<fmt:formatDate value='${d.meal_date}' pattern='yyyy-MM-dd'/>"
    <c:if test="${!s.last}">,</c:if>
  </c:forEach>
];
var kcals = [
  <c:forEach items="${dailyList}" var="d" varStatus="s">
    ${d.total_kcal}<c:if test="${!s.last}">,</c:if>
  </c:forEach>
];

new Chart(document.getElementById("mealChart"), {
  type: "bar",
  data: { labels: labels,
          datasets: [{ label: "총 열량(kcal)", data: kcals }] },
  options: {
    scales: {
      y: { beginAtZero:true,
           title:{ display:true, text:"열량(kcal)" } }
    },
    plugins: { legend:{ position:"bottom" } }
  }
});
</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
