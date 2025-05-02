<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>passwordCheckForm.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <style>
    .form-wrapper {
      max-width: 600px;
      margin: 50px auto;
      padding: 30px;
      border-radius: 8px;
      background-color: #f9f9f9;
      box-shadow: 0 0 8px rgba(0,0,0,0.05);
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<div class="container">
  <div class="form-wrapper">
    <h3 class="text-center fw-bold mb-4">비밀번호 확인</h3>
    <form name="myform" method="post" action="${ctp}/user/passwordCheck/${passwordFlag}">
      <input type="hidden" name="passwordFlag" value="${passwordFlag}" />
      <table class="table table-bordered text-center align-middle">
        <tr>
          <th>비밀번호</th>
          <td><input type="password" name="checkPassword" id="checkPassword" placeholder="비밀번호를 입력하세요." /></td>
        </tr>
        <tr>
          <td colspan="2">
            <input type="submit" value="비밀번호확인" class="btn btn-primary" />
            <input type="reset" value="다시입력" class="btn btn-secondary" />
            <input type="button" value="돌아가기" class="btn btn-light" onclick="location.href='${ctp}/member/memberMain';" />
          </td>
        </tr>
      </table>
    </form>
  </div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>