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
  <style>
    .form-wrapper {
      max-width: 600px;
      margin: 50px auto;
      padding: 30px;
      background-color: #f9f9f9;
      border-radius: 8px;
      box-shadow: 0 0 8px rgba(0,0,0,0.05);
    }
  </style>
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
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<div class="container">
  <div class="form-wrapper">
    <h3 class="fw-bold text-center mb-4">비밀번호 찾기</h3>
    <form action="${ctp}/user/findPassword" method="post">
      <table class="table table-borderless align-middle">
        <tr>
          <td>
            이메일:
            <input type="email" name="email" class="form-control d-inline w-50" required />
            <input type="submit" value="임시 비밀번호 받기" onclick="emailSendWating()" class="btn btn-outline-primary btn-sm ms-2" />
          </td>
        </tr>
      </table>
      <div id="demo" class="mt-3"></div>
    </form>
  </div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>