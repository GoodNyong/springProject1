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

//적용/삭제 버튼 라벨 업데이트 함수
function updateEditButtonLabel() {
	const rows = document.querySelectorAll("tbody tr");
	let hasChanged = false;
	let hasSelected = false;

	rows.forEach(row => {
		if (row.classList.contains("table-success")) hasSelected = true;
		if (row.querySelector("input[name*='.changed']")) hasChanged = true;
	});

	const editBtn = document.getElementById("toggleEditModeBtn");
	if (hasChanged) {
		editBtn.textContent = '✅적용하기';
	} else if (hasSelected) {
		editBtn.textContent = '🗑️선택삭제';
	} else {
		editBtn.textContent = '✅적용하기';
	}
}

// 수정 모드
document.addEventListener('DOMContentLoaded', function () {
	const editBtn = document.getElementById('toggleEditModeBtn');
	const cancelBtn = document.getElementById('cancelEditModeBtn');
	const table = document.querySelector('table');
	let isAllSelected = false; // 상태 추적 변수(선택 버튼)

	if (!editBtn || !cancelBtn || !table) return;
	
	
	// 전체 선택/해제 버튼 생성
	const toggleSelectAllBtn = document.createElement("button");
	toggleSelectAllBtn.className = "btn btn-outline-dark me-1 d-none";
	toggleSelectAllBtn.id = "toggleSelectAllBtn";
	toggleSelectAllBtn.textContent = "✔️전체선택";
	editBtn.parentNode.insertBefore(toggleSelectAllBtn, editBtn);

	// 전체 선택 토글 동작
	toggleSelectAllBtn.addEventListener("click", () => {
		const rows = document.querySelectorAll("tbody tr");
		const shouldDeselect = [...rows].some(row => row.classList.contains("table-success"));

		// const selectedRows = Array.from(rows).filter(row => row.getAttribute("data-selected") === "true");
		// 이미 일부 이상 선택되어 있으면 → 전체 선택 해제
		// const shouldDeselect = selectedRows.length > 0;


		rows.forEach(row => {
			if (shouldDeselect) {
				row.classList.remove("table-success");
				row.removeAttribute("data-selected");
			} else {
				row.classList.add("table-success");
				row.setAttribute("data-selected", "true");
			}
		});

		isAllSelected = !shouldDeselect;
		toggleSelectAllBtn.textContent = shouldDeselect ? "✔️전체선택" : "❌선택해제"; // 버튼 텍스트 업데이트
		updateEditButtonLabel(); // 버튼 라벨 변경
	});

	// 수정 모드 진입
	editBtn.addEventListener('click', function () {
		const rows = table.querySelectorAll('tbody tr');
		
		// 적용 하기
		if (isEditMode) {
			const success = submitAllEdits();
			if (!success) return; // 유효성 실패 -> 모드 전환 중단
		}
		
		isEditMode = !isEditMode;
		editBtn.textContent = isEditMode ? '✅적용하기' : '✏️수정모드';
		cancelBtn.classList.toggle('d-none', !isEditMode);
		toggleSelectAllBtn.classList.toggle('d-none', !isEditMode);

		rows.forEach((row, index) => {
			const cells = row.querySelectorAll('td');
			const [noCell, exerciseCell, durationCell, calorieCell, dateCell, platformCell, controlCell] = cells;

			if (isEditMode) {
				const duration = durationCell.textContent.trim();
				const calorie = calorieCell.textContent.trim();
				const date = dateCell.textContent.trim();
				const platform = platformCell.textContent.trim();
				const recordId = row.querySelector("input[name='record_id']").value; // 기존 record_id 값 추출

				durationCell.innerHTML = "<input type='number' name='duration' class='form-control form-control-sm' value='" + duration + "' min='1' required />";
				calorieCell.innerHTML = "<input type='number' name='calories' class='form-control form-control-sm' value='" + calorie + "' min='0' required />";
				dateCell.innerHTML = "<input type='date' name='activity_date' class='form-control form-control-sm' value='" + date + "' required />";
				platformCell.innerHTML = "<input type='text' name='platform' class='form-control form-control-sm' value='" + platform + "' />";
				controlCell.innerHTML = "<input type='hidden' name='record_id' value='" + recordId + "' />" +
										"<button class='btn btn-sm btn-outline-success' onclick='submitEdit(this)'>개별저장</button>";
					
				// 기존 changed hidden 제거 (중복 방지)
				const prevChanged = row.querySelector("input[name='exerciseRecordList[" + index + "].changed']");
				if (prevChanged) prevChanged.remove();
				
				// 변경 감지
				const inputs = row.querySelectorAll("input[type='number'], input[type='text'], input[type='date']");
				inputs.forEach(input => {
					input.addEventListener('change', () => {
						let changed = row.querySelector("input[name='exerciseRecordList[" + index + "].changed']");
						if (!changed) {
							changed = document.createElement("input");
							changed.type = "hidden";
							changed.name = "exerciseRecordList[" + index + "].changed";
							changed.value = "true";
							row.appendChild(changed);
						}
						updateEditButtonLabel(); // 변경 발생 시 라벨 업데이트
					});
				});
				
				// 개별 행 선택/해제 (클릭 시)
				row.addEventListener("click", (e) => {
					if (e.target.tagName === "BUTTON" || e.target.tagName === "A" || e.target.closest("button")) return;

					row.classList.toggle("table-success");
					if (row.classList.contains("table-success")) {
						row.setAttribute("data-selected", "true");
					} else {
						row.removeAttribute("data-selected");
					}

					// 1개 이상 선택되었는지 확인하여 버튼 상태 업데이트
					const selectedCount = table.querySelectorAll("tbody tr.table-success").length;
					const totalCount = table.querySelectorAll("tbody tr").length;

					if (selectedCount === totalCount) {
						isAllSelected = true;
						toggleSelectAllBtn.textContent = "❌선택해제";
					} else if (selectedCount > 0) {
						isAllSelected = false;
						toggleSelectAllBtn.textContent = "❌선택해제";
					} else {
						isAllSelected = false;
						toggleSelectAllBtn.textContent = "✔️전체선택";
					}
					updateEditButtonLabel(); // 선택 변경 시 라벨 업데이트
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

// 수정 버튼 (개별)
function submitEdit(button) {
	const row = button.closest("tr");

	// 기존 validateFormOnSubmit을 수정한 버전으로 사용
	if (!validateFormOnSubmit(row)) return;
	
	// 기존 form 제거 (다중 submit 방지)
	const existingForm = document.querySelector("form[data-dynamic-form='true']");
	if (existingForm) existingForm.remove();

	// 폼 생성 및 제출 로직 동일
	const recordId = row.querySelector("input[name='record_id']").value;
	const duration = row.querySelector("input[name='duration']").value.trim();
	const calories = row.querySelector("input[name='calories']").value.trim();
	const activityDate = row.querySelector("input[name='activity_date']").value.trim();
	const platform = row.querySelector("input[name='platform']").value.trim();

	const form = document.createElement("form");
	form.method = "post";
	form.action = ctp + "/rec/exerciseRecordUpdate";
	form.setAttribute("data-dynamic-form", "true"); // 중복 탐지용 구분자

	const fields = {
		record_id: recordId,
		duration_minutes: duration,
		calories_burned: calories,
		activity_date: activityDate,
		source_platform: platform
	};

	for (const key in fields) {
		form.appendChild(createHidden(key, fields[key]));
	}
	//for (const key in fields) {
	//	const input = document.createElement("input");
	//	input.type = "hidden";
	//	input.name = key;
	//	input.value = fields[key];
	//	form.appendChild(input);
	//}

	document.body.appendChild(form);
	form.submit();
}

// 다중 수정(적용하기) 버튼 or 삭제 처리
function submitAllEdits() {
	// 삭제처리 함수 호출
	const editBtn = document.getElementById("toggleEditModeBtn");
	if (editBtn.textContent.includes("삭제")) {
		submitSelectedDeletes(); // 선택 삭제 호출
		return false;
	}
	const rows = document.querySelectorAll("tbody tr");
	
	// 폼에 제출 전 기존 form 제거
	const existingForm = document.querySelector("form[data-dynamic-form='true']");
	if (existingForm) existingForm.remove();
	
	const form = document.createElement("form");
	form.method = "post";
	form.action = ctp + "/rec/exerciseRecordMultiUpdate"; // 삭제용 URL로 조건부 변경 가능
	form.setAttribute("data-dynamic-form", "true"); // 구분자 추가

	let valid = true;
	let count = 0;

	rows.forEach((row, index) => {
		// 수정 모드에서만 유효성 검사 수행
		if (!row.querySelector("input[name='record_id']")) return;
		
		// 해당 행의 유효성 검증
		if (!validateFormOnSubmit(row)) {
			valid = false;
			return;
		}

		// 필드 값 수집
		const recordId = row.querySelector("input[name='record_id']").value;
		const duration = row.querySelector("input[name='duration']").value.trim();
		const calories = row.querySelector("input[name='calories']").value.trim();
		const activityDate = row.querySelector("input[name='activity_date']").value.trim();
		const platform = row.querySelector("input[name='platform']").value.trim();
		const changed = row.querySelector("input[name='exerciseRecordList[" + index + "].changed']");

		// 폼에 각 값을 hidden input으로 추가
		form.appendChild(createHidden("exerciseRecordList[" + count + "].record_id", recordId));
		form.appendChild(createHidden("exerciseRecordList[" + count + "].duration_minutes", duration));
		form.appendChild(createHidden("exerciseRecordList[" + count + "].calories_burned", calories));
		form.appendChild(createHidden("exerciseRecordList[" + count + "].activity_date", activityDate));
		form.appendChild(createHidden("exerciseRecordList[" + count + "].source_platform", platform));
		form.appendChild(createHidden("exerciseRecordList[" + count + "].changed", changed ? "true" : "false"));
		
		count++;
	});

	if (!valid || count === 0) {
		return false;
	}

	document.body.appendChild(form);
	form.submit();
}

// 적용하기 버튼에서 이용하는 함수(input생성-id값 획득을 위해)
function createHidden(name, value) {
	const input = document.createElement("input");
	input.type = "hidden";
	input.name = name;
	input.value = value;
	return input;
}

// 선택 삭제 기능: 선택된 행의 record_id만 전송
function submitSelectedDeletes() {
	const selectedRows = document.querySelectorAll("tbody tr.table-success");
	if (selectedRows.length === 0) {
		alert("삭제할 항목을 먼저 선택해주세요!");
		return;
	}

	if (!confirm("선택된 마법 기록들을 정말 삭제하시겠어요?")) return;

	// 기존 삭제 form 제거
	const existingForm = document.querySelector("form[data-delete-form='true']");
	if (existingForm) existingForm.remove();

	// 삭제용 form 생성
	const form = document.createElement("form");
	form.method = "post";
	form.action = ctp + "/rec/exerciseRecordMultiDelete"; // 🛠️ 삭제용 요청 URL
	form.setAttribute("data-delete-form", "true");

	let count = 0;
	selectedRows.forEach(row => {
		const recordId = row.querySelector("input[name='record_id']").value;
		form.appendChild(createHidden("recordIdList[" + count + "]", recordId));
		count++;
	});

	document.body.appendChild(form);
	form.submit();
}

</script>

<main class="container mt-4 mb-5"  data-page="exerciseexerciseRecordList">
	<!-- 페이지 제목 -->
	<div class="row">
		<div class="mb-4 col">
			<h2>🏃 운동 기록 목록</h2>
			<p class="text-muted">기록한 운동 내역을 확인하세요.</p>
			<!-- 🧙 마법사 캐릭터 -->
		</div>
		<div class="col-auto text-center" style="max-width: 180px;">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>

	<!-- 기록이 없는 경우 -->
	<c:if test="${empty exerciseRecordList}">
		<div class="alert alert-info text-center">아직 등록된 운동 기록이 없습니다.</div>
	</c:if>

	<!-- 버튼 그룹 (줄바꿈 방지) -->
	<div class="text-end  mb-2">
		<a href="${ctp}/rec/exerciseRecordInput" class="btn btn-outline-primary">+운동기록추가</a>
		<button class="btn btn-outline-warning" id="toggleEditModeBtn">✏️수정모드</button>
		<button class="btn btn-outline-secondary d-none" id="cancelEditModeBtn">❌수정취소</button>
	</div>


	<!-- 기록 목록 테이블 -->
	<c:if test="${not empty exerciseRecordList}">
		<div class="p-4 rounded-4 shadow-sm bg-info-subtle" style="overflow-x: auto;">
			<table class="table text-center align-middle rounded-3 overflow-hidden mb-0" style="min-width: 600px;">
				<thead>
					<tr>
						<th class="bg-info-subtle" style="white-space: nowrap; min-width: 100px;">no.</th>
						<th class="bg-info-subtle" style="white-space: nowrap; min-width: 100px;">운동 종류</th>
						<th class="bg-info-subtle" style="white-space: nowrap; min-width: 120px;">운동 시간 (분)</th>
						<th class="bg-info-subtle" style="white-space: nowrap; min-width: 120px;">소모 칼로리</th>
						<th class="bg-info-subtle" style="white-space: nowrap; min-width: 130px;">운동 날짜</th>
						<th class="bg-info-subtle" style="white-space: nowrap; min-width: 130px;">연동 플랫폼</th>
						<th class="bg-info-subtle" style="white-space: nowrap; min-width: 130px;">관리</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="vo" items="${exerciseRecordList}" varStatus="st">
						<tr>
							<td>${st.count}</td>
							<td>${vo.exercise_name}</td>
							<td>${vo.duration_minutes}</td>
							<td>${vo.calories_burned}</td>
							<td><fmt:formatDate value="${vo.activity_date}" pattern="yyyy-MM-dd" /></td>
							<td>${vo.source_platform}</td>
							<td>
								<input type="hidden" name="record_id" value="${vo.record_id}" />
								<a href="${ctp}/rec/exerciseRecordEdit?record_id=${vo.record_id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
								<a href="${ctp}/rec/exerciseRecordDelete?record_id=${vo.record_id}" class="btn btn-sm btn-outline-danger"
								   onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
							</td>
							
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</c:if>


</main>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
