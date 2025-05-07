<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
  'use strict';
  
  function deleteCheck() {
    let ans = confirm("정말 탈퇴(비활성화)하시겠습니까?");
    if(ans) {
      ans = confirm("탈퇴(비활성화) 후 30일간 같은 아이디로 재가입하실 수 없습니다.\n\n계속 진행할까요?");
      if(ans) location.href = "${ctp}/user/passwordCheck/d";
    }
  }
</script>
<nav class="navbar navbar-expand-lg bg-white border-bottom px-4 py-3">
	<div class="container-fluid d-flex justify-content-between align-items-center">

		<!-- 로고 -->
		<a class="navbar-brand d-flex align-items-center fw-bold text-primary" href="${ctp}/">
			<img alt="Blinkos" src="${ctp}/resources/img/favicon.png" class="m-0 p-0">
			<span class="m-0 p-0">Blinkos</span>
		</a>

		<!-- 로그인/로그아웃 버튼(모바일) + 햄버거 버튼-->
		<div class="d-flex d-lg-none align-items-center gap-2">
			<c:choose>
				<c:when test="${not empty sessionScope.sUser}">
					<span class="navbar-text me-3"> 👋 ${sessionScope.sUser.username}님 </span>
					<a class="btn btn-outline-secondary btn-sm me-2" href="${pageContext.request.contextPath}/user/userPage">마이페이지</a>
					<a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/user/userLogout">로그아웃</a>
				</c:when>
				<c:otherwise>
					<a class="btn btn-outline-primary me-2" href="${pageContext.request.contextPath}/user/userLogin">로그인</a>
					<a class="btn btn-primary" href="${pageContext.request.contextPath}/user/userJoin">회원가입</a>
				</c:otherwise>
			</c:choose>

			<!-- 햄버거 버튼 -->
			<button class="navbar-toggler pt-0 pb-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu" aria-controls="navbarMenu" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
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
						<li><a class="dropdown-item" href="${ctp}/rec/exerciseRecordList">운동 기록</a></li>
						<li><a class="dropdown-item" href="${ctp}/rec/mealRecordList">식단 기록</a></li>
						<li><a class="dropdown-item" href="${ctp}/rec/goalList">목표 목록</a></li>
					</ul>
                </li>
                
                <!-- 🔽 새 드롭다운: 마이페이지 -->
                <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="#" id="myPageDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false"> 마이페이지 </a>
                  <ul class="dropdown-menu" aria-labelledby="myPageDropdown">
                    <li><a class="dropdown-item" href="${ctp}/user/userPage">내 정보 관리</a></li>
                    <li><a class="dropdown-item" href="${ctp}/user/passwordCheck/u">회원정보 수정</a></li>
                    <li><a class="dropdown-item" href="${ctp}/user/passwordCheck/p">비밀번호 변경</a></li>
                    <li><a class="dropdown-item" href="javascript:deleteCheck()">회원탈퇴</a></li>
                  </ul>
                </li>        
                
                <!-- 🔽 새 드롭다운: 게시판(커뮤니티) -->
                <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="#" id="boardDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false"> 커뮤니티 </a>
                  <ul class="dropdown-menu" aria-labelledby="boardDropdown">
                    <li><a class="dropdown-item" href="${ctp}/board/boardList/all">전체게시판</a></li>
                    <li><a class="dropdown-item" href="${ctp}/board/boardList/free">자유게시판</a></li>
                    <li><a class="dropdown-item" href="${ctp}/board/boardList/exercise">운동게시판</a></li>
                    <li><a class="dropdown-item" href="${ctp}/board/boardList/meal">식단게시판</a></li>
                  </ul>
                </li>
                
				<!-- 🔹 피드백 요청 현황 (단일 항목 또는 전문가 메뉴와 연계) -->
				<li class="nav-item"><a class="nav-link" href="${ctp}/expert/feedbackList">피드백 현황</a></li>
				<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/expert/feedbackList">피드백</a></li>
				<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/adminMain">관리자</a></li>
				<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/ad/dashboard">광고</a></li>
			</ul>
		</div>
		
		<!-- 로그인/로그아웃 버튼(웹) -->
		<div class="d-none d-lg-flex align-items-center">
			<c:choose>
				<c:when test="${not empty sessionScope.loginUser}">
					<span class="navbar-text me-3">👋 ${sessionScope.user.nickname}님</span>
					<a class="btn btn-outline-secondary btn-sm me-2" href="${ctp}/user/mypage">마이페이지</a>
					<a class="btn btn-primary btn-sm" href="${ctp}/user/logout">로그아웃</a>
				</c:when>
				<c:otherwise>
					<a class="btn btn-outline-primary me-2" href="${ctp}/user/login">로그인</a>
					<a class="btn btn-primary" href="${ctp}/user/userInput">회원가입</a>
				</c:otherwise>
			</c:choose>
		</div>
		
	</div>
</nav>
