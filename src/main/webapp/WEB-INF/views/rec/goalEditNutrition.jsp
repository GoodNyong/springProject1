<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="goalEditMeal">
	<div class="mb-4">
		<h2>✏️ 식단 목표 수정</h2>
		<p class="text-muted">이전 목표를 조금 다르게 바꿔볼까요?</p>
	</div>

	<div class="row">
		<div class="col-md-6">
			<form method="post" action="${ctp}/rec/goalEditNutrition" class="needs-validation" novalidate>
				<input type="hidden" name="goal_id" value="${record.goal_id}" />
				<input type="hidden" name="user_id" value="${record.user_id}" />
				<input type="hidden" name="set_by" value="${record.set_by}" />

				<!-- 목표 유형 -->
				<div class="mb-3">
					<label for="goal_type" class="form-label">목표 유형</label>
					<select name="goal_type" id="goal_type" class="form-select" required>
						<option value="">유형 선택</option>
						<option value="1" ${record.goal_type == 1 ? 'selected' : ''}>영양소 기준</option>
						<option value="2" ${record.goal_type == 2 ? 'selected' : ''}>식품 기준</option>
					</select>
				</div>

				<!-- 영양소 영역 -->
				<div class="mb-3 ${record.goal_type != 1 ? 'd-none' : ''}" id="nutrient-section">
					<label for="nutrient_id" class="form-label">영양소 선택</label>
					<select name="nutrient_id" id="nutrient_id" class="form-select">
						<option value="">영양소 선택</option>
						<c:forEach var="nutrient" items="${nutrientList}">
							<option value="${nutrient.id}" 
								data-unit-code="${nutrient.goalUnitCode}"
								data-unit-label="${nutrient.goalUnitEnum.label}"
								${nutrient.id == record.nutrient_id ? 'selected' : ''}>
								${nutrient.name} (${nutrient.goalUnitEnum.label})
							</option>
						</c:forEach>
					</select>
				</div>

				<!-- 식품 영역 -->
				<div class="mb-3 ${record.goal_type != 2 ? 'd-none' : ''}" id="food-section">
					<label for="food_id" class="form-label">식품 선택</label>
					<select name="food_id" id="food_id" class="form-select">
						<option value="">식품 선택</option>
						<c:forEach var="food" items="${foodList}">
							<option value="${food.food_id}" ${food.food_id == record.food_id ? 'selected' : ''}>
								${food.name}
							</option>
						</c:forEach>
					</select>
				</div>

				<!-- 수치 + 단위 -->
				<div class="mb-3">
					<label class="form-label">목표 수치</label>
					<div class="input-group">
						<input type="number" id="target_value" name="target_value" class="form-control"
							value="${record.target_value}" step="0.1" min="0.1" required />
						<select name="goal_unit" id="goal_unit" class="form-select" required>
							<option value="${record.goal_unit}" selected>${record.goal_unit_label}</option>
						</select>
					</div>
				</div>

				<!-- 기간 -->
				<div class="mb-3">
					<fmt:formatDate var="start" value="${record.start_date}" pattern="yyyy-MM-dd" />
					<fmt:formatDate var="end" value="${record.end_date}" pattern="yyyy-MM-dd" />
					<label for="start_date" class="form-label">시작일</label>
					<input type="date" name="start_date" id="start_date" class="form-control" value="${start}" required readonly />
				</div>

				<div class="mb-4">
					<label for="end_date" class="form-label">종료일</label>
					<input type="date" name="end_date" id="end_date" class="form-control" value="${end}" required />
				</div>

				<div class="d-grid gap-2">
					<button type="submit" class="btn btn-success btn-lg">✅ 목표 수정</button>
				</div>
			</form>

			<div class="mt-4 mb-4 text-center">
				<a href="${ctp}/user/main" class="btn btn-outline-primary">🏠 메인으로</a>
				<a href="${ctp}/rec/goalListNutrition" class="btn btn-outline-secondary">← 목표 목록</a>
			</div>
		</div>

		<div class="col-md-6 text-center">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>
</main>

<script>
document.addEventListener("DOMContentLoaded", function () {
	const goalType = document.getElementById("goal_type");
	const nutrientSection = document.getElementById("nutrient-section");
	const foodSection = document.getElementById("food-section");
	const nutrientSelect = document.getElementById("nutrient_id");
	const goalUnitSelect = document.getElementById("goal_unit");
	const initialGoalUnit = "${record.goal_unit}";

	const foodUnitOptions = [
		{ code: "31", label: "g" }, { code: "32", label: "ml" },
		{ code: "33", label: "개" }, { code: "34", label: "컵" },
		{ code: "35", label: "공기" }, { code: "36", label: "조각" }
	];

	goalType.addEventListener("change", function () {
		const type = this.value;
		nutrientSection.classList.toggle("d-none", type !== "1");
		foodSection.classList.toggle("d-none", type !== "2");
		goalUnitSelect.innerHTML = "<option value=''>단위 선택</option>";

		if (type === "2") {
			foodUnitOptions.forEach(opt => {
				const option = document.createElement("option");
				option.value = opt.code;
				option.textContent = opt.label;
				if (opt.code === initialGoalUnit) option.selected = true;
				goalUnitSelect.appendChild(option);
			});
		}
	});

	nutrientSelect.addEventListener("change", function () {
		if (goalType.value !== "1") return;
		const selected = this.options[this.selectedIndex];
		const code = selected.getAttribute("data-unit-code");
		const label = selected.getAttribute("data-unit-label");

		goalUnitSelect.innerHTML = "<option value=''>단위 선택</option>";
		if (code && label) {
			const option = document.createElement("option");
			option.value = code;
			option.textContent = label;
			option.selected = true;
			goalUnitSelect.appendChild(option);
		}
	});
});
</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />