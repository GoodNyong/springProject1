<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="goalExercise">
	<!-- 제목 -->
	<div class="mb-4">
		<h2>🎯 운동 목표 설정</h2>
		<p class="text-muted">운동 목표를 정해보고 루틴을 실천해보세요.</p>
	</div>

	<div class="row">
		<!-- 입력 폼 -->
		<div class="col-md-6">
			<form method="post" action="${ctp}/rec/goalInputExerciseOk" class="needs-validation" novalidate>
				<input type="hidden" name="user_id" value="${sessionScope.loginUser.user_id}" /> <input type="hidden" name="set_by" value="1" />

				<!-- 운동 종류 -->
				<div class="mb-3">
					<label for="exercise_id" class="form-label">운동 종류</label>
					<select name="exercise_id" id="exercise_id" class="form-select" required>
						<option value="">운동을 선택하세요</option>
						<option value="1">걷기</option>
						<option value="2">러닝</option>
						<option value="3">사이클링</option>
						<option value="4">근력 운동</option>
					</select>
				</div>

				<!-- 목표 기준 -->
				<div class="mb-3">
					<label for="target_type" class="form-label">목표 기준</label>
					<select name="target_type" id="target_type" class="form-select" required>
						<option value="">기준을 선택하세요</option>
						<option value="1">시간 기준</option>
						<option value="2">열량 기준</option>
						<option value="3">횟수 기준</option>
					</select>
				</div>

				<!-- 목표 수치 + 단위 조합 -->
				<div class="mb-3">
					<label class="form-label">목표 수치</label>
					<div class="input-group">
						<input type="number" id="target_value" name="target_value" class="form-control" placeholder="예: 150" step="1" min="1" required />
						<select id="goal_unit" name="goal_unit" class="form-select" required>
							<option value="">단위 선택</option>
							<option value="">목표 기준을 먼저 선택해주세요</option>
						</select>
					</div>
				</div>

				<!-- 숨김 필드 (DB 저장용) -->
				<input type="hidden" name="target_value" id="quantity_hidden" />


				<div class="mb-3">
					<label for="start_date" class="form-label">시작일</label> <input type="date" name="start_date" id="start_date" class="form-control" required />
				</div>

				<div class="mb-4">
					<label for="end_date" class="form-label">종료일</label> <input type="date" name="end_date" id="end_date" class="form-control" required />
				</div>

				<div class="d-grid gap-2">
					<button type="submit" class="btn btn-primary btn-lg">✅ 목표 저장</button>
				</div>
			</form>

			<div class="mt-4 mb-4 text-center">
				<a href="${ctp}/user/main" class="btn btn-outline-primary">🏠 메인으로 돌아가기</a> <a href="${ctp}/rec/goalListExercise" class="btn btn-outline-secondary">← 목표 목록으로</a>
			</div>
		</div>

		<!-- 도우미 마법사 -->
		<div class="col-md-6 text-center">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>
</main>

<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function () {
	const typeSelect = document.getElementById("target_type");
	const unitSelect = document.getElementById("goal_unit");

	// 기준별 허용 단위 정의
	const unitOptions = {
		"1": [ { value: "01", label: "분" }, { value: "02", label: "시간" } ],
		"2": [ { value: "11", label: "kcal" }, { value: "12", label: "J" } ],
		"3": [ { value: "21", label: "회" }, { value: "22", label: "세트" } ]
	};

	typeSelect.addEventListener("change", function () {
		const selected = this.value;
		unitSelect.innerHTML = '<option value="">단위 선택</option>';

		if (unitOptions[selected]) {
			unitOptions[selected].forEach(function (opt) {
				const option = document.createElement("option");
				option.value = opt.value;
				option.textContent = opt.label;
				unitSelect.appendChild(option);
			});
		}
	});
});
</script>


<jsp:include page="/WEB-INF/views/include/footer.jsp" />
