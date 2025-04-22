<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Blinkos - 건강을 마법처럼!</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Blinkos Custom CSS (선택 사항) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/blinkos-style.css">
    <link rel="icon" href="${pageContext.request.contextPath}/resources/img/favicon.png" type="image/png">
</head>
<body>

<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<!-- 히어로 섹션 -->
<header class="text-center py-5 bg-light">
  <h1 class="display-4 fw-bold">Professor Blinkos와 함께<br>건강 루틴을 마법처럼!</h1>
  <p class="lead">운동, 식단, 분석, 피드백까지 한 번에.</p>
  <a href="${pageContext.request.contextPath}/user/main" class="btn btn-lg btn-primary mt-3">지금 시작하기</a>
</header>

<!-- 특징 목록 -->
<section class="container py-5 text-center">
  <div class="row">
    <div class="col-md-4">
      <h4>🎯 목표 설정</h4>
      <p>운동/영양 목표를 게임처럼 설정해보세요.</p>
    </div>
    <div class="col-md-4">
      <h4>📈 인사이트 리포트</h4>
      <p>나의 건강 루틴을 데이터로 분석합니다.</p>
    </div>
    <div class="col-md-4">
      <h4>🧙‍♂️ 전문가 피드백</h4>
      <p>전문가가 제안하는 맞춤형 루틴.</p>
    </div>
  </div>
</section>

<!-- 작동 방법 소개 -->
<section class="bg-white py-5">
  <div class="container text-center">
    <h2 class="mb-4">어떻게 작동하나요?</h2>
    <p>✅ 기록 → 분석 → 피드백 → 추천 루틴으로 지속 가능한 건강 관리!</p>
  </div>
</section>

<!-- Blinkos 혜택 -->
<section class="container py-5">
  <div class="row text-center">
    <div class="col-md-4">
      <h5>⏱ 루틴 자동화</h5>
      <p>데이터 기반 자동 추천</p>
    </div>
    <div class="col-md-4">
      <h5>🧠 전문성 강화</h5>
      <p>전문가의 피드백 기반 목표 관리</p>
    </div>
    <div class="col-md-4">
      <h5>🌱 지속 가능성</h5>
      <p>매일 달라지는 내 루틴!</p>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="text-center py-5 bg-primary text-white">
  <h2>지금 바로 Blinkos를 시작해보세요!</h2>
  <a href="${pageContext.request.contextPath}/user/signup" class="btn btn-light btn-lg mt-3">회원가입 하러 가기</a>
</section>

<!-- 뉴스레터 -->
<section class="container py-5 text-center">
  <h5>📬 뉴스레터 구독</h5>
  <form class="row justify-content-center mt-3">
    <div class="col-md-4 mb-3">
      <input type="email" class="form-control" placeholder="이메일 주소 입력">
    </div>
    <div class="col-auto">
      <button class="btn btn-outline-primary">구독하기</button>
    </div>
  </form>
</section>

<!-- 푸터 -->
<footer class="bg-dark text-white text-center py-4">
  <small>© 2025 Blinkos Project | 팀 Blink | 문의: contact@blinkos.health</small>
</footer>

</body>
</html>
