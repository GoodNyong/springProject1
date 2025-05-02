<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>login.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp"/>
  <style>
    .login-box { max-width: 500px; margin: auto; padding: 30px; border: 1px solid #ccc; border-radius: 8px; background: #f9f9f9; }
  </style>
  <!-- ReCAPTCHA API -->
  <!-- <script src="https://www.google.com/recaptcha/api.js" async defer></script> -->
  <script>
    /* function setRecaptchaToken() {
      var response = grecaptcha.getResponse();
      document.getElementById("g-recaptcha-response").value = response;
    } */
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<div class="container my-5">
  <div class="login-box">
    <h3 class="mb-4 fw-bold text-center">🔐 로그인</h3>
    <form method="post" action="${ctp}/user/userLogin">
      <div class="mb-3">
        <label for="email" class="form-label">이메일</label>
        <input type="text" name="email" id="email" class="form-control" required placeholder="example@email.com" />
      </div>
      <div class="mb-3">
        <label for="password" class="form-label">비밀번호</label>
        <input type="password" name="password" id="password" class="form-control" required />
      </div>
      <div class="form-check mb-3">
        <input type="checkbox" name="idSave" class="form-check-input" id="idSave" value="1" />
        <label class="form-check-label" for="idSave">이메일 저장</label>
      </div>
      <div class="d-grid gap-2 mb-3">
        <input type="submit" value="로그인" class="btn btn-primary" />
      </div>
      <div class="text-center">
        <a href="${ctp}/user/userJoin" class="btn btn-outline-secondary btn-sm">회원가입</a>
        <a href="${ctp}/user/findPassword" class="btn btn-outline-secondary btn-sm">비밀번호 찾기</a>
      </div>
    </form>
  </div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
<!-- <div class="g-recaptcha" data-sitekey="6LccsBwrAAAAAKWo3j1E-J4L4I9a8pRcst2v6hbM"></div>
          <input type="hidden" name="g-recaptcha-response" id="g-recaptcha-response"> -->