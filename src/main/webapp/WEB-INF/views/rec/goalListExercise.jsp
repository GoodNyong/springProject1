<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="goalExerciseList">
	<div class="row">
		<div class="mb-4 col">
			<h2>🎯 운동 목표 목록</h2>
			<p class="text-muted">당신이 설정한 마법의 루틴을 확인해보세요.</p>
		</div>
		<div class="col-auto text-center" style="max-width: 180px;">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>

	<c:if test="${empty exerciseGoalList}">
		<div class="alert alert-info text-center">등록된 운동 목표가 없습니다. 새로운 마법 목표를 설정해보세요.</div>
	</c:if>

	<div class="text-end mb-2">
		<a href="${ctp}/rec/goalInputExercise" class="btn btn-outline-primary">+목표 설정</a>
		<button class="btn btn-outline-warning" id="toggleEditModeBtn">✏️수정모드</button>
		<button class="btn btn-outline-secondary d-none" id="cancelEditModeBtn">❌수정취소</button>
	</div>

	<c:if test="${not empty exerciseGoalList}">
		<div class="p-4 rounded-4 shadow-sm bg-info-subtle" style="overflow-x: auto;">
			<table class="table text-center align-middle rounded-3 overflow-hidden mb-0" style="min-width: 700px;">
				<thead>
					<tr class="bg-light">
						<th>no.</th>
						<th>운동명</th>
						<th>기준</th>
						<th>목표 수치</th>
						<th>기간</th>
						<th>설정자</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${exerciseGoalList}" varStatus="st">
						<tr data-index="${status.index}" data-expired="${vo.expired}">
							<td>${st.count}</td>
							<td>${vo.exercise_name}</td>
							<td><c:choose>
									<c:when test="${vo.target_type == 1}">시간</c:when>
									<c:when test="${vo.target_type == 2}">칼로리</c:when>
									<c:otherwise>횟수</c:otherwise>
								</c:choose></td>
							<td><c:choose>
									<c:when test="${vo.target_value % 1 == 0}">
										<fmt:formatNumber value="${vo.target_value}" type="number" maxFractionDigits="0" />
										${vo.goal_unit_label}
									</c:when>
									<c:otherwise>
										<fmt:formatNumber value="${vo.target_value}" type="number" maxFractionDigits="2" />
										${vo.goal_unit_label}
									</c:otherwise>
								</c:choose></td>
							<td><fmt:formatDate value="${vo.start_date}" pattern="yyyy-MM-dd" /> ~ <fmt:formatDate value="${vo.end_date}" pattern="yyyy-MM-dd" /></td>
							<td class="text-nowrap"><c:choose>
									<c:when test="${vo.set_by == 1}">🙋‍♂️ 본인</c:when>
									<c:otherwise>🧙 전문가</c:otherwise>
								</c:choose></td>
							<td>
								<c:choose>
									<c:when test="${vo.expired}">
										<span class="text-muted">종료됨</span>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn btn-primary" onclick="editGoal(${vo.goal_id})">수정</button>
									</c:otherwise>
								</c:choose>
								<a href="javascript:void(0);" class="btn btn-sm btn-outline-danger" onclick="confirmSingleGoalDelete(${vo.goal_id});">삭제</a>
								<input type="hidden" name="goal_id" value="${vo.goal_id}" />
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</c:if>

	<div class="mt-4 text-center">
		<a href="${ctp}/user/main" class="btn btn-outline-primary">🏠 메인으로 돌아가기</a>
	</div>
</main>

<script type="text/javascript">
const ctp = "${ctp}";
let isEditMode = false;
let editBtn, cancelBtn, selectAllBtn;

//버튼 텍스트 업데이트
function updateGoalEditButtonLabel() {
	const rows = document.querySelectorAll("tbody tr");
	let total = 0, selected = 0, changed = 0;

	rows.forEach(row => {
		total++;
		if (row.classList.contains("table-success")) selected++;
		if (row.querySelector("input[name*='.changed']")) changed++;
	});

	// 수정/삭제 버튼 텍스트 갱신
	if (changed > 0) {
		editBtn.textContent = "✅적용하기";
	} else if (selected > 0) {
		editBtn.textContent = "🗑️선택삭제";
	} else {
		editBtn.textContent = "✅적용하기";
	}

	// 전체선택 버튼 텍스트 실시간 반영
	if (selectAllBtn) {
		selectAllBtn.textContent = selected > 0 ? "❌선택해제" : "✔️전체선택";
	}
}


// 단일 삭제
function confirmSingleGoalDelete(goalId) {
	const confirmBox = document.querySelector("#wizard-delete-confirm");
	const yesBtn = document.getElementById("wizard-confirm-yes");
	const noBtn = document.getElementById("wizard-confirm-no");

	confirmBox.classList.remove("d-none");

	yesBtn.onclick = () => {
		confirmBox.classList.add("d-none");
		location.href = ctp + "/rec/goalDeleteExercise?goal_id=" + goalId;
	};

	noBtn.onclick = () => {
		confirmBox.classList.add("d-none");
	};
}

//수정모드 로직
document.addEventListener('DOMContentLoaded', function () {
	editBtn = document.getElementById('toggleEditModeBtn');
	cancelBtn = document.getElementById('cancelEditModeBtn');
	selectAllBtn = document.getElementById('toggleSelectAllBtn');
	const table = document.querySelector('table');

	if (!editBtn || !cancelBtn || !table) return;

	const toggleSelectAllBtn = document.createElement("button");
	toggleSelectAllBtn.className = "btn btn-outline-dark me-1 d-none";
	toggleSelectAllBtn.id = "toggleSelectAllBtn";
	toggleSelectAllBtn.textContent = "✔️전체선택";
	editBtn.parentNode.insertBefore(toggleSelectAllBtn, editBtn);
	selectAllBtn = toggleSelectAllBtn;               // ← 생성 직후 전역 변수에 재연결

	toggleSelectAllBtn.addEventListener("click", () => {
		const rows = document.querySelectorAll("tbody tr");
		const shouldDeselect = [...rows].some(row => row.classList.contains("table-success"));

		rows.forEach(row => {
			if (shouldDeselect) {
				row.classList.remove("table-success");
				row.removeAttribute("data-selected");
			} else {
				row.classList.add("table-success");
				row.setAttribute("data-selected", "true");
			}
		});

		toggleSelectAllBtn.textContent = shouldDeselect ? "✔️전체선택" : "❌선택해제";
		updateGoalEditButtonLabel();
	});

	editBtn.addEventListener('click', function () {
		const rows = table.querySelectorAll('tbody tr');

		if (isEditMode) {
			const success = submitGoalMultiUpdate();
			if (!success) return;
		}

		isEditMode = !isEditMode;
		editBtn.textContent = isEditMode ? '✅적용하기' : '✏️수정모드';
		cancelBtn.classList.toggle('d-none', !isEditMode);
		toggleSelectAllBtn.classList.toggle('d-none', !isEditMode);

		rows.forEach((row, index) => {
			const isExpired = row.getAttribute("data-expired") === "true";

			const cells = row.querySelectorAll('td');
			const [noCell, nameCell, typeCell, valueCell, dateCell, setByCell, controlCell] = cells;

			if (isEditMode) {
				const goalIdInput = row.querySelector("input[name='goal_id']");
				if (!goalIdInput) return;
				const goalId = goalIdInput.value;

				const targetValueRaw = valueCell.textContent.trim();
				const targetValue = parseFloat(targetValueRaw.replace(/[^\d.]/g, ''));
				const unitLabel = valueCell.textContent.replace(/^[\d.,\s]+/, '').trim();
				const labelToCodeMap = { "분": "01", "시간": "02", "kcal": "11", "J": "12", "회": "21", "세트": "22" };
				const unitCode = labelToCodeMap[unitLabel] || "";

				const dateText = dateCell.textContent.trim();
				let start = "", end = "";
				if (dateText.includes("~")) {
					[start, end] = dateText.split("~").map(s => s.trim());
				}

				const currentTypeText = typeCell.textContent.trim();
				const typeMap = { "시간": "1", "칼로리": "2", "횟수": "3" };
				const typeCode = typeMap[currentTypeText] || "1";

				const exerciseName = nameCell.textContent.trim();
				const exerciseNameToId = { "걷기": "1", "러닝": "2", "사이클링": "3", "근력 운동": "4" };
				const exerciseId = exerciseNameToId[exerciseName] || "1";

				nameCell.innerHTML = "<select name='exercise_id' class='form-select form-select-sm'" +
					(isExpired ? " disabled" : "") + ">" +
					"<option value='1'" + (exerciseId === "1" ? " selected" : "") + ">걷기</option>" +
					"<option value='2'" + (exerciseId === "2" ? " selected" : "") + ">러닝</option>" +
					"<option value='3'" + (exerciseId === "3" ? " selected" : "") + ">사이클링</option>" +
					"<option value='4'" + (exerciseId === "4" ? " selected" : "") + ">근력 운동</option>" +
				"</select>";

				typeCell.innerHTML = "<select name='target_type' class='form-select form-select-sm'" +
					(isExpired ? " disabled" : "") + ">" +
					"<option value='1'" + (typeCode === '1' ? " selected" : "") + ">시간</option>" +
					"<option value='2'" + (typeCode === '2' ? " selected" : "") + ">칼로리</option>" +
					"<option value='3'" + (typeCode === '3' ? " selected" : "") + ">횟수</option>" +
				"</select>";

				valueCell.innerHTML =
					"<div class='input-group'>" +
					"<input type='number' name='target_value' class='form-control form-control-sm' value='" + targetValue + "' step='0.1' min='0.1' required" +
					(isExpired ? " disabled" : "") + " />" +
					"<select name='goal_unit' class='form-select form-select-sm' required" +
					(isExpired ? " disabled" : "") + "></select>" +
					"</div>";

				const targetTypeSelect = typeCell.querySelector("select[name='target_type']");
				const goalUnitSelect = valueCell.querySelector("select[name='goal_unit']");
				updateUnitSelect(goalUnitSelect, typeCode, unitCode);

				targetTypeSelect.addEventListener("change", function () {
					updateUnitSelect(goalUnitSelect, this.value, "");
				});

				dateCell.innerHTML =
					"<input type='date' name='start_date' class='form-control form-control-sm mb-1' value='" + start + "' readonly />" +
					"<input type='date' name='end_date' class='form-control form-control-sm' value='" + end + "' required" +
					(isExpired ? " disabled" : "") + " />";

				controlCell.innerHTML = "<input type='hidden' name='goal_id' value='" + goalId + "' />" +
					(isExpired
						? "<span class='text-muted'>수정불가</span>"
						: "<button class='btn btn-sm btn-outline-success' onclick='submitSingleGoalEdit(this)'>개별저장</button>");

				// 변경 감지
				const inputs = row.querySelectorAll("input, select");
				inputs.forEach(input => {
					input.addEventListener('change', () => {
						let changed = row.querySelector("input[name='goalList[" + index + "].changed']");
						if (!changed) {
							changed = document.createElement("input");
							changed.type = "hidden";
							changed.name = "goalList[" + index + "].changed";
							changed.value = "true";
							row.appendChild(changed);
						}
						updateGoalEditButtonLabel();
					});
				});

				// ✅ 클릭 시 행 선택 (삭제용) 허용
				row.addEventListener("click", (e) => {
					if (e.target.closest("button") || e.target.tagName === "A") return;

					if (e.target.tagName === "INPUT" || e.target.tagName === "SELECT") {
						if (e.target.disabled) {
							row.classList.toggle("table-success");
							row.dataset.selected = row.classList.contains("table-success");
							updateGoalEditButtonLabel();
						}
						return;
					}

					row.classList.toggle("table-success");
					row.dataset.selected = row.classList.contains("table-success");
					updateGoalEditButtonLabel();
				});

			} else {
				location.reload();
			}
		});
	});
	cancelBtn.addEventListener('click', function () {
		location.reload();
	});
});

// 개별 저장 처리
function submitSingleGoalEdit(button) {
	const row = button.closest("tr");

	if (!validateFormOnSubmit(row)) return;

	const form = document.createElement("form");
	form.method = "post";
	form.action = ctp + "/rec/goalUpdateExercise";
	form.setAttribute("data-dynamic-form", "true");

	const goalId = row.querySelector("input[name='goal_id']").value;
	const goalUnit = row.querySelector("select[name='goal_unit']").value;
	const targetValue = row.querySelector("input[name='target_value']").value;
	const startDate = row.querySelector("input[name='start_date']").value;
	const endDate = row.querySelector("input[name='end_date']").value;
	const targetType = row.querySelector("select[name='target_type']").value;
	const exerciseId = row.querySelector("select[name='exercise_id']").value;

	form.appendChild(createHidden("exercise_id", exerciseId));
	form.appendChild(createHidden("goal_id", goalId));
	form.appendChild(createHidden("goal_unit", goalUnit)); // 개별 저장용
	form.appendChild(createHidden("target_value", targetValue));
	form.appendChild(createHidden("start_date", startDate));
	form.appendChild(createHidden("end_date", endDate));
	form.appendChild(createHidden("target_type", targetType)); // 단건

	document.body.appendChild(form);
	form.submit();
}

// 다중 수정
function submitGoalMultiUpdate() {
	// ① 선택삭제 모드라면 → 다중 삭제 로직으로 분기
	const editBtn = document.getElementById("toggleEditModeBtn");
	if (editBtn.textContent.includes("삭제")) {
		submitSelectedDeletes();	// ↓ 새 함수
		return false;
	}
	const rows = document.querySelectorAll("tbody tr");
	const form = document.createElement("form");
	form.method = "post";
	form.action = ctp + "/rec/goalMultiUpdateExercise";
	form.setAttribute("data-dynamic-form", "true");

	let valid = true, count = 0;

	rows.forEach((row, index) => {
		if (!row.querySelector("input[name='goal_id']")) return;
		if (!validateFormOnSubmit(row)) {
			valid = false;
			return;
		}

		const goalId = row.querySelector("input[name='goal_id']").value;
		const exerciseId = row.querySelector("select[name='exercise_id']").value;
		const targetType = row.querySelector("select[name='target_type']").value;
		const targetValue = row.querySelector("input[name='target_value']").value;
		const goalUnit = row.querySelector("select[name='goal_unit']").value;
		const startDate = row.querySelector("input[name='start_date']").value;
		const endDate = row.querySelector("input[name='end_date']").value;
		const changed = row.querySelector("input[name='goalList[" + index + "].changed']");

		form.appendChild(createHidden("goalList[" + count + "].goal_id", goalId));
		form.appendChild(createHidden("goalList[" + count + "].exercise_id", exerciseId));
		form.appendChild(createHidden("goalList[" + count + "].target_type", targetType));
		form.appendChild(createHidden("goalList[" + count + "].target_value", targetValue));
		form.appendChild(createHidden("goalList[" + count + "].goal_unit", goalUnit));
		form.appendChild(createHidden("goalList[" + count + "].start_date", startDate));
		form.appendChild(createHidden("goalList[" + count + "].end_date", endDate));
		form.appendChild(createHidden("goalList[" + count + "].changed",
				changed ? "true" : (row.dataset.selected === "true" ? "true" : "false")));

		count++;
	});

	if (!valid || count === 0) {
		showWizardMessage("수정할 목표가 없어요! 행을 선택하거나 내용을 바꿔주세요.");
		return false;
	}

	document.body.appendChild(form);
	form.submit();
}

// 선택된 목표(테이블-success) 다중 삭제
function submitSelectedDeletes() {
	const selectedRows = document.querySelectorAll("tbody tr.table-success");
	if (selectedRows.length === 0) {
		showWizardMessage("삭제할 목표가 선택되지 않았어요!");
		return;
	}

	const confirmBox = document.querySelector("#wizard-delete-confirm");
	const yesBtn = document.getElementById("wizard-confirm-yes");
	const noBtn  = document.getElementById("wizard-confirm-no");
	confirmBox.classList.remove("d-none");

	yesBtn.onclick = () => {
		confirmBox.classList.add("d-none");

		const form = document.createElement("form");
		form.method = "post";
		form.action = ctp + "/rec/goalMultiDeleteExercise";
		form.setAttribute("data-delete-form", "true");

		let idx = 0;
		selectedRows.forEach(row => {
			const goalId = row.querySelector("input[name='goal_id']").value;
			form.appendChild(createHidden("goalList[" + idx + "].goal_id", goalId));
			idx++;
		});

		document.body.appendChild(form);
		form.submit();
	};

	noBtn.onclick = () => confirmBox.classList.add("d-none");
}

// 공통 hidden 생성 함수
function createHidden(name, value) {
	const input = document.createElement("input");
	input.type = "hidden";
	input.name = name;
	input.value = value;
	return input;
}

const unitOptions = {
    "1": [ { value: "01", label: "분" }, { value: "02", label: "시간" } ],
    "2": [ { value: "11", label: "kcal" }, { value: "12", label: "J" } ],
    "3": [ { value: "21", label: "회" }, { value: "22", label: "세트" } ]
};

function updateUnitSelect(selectElement, typeVal, currentVal) {
    selectElement.innerHTML = "<option value=''>단위 선택</option>";
    if (unitOptions[typeVal]) {
        unitOptions[typeVal].forEach(function (opt) {
            const option = document.createElement("option");
            option.value = opt.value;
            option.textContent = opt.label;
            if (opt.value === currentVal) option.selected = true;
            selectElement.appendChild(option);
        });
    }
}

</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
