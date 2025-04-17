<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />

<main class="container mt-4 mb-5">
	<!-- 페이지 제목 및 인사 -->
	<div class="mb-4">
		<h2>🎉 환영합니다, ${sessionScope.user.nickname}님!</h2>
		<p class="text-muted">오늘도 건강한 루틴을 시작해볼까요?</p>
	</div>

	<!-- 오늘의 추천 루틴 -->
	<section class="row mb-5">
		<div class="col-md-6 mb-3">
			<div class="card border-primary shadow-sm h-100">
				<div class="card-body d-flex flex-column">
					<h5 class="card-title text-primary">🏃 오늘의 운동 추천</h5>
					<p class="card-text">15분 스트레칭, 30분 걷기</p>
				</div>
			</div>
		</div>
		<div class="col-md-6 mb-3">
			<div class="card border-success shadow-sm h-100">
				<div class="card-body d-flex flex-column">
					<h5 class="card-title text-success">🍱 오늘의 식단 추천</h5>
					<p class="card-text">단백질 위주의 균형 식단: 삶은 계란, 두부, 브로콜리</p>
				</div>
			</div>
		</div>
	</section>


	<!-- 목표 달성률 -->
	<section class="mb-5">
		<h5>🎯 목표 달성 현황</h5>
		<div class="progress" style="height: 24px;">
			<div class="progress-bar bg-info" role="progressbar" style="width: 68%;" aria-valuenow="68" aria-valuemin="0" aria-valuemax="100">68% 완료</div>
		</div>
	</section>

	<!-- 주요 기능 빠른 이동 -->
	<section class="row text-center mt-4">
		<div class="col-md-4 mb-3">
			<a href="${ctp}/rec/exerciseRecordInput" class="btn btn-outline-primary w-100 py-3">운동 기록 입력</a>
		</div>
		<div class="col-md-4 mb-3">
			<a href="${ctp}/rec/mealRecordInput" class="btn btn-outline-info w-100 py-3">식단 기록 입력</a>
		</div>
		<div class="col-md-4 mb-3">
			<a href="${ctp}/rec/report" class="btn btn-outline-success w-100 py-3">리포트 보기</a>
		</div>
		<div class="col-md-4 mb-3">
			<a href="${ctp}/expert/feedbackRequest" class="btn btn-outline-warning w-100 py-3">피드백 요청</a>
		</div>
		<div class="col-md-4 mb-3">
			<a href="${ctp}/rec/goalSetting" class="btn btn-outline-secondary w-100 py-3">목표 설정</a>
		</div>
		<div class="col-md-4 mb-3">
			<a href="${ctp}/user/notifications" class="btn btn-outline-dark w-100 py-3">알림 확인</a>
		</div>
	</section>

</main>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
