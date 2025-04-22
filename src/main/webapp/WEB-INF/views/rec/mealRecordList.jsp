<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<script>
let isEditMode = false;
const ctp = "${ctp}";

function updateEditButtonLabel() {
	const rows = document.querySelectorAll("tbody tr");
	let hasChanged = false;
	let hasSelected = false;

	rows.forEach(row => {
		if (row.classList.contains("table-success")) hasSelected = true;
		if (row.querySelector("input[name*='.changed']")) hasChanged = true;
	});

	const editBtn = document.getElementById("toggleEditModeBtn");
	editBtn.textContent = hasChanged ? '✅적용하기' : (hasSelected ? '🗑️선택삭제' : '✅적용하기');
}

document.addEventListener('DOMContentLoaded', function () {
	const editBtn = document.getElementById('toggleEditModeBtn');
	const cancelBtn = document.getElementById('cancelEditModeBtn');
	const table = document.querySelector('table');

	const toggleSelectAllBtn = document.createElement("button");
	toggleSelectAllBtn.className = "btn btn-outline-dark me-1 d-none";
	toggleSelectAllBtn.id = "toggleSelectAllBtn";
	toggleSelectAllBtn.textContent = "✔️전체선택";
	editBtn.parentNode.insertBefore(toggleSelectAllBtn, editBtn);

	toggleSelectAllBtn.addEventListener("click", () => {
		const rows = document.querySelectorAll("tbody tr");
		const shouldDeselect = [...rows].some(row => row.classList.contains("table-success"));

		rows.forEach(row => {
			row.classList.toggle("table-success", !shouldDeselect);
			if (!shouldDeselect) row.setAttribute("data-selected", "true");
			else row.removeAttribute("data-selected");
		});
		toggleSelectAllBtn.textContent = shouldDeselect ? "✔️전체선택" : "❌선택해제";
		updateEditButtonLabel();
	});

	editBtn.addEventListener('click', function () {
		const rows = table.querySelectorAll('tbody tr');
		if (isEditMode && !submitAllEdits()) return;

		isEditMode = !isEditMode;
		editBtn.textContent = isEditMode ? '✅적용하기' : '✏️수정모드';
		cancelBtn.classList.toggle('d-none', !isEditMode);
		toggleSelectAllBtn.classList.toggle('d-none', !isEditMode);

		rows.forEach((row, index) => {
			const cells = row.querySelectorAll('td');
			const [noCell, foodCell, quantityCell, timeCell, dateCell, controlCell] = cells;

			if (isEditMode) {
				const quantity = quantityCell.textContent.trim();
				const foodName = foodCell.textContent.trim();
				const mealTime = timeCell.textContent.trim();
				const mealDate = dateCell.textContent.trim();
				const mealId = row.querySelector("input[name='meal_id']").value;

				const amount = quantity.replace(/[^0-9.]/g, "");
				const unit = quantity.replace(/[0-9.]/g, "");
				
				foodCell.innerHTML =
					"<select name='food_id' class='form-select form-select-sm'>" +
						"<option value='1'" + (foodName === "밥" ? " selected" : "") + ">밥</option>" +
						"<option value='2'" + (foodName === "닭가슴살" ? " selected" : "") + ">닭가슴살</option>" +
						"<option value='3'" + (foodName === "샐러드" ? " selected" : "") + ">샐러드</option>" +
						"<option value='4'" + (foodName === "라면" ? " selected" : "") + ">라면</option>" +
					"</select>";

				quantityCell.innerHTML = "<div class='input-group'>" +
					"<input type='number' class='form-control form-control-sm' id='amount" + index + "' value='" + amount + "' step='0.1' min='0.1' required />" +
					"<select class='form-select form-select-sm' id='unit" + index + "' required>" +
						"<option" + (unit === "g" ? " selected" : "") + ">g</option>" +
						"<option" + (unit === "ml" ? " selected" : "") + ">ml</option>" +
						"<option" + (unit === "개" ? " selected" : "") + ">개</option>" +
						"<option" + (unit === "컵" ? " selected" : "") + ">컵</option>" +
						"<option" + (unit === "공기" ? " selected" : "") + ">공기</option>" +
						"<option" + (unit === "조각" ? " selected" : "") + ">조각</option>" +
					"</select></div>";

				timeCell.innerHTML =
					"<select name='meal_time' class='form-select form-select-sm'>" +
						"<option value='1'" + (mealTime === "아침" ? " selected" : "") + ">아침</option>" +
						"<option value='2'" + (mealTime === "점심" ? " selected" : "") + ">점심</option>" +
						"<option value='3'" + (mealTime === "저녁" ? " selected" : "") + ">저녁</option>" +
						"<option value='4'" + (mealTime === "간식" ? " selected" : "") + ">간식</option>" +
					"</select>";

				dateCell.innerHTML = "<input type='date' name='meal_date' class='form-control form-control-sm' value='" + mealDate + "' required />";
				controlCell.innerHTML =
					"<input type='hidden' name='meal_id' value='" + mealId + "' />" +
					"<button class='btn btn-sm btn-outline-success text-nowrap' onclick='submitEdit(this)'>개별저장</button>";

				row.addEventListener("click", (e) => {
					if (e.target.tagName === "BUTTON" || e.target.closest("button")) return;
					row.classList.toggle("table-success");
					row.classList.contains("table-success") ? row.setAttribute("data-selected", "true") : row.removeAttribute("data-selected");
					updateEditButtonLabel();
				});

				const inputs = row.querySelectorAll("input, select");
				inputs.forEach(input => {
					input.addEventListener("change", () => {
						if (!row.querySelector("input[name='mealRecordList[" + index + "].changed']")) {
							const hidden = document.createElement("input");
							hidden.type = "hidden";
							hidden.name = "mealRecordList[" + index + "].changed";
							hidden.value = "true";
							row.appendChild(hidden);
						}
						updateEditButtonLabel();
					});
				});
			} else {
				location.reload();
			}
		});
	});

	cancelBtn.addEventListener('click', () => location.reload());
});

function submitEdit(button) {
	const row = button.closest("tr");
	if (!validateFormOnSubmit(row)) return;

	const form = document.createElement("form");
	form.method = "post";
	form.action = ctp + "/rec/mealRecordUpdate";
	form.setAttribute("data-dynamic-form", "true");

	const mealId = row.querySelector("input[name='meal_id']").value;
	const foodId = row.querySelector("select[name='food_id']").value;
	const amount = row.querySelector("input[id^='amount']").value.trim();
	const unit = row.querySelector("select[id^='unit']").value.trim();
	const mealTime = row.querySelector("select[name='meal_time']").value;
	const mealDate = row.querySelector("input[name='meal_date']").value.trim();
	const quantity = amount + unit;

	form.appendChild(createHidden("meal_id", mealId));
	form.appendChild(createHidden("food_id", foodId));
	form.appendChild(createHidden("quantity", quantity));
	form.appendChild(createHidden("meal_time", mealTime));
	form.appendChild(createHidden("meal_date", mealDate));

	document.body.appendChild(form);
	form.submit();
}

function submitAllEdits() {
	const editBtn = document.getElementById("toggleEditModeBtn");
	if (editBtn.textContent.includes("삭제")) {
		submitSelectedDeletes();
		return false;
	}

	const rows = document.querySelectorAll("tbody tr");
	const form = document.createElement("form");
	form.method = "post";
	form.action = ctp + "/rec/mealRecordMultiUpdate";
	form.setAttribute("data-dynamic-form", "true");

	let valid = true, count = 0;
	rows.forEach((row, i) => {
		if (!row.querySelector("input[name='meal_id']")) return;
		if (!validateFormOnSubmit(row)) {
			valid = false;
			return;
		}

		const mealId = row.querySelector("input[name='meal_id']").value;
		const foodId = row.querySelector("select[name='food_id']").value;
		const amount = row.querySelector("input[id^='amount']").value.trim();
		const unit = row.querySelector("select[id^='unit']").value.trim();
		const quantity = amount + unit;
		const mealTime = row.querySelector("select[name='meal_time']").value;
		const mealDate = row.querySelector("input[name='meal_date']").value.trim();
		const changed = row.querySelector("input[name='mealRecordList[" + i + "].changed']");

		form.appendChild(createHidden("mealRecordList[" + count + "].meal_id", mealId));
		form.appendChild(createHidden("mealRecordList[" + count + "].food_id", foodId));
		form.appendChild(createHidden("mealRecordList[" + count + "].quantity", quantity));
		form.appendChild(createHidden("mealRecordList[" + count + "].meal_time", mealTime));
		form.appendChild(createHidden("mealRecordList[" + count + "].meal_date", mealDate));
		form.appendChild(createHidden("mealRecordList[" + count + "].changed", changed ? "true" : "false"));

		count++;
	});

	if (!valid || count === 0) return false;
	document.body.appendChild(form);
	form.submit();
}

function createHidden(name, value) {
	const input = document.createElement("input");
	input.type = "hidden";
	input.name = name;
	input.value = value;
	return input;
}

function submitSelectedDeletes() {
	const selectedRows = document.querySelectorAll("tbody tr.table-success");
	if (selectedRows.length === 0) {
		showWizardMessage("삭제할 식단 기록이 선택되지 않았어요!");
		return;
	}

	const confirmBox = document.querySelector("#wizard-delete-confirm");
	const yesBtn = document.getElementById("wizard-confirm-yes");
	const noBtn = document.getElementById("wizard-confirm-no");
	confirmBox.classList.remove("d-none");

	yesBtn.onclick = () => {
		confirmBox.classList.add("d-none");
		const form = document.createElement("form");
		form.method = "post";
		form.action = ctp + "/rec/mealRecordMultiDelete";
		form.setAttribute("data-delete-form", "true");

		let count = 0;
		selectedRows.forEach(row => {
			const mealId = row.querySelector("input[name='meal_id']").value;
			form.appendChild(createHidden("recordIdList[" + count + "]", mealId));
			count++;
		});

		document.body.appendChild(form);
		form.submit();
	};

	noBtn.onclick = () => confirmBox.classList.add("d-none");
}

//단일 삭제 확인 및 처리
function confirmSingleDelete(mealId) {
	const confirmBox = document.querySelector("#wizard-delete-confirm");
	const yesBtn = document.getElementById("wizard-confirm-yes");
	const noBtn = document.getElementById("wizard-confirm-no");
	confirmBox.classList.remove("d-none");

	yesBtn.onclick = () => {
		confirmBox.classList.add("d-none");
		location.href = ctp + "/rec/mealRecordDelete?record_id=" + mealId;
	};

	noBtn.onclick = () => {
		confirmBox.classList.add("d-none");
	};
}

</script>

<main class="container mt-4 mb-5" data-page="mealRecordList">
	<div class="row">
		<div class="mb-4 col">
			<h2>🍽 식단 기록 목록</h2>
			<p class="text-muted">기록한 식단 내역을 확인하세요.</p>
		</div>
		<div class="col-auto text-center" style="max-width: 180px;">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>

	<c:if test="${empty mealRecordList}">
		<div class="alert alert-info text-center">아직 등록된 식단 기록이 없습니다.</div>
	</c:if>

	<div class="text-end mb-2">
		<a href="${ctp}/rec/mealRecordInput" class="btn btn-outline-primary">+식단기록추가</a>
		<button class="btn btn-outline-warning" id="toggleEditModeBtn">✏️수정모드</button>
		<button class="btn btn-outline-secondary d-none" id="cancelEditModeBtn">❌수정취소</button>
	</div>

	<c:if test="${not empty mealRecordList}">
		<div class="p-4 rounded-4 shadow-sm bg-info-subtle" style="overflow-x: auto;">
			<table class="table text-center align-middle rounded-3 overflow-hidden mb-0" style="min-width: 600px;">
				<thead>
					<tr>
						<th class="bg-info-subtle">no.</th>
						<th class="bg-info-subtle">음식명</th>
						<th class="bg-info-subtle">섭취량</th>
						<th class="bg-info-subtle">시간대</th>
						<th class="bg-info-subtle">식사 날짜</th>
						<th class="bg-info-subtle">관리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${mealRecordList}" varStatus="st">
						<tr>
							<td>${st.count}</td>
							<td><input type="hidden" name="meal_id" value="${vo.meal_id}" /> ${vo.food_name}</td>
							<td>${vo.quantity}</td>
							<td>
								<c:choose>
									<c:when test="${vo.meal_time == 1}">아침</c:when>
									<c:when test="${vo.meal_time == 2}">점심</c:when>
									<c:when test="${vo.meal_time == 3}">저녁</c:when>
									<c:otherwise>간식</c:otherwise>
								</c:choose>
							</td>
							<td><fmt:formatDate value="${vo.meal_date}" pattern="yyyy-MM-dd" /></td>
							<td>
								<input type="hidden" name="record_id" value="${vo.meal_id}" />
								<a href="${ctp}/rec/mealRecordEdit?record_id=${vo.meal_id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
								<a href="javascript:void(0);" class="btn btn-sm btn-outline-danger" onclick="confirmSingleDelete(${vo.meal_id});">삭제</a>
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

<jsp:include page="/WEB-INF/views/include/footer.jsp" />