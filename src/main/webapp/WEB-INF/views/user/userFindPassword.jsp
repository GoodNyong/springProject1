<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>userFindPassword.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp"/>
  <script>
  	'use strict'
  	
  	function emailSendWating(){
        //타이머 이모티콘 돌리기
        let spinner = "<div class='text-center'><div class='spinner-border'></div> 메일 발송중입니다. 잠시만 기다려주세요. <div class='spinner-border'></div></div>";
        $("#demo").html(spinner);
  	}
  </script>
</head>
<body>
<p><br/><p>
  <h2>비밀번호 찾기</h2>
  <div class="container">
    <form action="${ctp}/user/findPassword" method="post">
      <table>
        <tr>
          <td>이메일:
            <input type="email" name="email" required>
            <input type="submit" value="임시 비밀번호 받기" onclick="emailSendWating()" />
          </td>
        </tr>
       </table>
       <div id="demo"></div>
    </form>
  </div>
<p><br/><p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>