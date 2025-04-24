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
</head>
<body>
<p><br/></p>
<div class="container">
  <h2 class="text-center">비밀번호 확인</h2>
  <form name="myform" method="post" action="${ctp}/user/passwordCheck/${passwordFlag}">
    <input type="hidden" name="passwordFlag" value="${passwordFlag}" />
  	<table class="table table-bordered text-center">
      <tr>
        <th>비밀번호</th>
        <td><input type="password" name="checkPassword" id="checkPassword" placeholder="비밀번호를 입력하세요." /></td>
      </tr>
      <tr>
        <td colspan="2">
          <input type="submit" value="비밀번호확인" />
          <input type="reset" value="다시입력" />
          <input type="button" value="돌아가기" onclick="location.href='${ctp}/member/memberMain';" />
        </td>
      </tr>
    </table>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>