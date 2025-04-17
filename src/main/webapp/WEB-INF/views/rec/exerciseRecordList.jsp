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

document.addEventListener('DOMContentLoaded', function () {
	const editBtn = document.getElementById('toggleEditModeBtn');
	const cancelBtn = document.getElementById('cancelEditModeBtn');
	const table = document.querySelector('table');

	if (!editBtn || !cancelBtn || !table) return;

	editBtn.addEventListener('click', function () {
		isEditMode = !isEditMode;
		editBtn.textContent = isEditMode ? '✅ 적용하기' : '✏️ 수정 모드';
		cancelBtn.classList.toggle('d-none', !isEditMode);

		const rows = table.querySelectorAll('tbody tr');

		rows.forEach(row => {
			const cells = row.querySelectorAll('td');
			const [noCell, exerciseCell, durationCell, calorieCell, dateCell, platformCell, controlCell] = cells;

			if (isEditMode) {
				const duration = durationCell.textContent.trim();
				const calorie = calorieCell.textContent.trim();
				const date = dateCell.textContent.trim();
				const platform = platformCell.textContent.trim();

				durationCell.innerHTML = "<input type='number' name='duration' class='form-control form-control-sm' value='" + duration + "' min='1' required />";
				calorieCell.innerHTML = "<input type='number' name='calories' class='form-control form-control-sm' value='" + calorie + "' min='0' required />";
				dateCell.innerHTML = "<input type='date' name='activity_date' class='form-control form-control-sm' value='" + date + "' required />";
				platformCell.innerHTML = "<input type='text' name='platform' class='form-control form-control-sm' value='" + platform + "' />";
				controlCell.innerHTML = "<button class='btn btn-sm btn-outline-success' onclick='submitEdit(this)'>개별 저장</button>";
			} else {
				location.reload(); // 원래 상태로 복귀
			}
		});
	});

	cancelBtn.addEventListener('click', function () {
		location.reload();
	});
});

function submitEdit(button) {
	const row = button.closest("tr");

	// 기존 validateFormOnSubmit을 수정한 버전으로 사용
	const isValid = validateFormOnSubmit(row);
	if (!isValid) return;

	// 폼 생성 및 제출 로직 동일
	const recordId = row.querySelector("input[name='record_id']").value;
	const duration = row.querySelector("input[name='duration']").value.trim();
	const calories = row.querySelector("input[name='calories']").value.trim();
	const activityDate = row.querySelector("input[name='activity_date']").value.trim();
	const platform = row.querySelector("input[name='platform']").value.trim();

	const form = document.createElement("form");
	form.method = "post";
	form.action = ctp + "/rec/exerciseRecordUpdate";

	const fields = {
		record_id: recordId,
		duration_minutes: duration,
		calories_burned: calories,
		activity_date: activityDate,
		source_platform: platform
	};

	for (const key in fields) {
		const input = document.createElement("input");
		input.type = "hidden";
		input.name = key;
		input.value = fields[key];
		form.appendChild(input);
	}

	document.body.appendChild(form);
	form.submit();
}


</script>



<main class="container mt-4 mb-5"  data-page="exerciseRecordList">
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
	<c:if test="${empty recordList}">
		<div class="alert alert-info text-center">아직 등록된 운동 기록이 없습니다.</div>
	</c:if>

	<!-- 버튼 그룹 (줄바꿈 방지) -->
	<div class="text-end  mb-2">
		<a href="${ctp}/rec/exerciseRecordInput" class="btn btn-outline-primary">+ 운동 기록 추가</a>
		<button class="btn btn-outline-warning" id="toggleEditModeBtn">✏️ 수정 모드</button>
		<button class="btn btn-outline-secondary d-none" id="cancelEditModeBtn">❌ 수정 취소</button>
	</div>


	<!-- 기록 목록 테이블 -->
	<c:if test="${not empty recordList}">
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
					<c:forEach var="vo" items="${recordList}" varStatus="st">
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
