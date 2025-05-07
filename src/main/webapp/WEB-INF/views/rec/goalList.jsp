<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="goal">
	<!-- 제목 -->
	<div class="mb-4 text-center">
		<h2>📋 목표 목록</h2>
		<p class="text-muted">현재 설정한 목표들을 확인해보세요. 어떤 루틴을 먼저 살펴볼까요?</p>
	</div>

	<!-- 리스트 스타일 분기 -->
	<ul class="list-group shadow-sm">
		<li class="list-group-item d-flex justify-content-between align-items-center py-4">
			<div>
				<h5 class="mb-2 text-primary fw-bold">🏃 운동 목표</h5>
				<p class="text-muted small mb-2">총 ${exStats.count}개 설정됨 · 평균 달성률 ${exStats.avgRate}%</p>
				<a href="${ctp}/rec/goalListExercise" class="btn btn-outline-primary btn-sm">운동 목표 보기</a>
			</div>
		</li>
		<li class="list-group-item d-flex justify-content-between align-items-center py-4">
			<div>
				<h5 class="mb-2 text-success fw-bold">🍱 식단 목표</h5>
				<p class="text-muted small mb-2">총 ${nuStats.count}개 설정됨 · 평균 달성률 ${nuStats.avgRate}%</p>
				<a href="${ctp}/rec/goalListNutrition" class="btn btn-outline-success btn-sm">식단 목표 보기</a>
			</div>
		</li>
	</ul>

	<!-- 마법사 -->
	<div class="text-center mt-5">
		<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
	</div>

	<!-- 하단 이동 -->
	<div class="text-center mt-4">
		<a href="${ctp}/main" class="btn btn-outline-secondary">🏠 메인으로 돌아가기</a>
	</div>
</main>

<!-- 마법사 상호작용 -->
<script>
document.addEventListener('DOMContentLoaded', function() {
	const exListBtn = document.querySelector("a[href*='goalListExercise']");
	const nuListBtn = document.querySelector("a[href*='goalListNutrition']");

	if (exListBtn) {
		exListBtn.addEventListener('mouseover', function() {
			showWizardMessage("운동 목표를 얼마나 달성했는지 확인해보자!");
		});
	}

	if (nuListBtn) {
		nuListBtn.addEventListener('mouseover', function() {
			showWizardMessage("식단 목표는 잘 지켜지고 있을까?");
		});
	}
});
</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
