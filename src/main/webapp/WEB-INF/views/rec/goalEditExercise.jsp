<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="goalEditExercise">
	<div class="mb-4">
		<h2>✏️ 운동 목표 수정</h2>
		<p class="text-muted">설정한 마법 목표를 수정할 수 있어요.</p>
	</div>

	<div class="row">
		<div class="col-md-6">
			<form method="post" action="${ctp}/rec/goalEditExercise" class="needs-validation" novalidate>
				<input type="hidden" name="goal_id" value="${record.goal_id}" />
				<input type="hidden" name="user_id" value="${sessionScope.loginUser.user_id}" />
				<input type="hidden" name="set_by" value="${record.set_by}" />

				<!-- 운동 종류 -->
				<div class="mb-3">
					<label for="exercise_id" class="form-label">운동 종류</label>
					<select name="exercise_id" id="exercise_id" class="form-select" required>
						<option value="">운동을 선택하세요</option>
						<option value="1" ${record.exercise_id == 1 ? 'selected' : ''}>걷기</option>
						<option value="2" ${record.exercise_id == 2 ? 'selected' : ''}>러닝</option>
						<option value="3" ${record.exercise_id == 3 ? 'selected' : ''}>사이클링</option>
						<option value="4" ${record.exercise_id == 4 ? 'selected' : ''}>근력 운동</option>
					</select>
				</div>

				<!-- 목표 기준 -->
				<div class="mb-3">
					<label for="target_type" class="form-label">목표 기준</label>
					<select name="target_type" id="target_type" class="form-select" required>
						<option value="">기준 선택</option>
						<option value="1" ${record.target_type == 1 ? 'selected' : ''}>시간 기준</option>
						<option value="2" ${record.target_type == 2 ? 'selected' : ''}>열량 기준</option>
						<option value="3" ${record.target_type == 3 ? 'selected' : ''}>횟수 기준</option>
					</select>
				</div>

				<!-- 목표 수치 + 단위 -->
				<div class="mb-3">
					<label class="form-label">목표 수치</label>
					<div class="input-group">
						<input type="number" id="target_value" name="target_value" class="form-control" min="1" step="1"
						       value="${record.target_value}" required />
						<select id="goal_unit" name="goal_unit" class="form-select" required>
							<!-- JS에서 기준에 따라 단위 초기화됨 -->
						</select>
					</div>
				</div>

				<!-- 날짜 -->
				<div class="mb-3">
					<fmt:formatDate var="start" value="${record.start_date}" pattern="yyyy-MM-dd" />
					<fmt:formatDate var="end" value="${record.end_date}" pattern="yyyy-MM-dd" />
					<label for="start_date" class="form-label">시작일</label>
					<input type="date" name="start_date" id="start_date" class="form-control" value="${start}" required />
				</div>

				<div class="mb-4">
					<label for="end_date" class="form-label">종료일</label>
					<input type="date" name="end_date" id="end_date" class="form-control" value="${end}" required />
				</div>

				<div class="d-grid gap-2">
					<button type="submit" class="btn btn-warning btn-lg">✅ 목표 수정</button>
				</div>
			</form>

			<div class="mt-4 mb-4 text-center">
				<a href="${ctp}/user/main" class="btn btn-outline-primary">🏠 메인으로 돌아가기</a>
				<a href="${ctp}/rec/goalListExercise" class="btn btn-outline-secondary">← 목표 목록으로</a>
			</div>
		</div>

		<!-- 도우미 마법사 -->
		<div class="col-md-6 text-center">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>
</main>

<script>
document.addEventListener("DOMContentLoaded", function () {
	const typeSelect = document.getElementById("target_type");
	const unitSelect = document.getElementById("goal_unit");
	const initialUnit = "${record.goal_unit}";

	const unitOptions = {
		"1": [ { value: "01", label: "분" }, { value: "02", label: "시간" } ],
		"2": [ { value: "11", label: "kcal" }, { value: "12", label: "J" } ],
		"3": [ { value: "21", label: "회" }, { value: "22", label: "세트" } ]
	};

	function updateUnits(typeVal) {
		unitSelect.innerHTML = '<option value="">단위 선택</option>';
		if (unitOptions[typeVal]) {
			unitOptions[typeVal].forEach(function (opt) {
				const option = document.createElement("option");
				option.value = opt.value;
				option.textContent = opt.label;
				if (opt.value === initialUnit) option.selected = true;
				unitSelect.appendChild(option);
			});
		}
	}

	updateUnits(typeSelect.value); // 최초 로딩 시 단위 세팅
	typeSelect.addEventListener("change", function () {
		updateUnits(this.value);
	});
});
</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
