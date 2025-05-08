<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>마이페이지</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />

<div class="container my-5" style="max-width: 800px;">
  <h3 class="mb-4 fw-bold">👤 ${vo.username} 님의 마이페이지</h3>

  <!-- 내 정보 -->
  <div class="mb-4 border rounded p-4 bg-light">
    <p><strong>이메일</strong>: ${vo.email}</p>
    <p><strong>닉네임</strong>: ${vo.username}</p>
    <p><strong>전화번호</strong>: ${vo.phone_number}</p>
  </div>

  <!-- 주요 기능 버튼 -->
  <div class="d-flex justify-content-around mb-5">
    <a href="${ctp}/user/passwordCheck/p" class="btn btn-outline-primary">🔒 비밀번호 변경</a>
    <a href="${ctp}/board/boardListByUser/${vo.user_id}" class="btn btn-outline-secondary">💬 내 게시물 목록</a>
    <a href="${ctp}/user/passwordCheck/u" class="btn btn-outline-success">✏ 회원정보 수정</a>
    <a href="${ctp}/user/passwordCheck/d" class="btn btn-outline-danger">❌ 회원탈퇴</a>
  </div>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>