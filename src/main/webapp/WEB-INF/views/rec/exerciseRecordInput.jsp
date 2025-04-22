<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>


<main class="container mt-4 mb-5" data-page="exerciseRecordInput">
	<!-- 페이지 제목 -->
	<div class="mb-4">
		<h2>🏃 운동 기록 입력</h2>
		<p class="text-muted">오늘 수행한 운동 내용을 기록해보세요.</p>
	</div>

	<div class="text-end mt-4">
		<p class="text-muted">💡 여러 운동을 한 번에 입력하고 싶다면?</p>
		<a href="${ctp}/rec/exerciseRecordMultiInput" class="btn btn-outline-secondary btn-sm">➡ 다중 입력 페이지로 이동</a>
	</div>
	
	<div class="row">
		<!-- 입력 폼 -->
		<div class="col-md-6">
			<form method="post" class="needs-validation" novalidate>
				<input type="hidden" name="user_id" value="${sessionScope.loginUser.user_id}" />

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

				<div class="mb-3">
					<label for="calories_burned" class="form-label">운동 시간 (분)</label> <input type="number" name="duration_minutes" id="duration_minutes" class="form-control" min="1" step="1" required />
				</div>

				<div class="mb-3">
					<label for="calories_burned" class="form-label">소모 칼로리 (kcal)</label> <input type="number" name="calories_burned" id="calories_burned" class="form-control" min="0" step="1" required />
				</div>

				<div class="mb-3">
					<label for="activity_date" class="form-label">운동 날짜</label> <input type="date" name="activity_date" id="activity_date" class="form-control" value="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>" required />
				</div>

				<div class="mb-4">
					<label for="source_platform" class="form-label">연동 플랫폼 (선택)</label> <input type="text" name="source_platform" id="source_platform" class="form-control" placeholder="예: Google Fit, Samsung Health" />
				</div>

				<div class="d-grid gap-2">
					<button type="submit" class="btn btn-primary btn-lg">✅ 기록 저장</button>
				</div>
			</form>
			<div class="mt-4 mb-4 text-center">
				<a href="${ctp}/user/main" class="btn btn-outline-primary">🏠 메인으로 돌아가기</a>
				<a href="${ctp}/rec/exerciseRecordList" class="btn btn-outline-secondary">← 운동 기록 목록으로</a>
			</div>
		</div>

		<!-- 도우미 마법사 -->
		<div class="col-md-6 text-center">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
		


	</div>


</main>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
