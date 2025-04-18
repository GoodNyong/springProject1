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
  <!-- ReCAPTCHA API -->
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
  <script>
    function setRecaptchaToken() {
      var response = grecaptcha.getResponse();
      document.getElementById("g-recaptcha-response").value = response;
    }
  </script>
</head>
<body>
<p><br/><p>
<div class="container">
  <form name="myform" method="post" action="${ctp}/user/userLogin" onsubmit="setRecaptchaToken()">
    <table>
      <tr>
        <td>로 그 인</td>
      </tr>
      <tr>
        <th>이메일</th>
        <td><input type="text" name="email" id="email" value="${email}" placeholder="이메일을 입력하세요" autofocus required /></td>
      </tr>
      <tr>
        <th>비밀번호</th>
        <td><input type="password" name="password" id="password" placeholder="비밀번호를 입력하세요." required /></td>
      </tr>
      <tr>
        <td>
          <p><br/></p>
          <input type="hidden" name="g-recaptcha-response" id="g-recaptcha-response">
          <div class="g-recaptcha" data-sitekey="6LccsBwrAAAAAKWo3j1E-J4L4I9a8pRcst2v6hbM"></div>
          <input type="submit" value="로그인" />
          <input type="reset" value="다시입력" />
          <a href="javascript:kakaoLogin()" ><img src="${ctp}/images/kakaoLogin.png" /></a>
          <input type="button" value="회원가입" onclick="location.href='${ctp}/user/userJoin';" />
        </td>
      </tr>
    </table>
    <table>
      <tr>
        <td>
          <input type="checkbox" name="idSave" checked /> 아이디저장 &nbsp;&nbsp;&nbsp;
          [<a href="javascript:midSearch()">아이디 찾기</a>] /
          [<a href="javascript:pwdSearch()">비밀번호 찾기</a>]
        </td>
      </tr>
    </table>
  </form>
</div>
  
</div>
<p><br/><p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>