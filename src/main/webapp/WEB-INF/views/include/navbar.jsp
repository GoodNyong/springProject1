<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>

<nav class="navbar navbar-expand-lg bg-white border-bottom px-4 py-3">
	<div class="container-fluid d-flex justify-content-between align-items-center">

		<!-- 좌측 로고 -->
		<a class="navbar-brand fw-bold text-primary" href="${pageContext.request.contextPath}/">Blinkos</a>

		<!-- 우측: 햄버거 토글 + 로그인/회원가입 or 로그아웃 -->
		<div class="d-flex align-items-center">

			<!-- 🔻 모바일 햄버거 토글 버튼 -->
			<%-- <c:if test="${not empty sessionScope.user}"> --%>
			<button class="navbar-toggler me-2" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu" aria-controls="navbarMenu" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<%-- </c:if> --%>

			<!-- 로그인/로그아웃 메뉴 -->
			<c:choose>
				<c:when test="${not empty sessionScope.user}">
					<span class="navbar-text me-3"> 👋 ${sessionScope.user.nickname}님 </span>
					<a class="btn btn-outline-secondary btn-sm me-2" href="${pageContext.request.contextPath}/user/mypage">마이페이지</a>
					<a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/user/logout">로그아웃</a>
				</c:when>
				<c:otherwise>
					<a class="btn btn-outline-primary me-2" href="${pageContext.request.contextPath}/user/login">로그인</a>
					<a class="btn btn-primary" href="${pageContext.request.contextPath}/user/signup">회원가입</a>
				</c:otherwise>
			</c:choose>
		</div>

		<!-- 접힘 메뉴 (리포트, 콘텐츠, 관리자 등) -->
		<div class="collapse navbar-collapse mt-3 mt-lg-0" id="navbarMenu">
			<ul class="navbar-nav me-auto mb-2 mb-lg-0">
				<%-- <c:if test="${not empty sessionScope.user}"> --%>
				<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/rec/report">리포트</a></li>
				<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/content/list">콘텐츠</a></li>

				<!-- 🔽 새 드롭다운: 기록 관리 -->
				<li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="#" id="recordDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false"> 기록 관리 </a>
					<ul class="dropdown-menu" aria-labelledby="recordDropdown">
						<li><a class="dropdown-item" href="${ctp}/rec/exerciseList">운동 기록</a></li>
						<li><a class="dropdown-item" href="${ctp}/rec/mealList">식단 기록</a></li>
						<li><a class="dropdown-item" href="${ctp}/rec/goalList">목표 목록</a></li>
					</ul></li>

				<!-- 🔹 피드백 요청 현황 (단일 항목 또는 전문가 메뉴와 연계) -->
				<li class="nav-item"><a class="nav-link" href="${ctp}/expert/feedbackList">피드백 현황</a></li>
				<%-- <c:if test="${sessionScope.user.role eq 'expert'}"> --%>
				<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/expert/feedbackList">피드백</a></li>
				<%-- </c:if> --%>
				<%-- <c:if test="${sessionScope.user.role eq 'admin'}"> --%>
				<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">관리자</a></li>
				<%-- </c:if> --%>
				<%-- <c:if test="${sessionScope.user.role eq 'advertiser'}"> --%>
				<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/ad/dashboard">광고</a></li>
				<%-- </c:if> --%>
				<%-- </c:if> --%>
			</ul>
		</div>

	</div>
</nav>
