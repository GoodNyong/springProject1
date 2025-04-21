<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="mealRecordInput">
	<div class="mb-4">
		<h2>🍽 식단 기록 입력</h2>
		<p class="text-muted">오늘 어떤 음식을 섭취했는지 기록해보세요.</p>
	</div>

	<div class="text-end mt-4">
		<p class="text-muted">💡 여러 끼니를 한 번에 입력하고 싶다면?</p>
		<a href="${ctp}/rec/mealRecordMultiInput" class="btn btn-outline-secondary btn-sm">➡ 다중 입력 페이지로 이동</a>
	</div>

	<div class="row">
		<!-- 입력 폼 -->
		<div class="col-md-6">
			<form method="post" class="needs-validation" novalidate>
				<input type="hidden" name="user_id" value="${sessionScope.loginUser.user_id}" />
				<input type="hidden" name="quantity" id="quantity_hidden" />

				<div class="mb-3">
					<label for="food_id" class="form-label">음식 선택</label>
					<select name="food_id" id="food_id" class="form-select" required>
						<option value="">음식을 선택하세요</option>
						<option value="1">밥</option>
						<option value="2">닭가슴살</option>
						<option value="3">샐러드</option>
						<option value="4">라면</option>
					</select>
				</div>

				<div class="mb-3">
					<label for="meal_time" class="form-label">식사 시간대</label>
					<select name="meal_time" id="meal_time" class="form-select" required>
						<option value="">시간대를 선택하세요</option>
						<option value="1">아침</option>
						<option value="2">점심</option>
						<option value="3">저녁</option>
						<option value="4">간식/기타</option>
					</select>
				</div>

				<div class="mb-3">
					<label class="form-label">섭취량</label>
					<div class="input-group">
						<input type="number" name="amount" id="amount" class="form-control" placeholder="예: 200" step="0.1" min="0.1" required /> <select name="unit" id="unit" class="form-select" required>
							<option value="">단위 선택</option>
							<option value="g">g</option>
							<option value="ml">ml</option>
							<option value="컵">컵</option>
							<option value="개">개</option>
							<option value="공기">공기</option>
							<option value="조각">조각</option>
						</select>
					</div>
				</div>

				<div class="mb-3">
					<label for="meal_date" class="form-label">식사 날짜</label>
					<input type="date" name="meal_date" id="meal_date" class="form-control"
						value="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>" required />
				</div>

				<div class="d-grid gap-2">
					<button type="submit" class="btn btn-primary btn-lg">✅ 기록 저장</button>
				</div>
			</form>

			<div class="mt-4 mb-4 text-center">
				<a href="${ctp}/user/main" class="btn btn-outline-primary">🏠 메인으로 돌아가기</a>
			</div>
		</div>

		<!-- 마법사 -->
		<div class="col-md-6 text-center">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>
</main>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />

<script type="text/javascript">
document.querySelector('form').addEventListener('submit', function (e) {
	const amount = document.getElementById('amount').value.trim();
	const unit = document.getElementById('unit').value;
	const hidden = document.getElementById('quantity_hidden');

	if (amount === '' || unit === '') {
		showWizardMessage("섭취량과 단위를 모두 입력해 주세요!");
		e.preventDefault();
		return false;
	}

	hidden.value = amount + unit; // ex: "200g"
});
</script>
