<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>userPasswordReset.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <style>
    .form-wrapper {
      max-width: 700px;
      margin: 50px auto;
      padding: 30px;
      border-radius: 8px;
      background: #f9f9f9;
      box-shadow: 0 0 8px rgba(0,0,0,0.05);
    }
  </style>
  <script>
    'use strict';
    
    //비밀번호 정규식
    let regEnglish = /[a-zA-Z]/;     // 영문자
    let regNumber = /[0-9]/;         // 숫자
    let regSpecial = /[^a-zA-Z0-9]/; // 특수문자 전체
    
    let passwordValidSw = 0;  // 비밀번호 정규식에 부합하는지
    let passwordConfirmSw = 0;  // 비밀번호 확인 일치하는지
    
    function finalCheck() {
    	let newPassword = document.getElementById("newPassword").value;
    	let rePassword = document.getElementById("rePassword").value;
    	
        if (passwordValidSw !== 1) {
            alert("비밀번호 형식이 올바르지 않습니다.");
            myform.password.focus();
            return false;
          }
      
        if (passwordConfirmSw !== 1) {
          	alert("비밀번호가 일치하지 않습니다.");
            myform.password2.focus();
            return false;
          }

        console.log("✅ form 제출됨");
    	myform.submit();
    }
    
    //비밀번호는 영문자, 숫자, 특수문자가 포함되어야 함
    function passwordCheck(){
      
      let password = myform.newPassword.value.trim();
      let message = document.getElementById("passwordMessage");
      
      if (password.length < 10 || password.length > 20) {
        message.style.color = "red";
        message.innerHTML = "비밀번호는 10자 이상 20자 이하로 입력해주세요.";
          return false;
      }
      else if (!regEnglish.test(password)) {
        message.style.color = "red";
        message.innerHTML = "비밀번호는 영문자로 이루어져 있어야 합니다.";
          return false;
      }
      else if (!regNumber.test(password)) {
        message.style.color = "red";
        message.innerHTML = "숫자가 반드시 포함되어야 합니다.";
          return false;
      }
      else if (!regSpecial.test(password)){
        message.style.color = "red";
        message.innerHTML = "특수문자가 반드시 포함되어야 합니다.";
          return false; 
      }
        else {
          message.style.color = "green";
            message.innerHTML = "사용 가능한 비밀번호입니다.";
            passwordValidSw = 1; //정규식 통과
          return true;
        }
    }
    
    //비밀번호확인은 치는 동안 계속 확인하고 메세지를 띄우도록 함
    function passwordCheck2() {
      let password = myform.newPassword.value.trim();
      let password2 = myform.rePassword.value.trim();
      let message = document.getElementById("password2Message");

      if (password === password2 && password2 !== "") {
      message.style.color = "green";
      message.innerHTML = "비밀번호가 일치합니다.";
      passwordConfirmSw = 1;
      } 
      else {
      message.style.color = "red";
      message.innerHTML = "비밀번호가 일치하지 않습니다.";
      }
    }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<div class="container">
  <div class="form-wrapper">
    <h3 class="text-center fw-bold mb-4">비밀번호 변경</h3>
    <form name="myform" method="post" action="${ctp}/user/passwordReset">
      <table class="table table-bordered text-center align-middle">
        <tr>
          <th>새로운 비밀번호</th>
          <td>
            <input type="password" name="newPassword" id="newPassword" placeholder="새로운 비밀번호를 입력하세요" required onblur="passwordCheck()">
            <br><span id="passwordMessage" style="color:red; font-size:0.9em;"></span>
          </td>
        </tr>
        <tr>
          <th>비밀번호 확인</th>
          <td>
            <input type="password" name="rePassword" id="rePassword" placeholder="비밀번호를 한번 더 입력하세요" required oninput="passwordCheck2()">
            <br><span id="password2Message" style="color:red; font-size:0.9em;"></span>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <input type="button" value="비밀번호변경" onclick="finalCheck()" class="btn btn-primary" />
            <input type="reset" value="다시입력" class="btn btn-secondary"/>
            <input type="button" value="돌아가기" onclick="location.href='${ctp}/user/userMain';" class="btn btn-light" />
          </td>
        </tr>
      </table>
    </form>
  </div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>