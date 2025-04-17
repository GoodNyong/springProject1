<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>userInput.jsp</title>
<script>
	'use strict'
	
	// 정규식정의...(아이디,닉네임(한글/영문,숫자,밑줄),성명(한글/영문),이메일,전화번화({2,3}/{3,4}/{4}))
  	let regMid = /^[a-zA-Z0-9_]{4,20}$/;
  	let regNickName = /^[가-힣a-zA-Z0-9_]+$/;
  	let regName = /^[가-힣a-zA-Z]+$/;
  	let regEmail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
  	let regTel = /\d{2,3}-\d{3,4}-\d{4}$/g;
  	
  	function finalCheck(){
  		let 
  	}
  	
</script>
<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
  <div class="container">
    <h3 class="text-center">회 원 가 입</h3>
    <form name="myform" method="post" enctype="multipart/form-data">
    <table class="table table-bordered text-center">
      <tr>
        <th>이메일</th>
        <td>
          <div>
            <input type="text" name="email1" id="email1" required autofocus>@
            <select name="email2" id="email2">
              <option>naver.com</option>
              <option>hanmail.net</option>
              <option>gmail.com</option>
              <option>daum.net</option>
              <option>yahoo.com</option>
              <option>hatmail.com</option>
              <option>nate.com</option>             
            </select>
          </div>
        <td>
      </tr>
      <tr>
        <th>비밀번호</th>
        <td>
          <div>
            <input type="password" name="password" id="password" placeholder="비밀번호를 입력하세요" required>
          </div>
        </td>
      </tr>
      <tr>
        <th>이름(닉네임)</th>
        <td>
          <div>
            <input type="text" name="username" id="username" placeholder="사용하실 이름을 입력하세요" required>
            <input type="button" value="중복체크" id="usernameBtn" onclick="usernameDuplicateCheck">
          </div>
        </td>
      </tr>
      <tr>
        <th>전화번호(선택)</th>
        <td>
          <div>
            <input type="text" value="010" name="tel1" id="tel1" readonly>
            <input type="text" name="tel2" id="tel2">
            <input type="text" name="tel3" id="tel3">
          </div>
        </td>
      </tr>
    </table>
    <div>
      <input type="button" value="회원가입" onclick="finalCheck()">
      <input type="button" value="돌아가기" onclick="location.href='${ctp}';">
    </div>
    </form>
  </div>
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>