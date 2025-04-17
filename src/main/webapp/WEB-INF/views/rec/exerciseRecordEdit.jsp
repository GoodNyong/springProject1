<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="exercise">
	<!-- 페이지 제목 -->
	<div class="mb-4">
		<h2>✏️ 운동 기록 수정</h2>
		<p class="text-muted">기존 운동 기록을 마법처럼 편집해보세요.</p>
	</div>

	<div class="row">
		<!-- 수정 폼 -->
		<div class="col-md-6">
			<form method="post" action="${ctp}/rec/exerciseRecordEdit" class="needs-validation" novalidate>
				<input type="hidden" name="record_id" value="${record.record_id}" /> <input type="hidden" name="user_id" value="${sessionScope.loginUser.user_id}" />

				<div class="mb-3">
					<label class="form-label">운동 종류</label>
					<input type="text" class="form-control" value="${record.exercise_name}" readonly />
				</div>

				<div class="mb-3">
					<label class="form-label">운동 시간 (분)</label>
					<input type="number" name="duration_minutes" class="form-control" min="1" step="1" value="${record.duration_minutes}" required />
				</div>

				<div class="mb-3">
					<label class="form-label">소모 칼로리 (kcal)</label>
					<input type="number" name="calories_burned" class="form-control" min="0" step="1" value="${record.calories_burned}" required />
				</div>

				<div class="mb-3">
					<label class="form-label">운동 날짜</label>
					<fmt:formatDate var="dateStr" value="${record.activity_date}" pattern="yyyy-MM-dd" />
					<input type="date" name="activity_date" class="form-control" value="${dateStr}" required />
				</div>

				<div class="mb-4">
					<label class="form-label">연동 플랫폼 (선택)</label>
					<input type="text" name="source_platform" class="form-control" value="${record.source_platform}" placeholder="예: Google Fit, Samsung Health" />
				</div>

				<div class="d-grid gap-2">
					<button type="submit" class="btn btn-warning btn-lg">✅ 수정 저장</button>
				</div>
			</form>
		</div>

		<!-- 도우미 마법사 -->
		<div class="col-md-6 text-center">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>
</main>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
