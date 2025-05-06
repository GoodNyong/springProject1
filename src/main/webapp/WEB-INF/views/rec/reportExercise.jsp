<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />

<main class="container mt-4" data-page="reportExercise">
	<h2 class="mb-4">운동 리포트</h2>

	<section class="mb-5">
		<h4>📅 날짜별 운동 요약</h4>
		 <div class="mb-3">
			<canvas id="exerciseChart" height="120"></canvas>
		</div>
	</section>

	<section>
		<h4>🎯 목표별 달성률</h4>
		<table class="table table-striped text-center">
			<thead class="table-light">
				<tr>
					<th>운동명</th>
					<th>목표 수치</th>
					<th>실제 기록</th>
					<th>달성률 (%)</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="goal" items="${goalList}">
					<tr>
						<td>${goal.exercise_name}</td>
						<td><fmt:formatNumber value="${goal.goal_value}" pattern="#"/>${goal.goal_unit_label}</td>
						<td>${goal.actual_value}</td>
						<td>${goal.progress_rate}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</section>
</main>

<!-- 데이터 바인딩 -->
<script>
var labels = [
	  <c:forEach items="${dailyList}" var="d" varStatus="s">
	    "<fmt:formatDate value='${d.activity_date}' pattern='yyyy-MM-dd'/>"
	    <c:if test="${!s.last}">,</c:if>
	  </c:forEach>
	];
var minutes = [<c:forEach items="${dailyList}" var="d" varStatus="s">${d.total_minutes}<c:if test="${!s.last}">,</c:if></c:forEach>];
var kcals   = [<c:forEach items="${dailyList}" var="d" varStatus="s">${d.total_calories}<c:if test="${!s.last}">,</c:if></c:forEach>];

new Chart(document.getElementById("exerciseChart"), {
  data: { labels: labels,
    datasets: [
      { type: "bar", label: "칼로리(kcal)", data: kcals },
      { type: "line", label: "운동시간(분)", data: minutes, yAxisID: "y1" }
    ]},
    options: {
	   scales: {
	     y:  { beginAtZero:true,
	           title:{ display:true, text:"칼로리(kcal)" } },
	     y1: { position:"right", beginAtZero:true,
	           title:{ display:true, text:"운동 시간(분)" } }
	   },
	   plugins: { legend:{ position:"bottom" } }
  }
});
</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
