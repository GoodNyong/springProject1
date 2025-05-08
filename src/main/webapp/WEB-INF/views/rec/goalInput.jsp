<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="goal">
	<!-- 페이지 제목 -->
	<div class="mb-4">
		<h2>🎯 목표 설정</h2>
		<p class="text-muted">오늘 설정할 목표를 선택해보세요. 운동과 식단 중 어떤 루틴에 마법을 걸고 싶으신가요?</p>
	</div>

	<div class="row">
		<!-- 선택 버튼 영역 -->
		<div class="col-md-6 mb-4">
			<div class="card border-primary shadow-sm h-100 text-center">
				<div class="card-body d-flex flex-column justify-content-between">
					<h5 class="card-title text-primary">🏃 운동 목표 설정</h5>
					<p class="card-text">오늘의 활동량, 시간 또는 칼로리를 목표로 설정해보세요.</p>
					<a href="${ctp}/rec/goalInputExercise" class="btn btn-outline-primary mt-3">운동 목표로 이동</a>
				</div>
			</div>
		</div>
		<div class="col-md-6 mb-4">
			<div class="card border-success shadow-sm h-100 text-center">
				<div class="card-body d-flex flex-column justify-content-between">
					<h5 class="card-title text-success">🍱 식단 목표 설정</h5>
					<p class="card-text">섭취할 영양소 또는 식품 목표를 정하고 건강 루틴을 계획해보세요.</p>
					<a href="${ctp}/rec/goalInputNutrition" class="btn btn-outline-success mt-3">식단 목표로 이동</a>
				</div>
			</div>
		</div>

		<!-- 도우미 마법사 -->
		<div class="col-12 text-center mt-4">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>

	<!-- 하단 이동 -->
	<div class="text-center mt-4">
		<a href="${ctp}/main" class="btn btn-outline-secondary">🏠 메인으로 돌아가기</a>
	</div>
</main>
<script>
document.addEventListener('DOMContentLoaded', function() {
	const exerciseGoalBtn = document.querySelector("a[href*='goalInputExercise']");
	const nutritionGoalBtn = document.querySelector("a[href*='goalInputNutrition']");

	if (exerciseGoalBtn) {
		exerciseGoalBtn.addEventListener('mouseover', function() {
			showWizardMessage("운동 루틴에 마법을 시전해볼까?");
		});
	}

	if (nutritionGoalBtn) {
		nutritionGoalBtn.addEventListener('mouseover', function() {
			showWizardMessage("식단 목표도 잊지 말자! 🍱");
		});
	}
});
</script>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
