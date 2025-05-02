<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>userJoin.jsp</title>
<style>
  .form-wrapper {
    max-width: 800px;
    margin: 50px auto;
    background: #f9f9f9;
    border-radius: 8px;
    padding: 30px;
    box-shadow: 0 0 8px rgba(0,0,0,0.05);
  }
</style>
<script>
    'use strict'
    
    let usernameCheckSw = 0; // 이름 중복 체크 했는지
    let emailVerifiedSw = 0; // 이메일 인증 했는지
    let passwordValidSw = 0;  // 비밀번호 정규식에 부합하는지
    let passwordConfirmSw = 0;  // 비밀번호 확인 일치하는지
    let privacyPolicyCheckSw = 0; // 개인정보 처리방침 체크
    
    let usernameChecked = ""; //중복검사 완료한 이름
  
    let codeConfirmStarted = null; //인증번호 발송 시작 시간
    let curruntTimer = null; //현재 타이머
    let timeLimit = 180; //제한시간 3분
    
    // 정규식정의...(아이디,닉네임(한글/영문,숫자,밑줄),성명(한글/영문),이메일,전화번화({2,3}/{3,4}/{4}))
    let regMid = /^[a-zA-Z0-9_]{4,20}$/;
    let regNickName = /^[가-힣a-zA-Z0-9_]+$/;
    let regName = /^[가-힣a-zA-Z]+$/;
    let regEmail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
    let regTel = /\d{2,3}-\d{3,4}-\d{4}$/g;
    
    //비밀번호 정규식
    let regEnglish = /[a-zA-Z]/;     // 영문자
    let regNumber = /[0-9]/;         // 숫자
    let regSpecial = /[^a-zA-Z0-9]/; // 특수문자 전체
    
    function finalCheck() {
      let email1 = myform.email1.value.trim();
      let email2 = myform.email2.value.trim();
      let email = email1 + "@" + email2;
      let username = myform.username.value.trim();
      let password = myform.password.value.trim();
      let password2 = myform.password2.value.trim();	
      let tel1 = myform.tel1.value.trim();
      let tel2 = myform.tel2.value.trim();
      let tel3 = myform.tel3.value.trim();
      let phone_number = tel1 + tel2 + tel3 + " ";
      console.log(tel2)
      console.log(phone_number)
      
      // 이메일 인증 체크
      if (emailVerifiedSw !== 1) {
        alert("이메일 인증을 완료해주세요.");
        return false;
      }
      
      // 닉네임 중복확인 체크
      if (usernameCheckSw !== 1) {
        alert("닉네임 중복확인을 해주세요.");
        return false;
      }
      
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
      
      if (privacyPolicyCheckSw !== 1) {
        alert("개인정보 처리방침에 동의해주세요.");
        return false;
      }
      
      // 최종 제출
      alert("회원가입이 완료되었습니다.");
      myform.submit();
    }
    
    function emailCertification() {
      
      //이메일 형식 체크
      let email1 = myform.email1.value.trim();
      let email2 = myform.email2.value.trim();
      let email = email1 + "@" + email2;
      
      if(!regEmail.test(email)){
        alert("이메일 형식에 맞지 않습니다.")
        myform.email1.focus();
        return false;
      }
      
      
      //인증번호 발송됐다고 띄우기
      let spinner = "<div class='text-center'><div class='spinner-border'></div> 메일 발송중입니다. 잠시만 기다려주세요. <div class='spinner-border'></div></div>";
      $("#demo").html(spinner);
      
      //메일로 인증번호 보내기
      $.ajax({
        url : "${ctp}/user/userEmailCheck",
        type : "post",
        data : {email : email},
        success : function(res){
          if(res != '0') {
        	document.getElementById("email").value = email;
            codeConfirmStarted = new Date(); // 현재 시간
            startTimer();
            
            alert('인증번호가 발송되었습니다. 메일을 확인해주세요.');
            
            //인증번호 입력창, 타이머 띄우기
            let str = '<div class="input-group">';
            str += '<input type="text" name="checkCode" id="checkCode"/>';
            str += '<input type="button" value="인증번호확인" name="checkCodeBtn" id="checkCodeBtn" onclick="emailCeritificationOk()"/></div>';
            str += '<div id="timer"></div>';
            $("#demo").html(str);
            
            
          }
          else alert("인증확인버튼을 다시 눌러주세요.");
        },
        error : function() { alert("전송오류!"); }
      });
    }
    
    function startTimer(){
      clearInterval(curruntTimer); //현재 타이머 삭제(초기화)
      
      curruntTimer = setInterval(function(){
        let now = new Date();
        let timeLeft = timeLimit - (Math.floor((now - codeConfirmStarted) / 1000)); //math.floor : 소수점 이하를 버리고 가장 가까운 **작은 정수(내림)**를 반환
        //남은시간 = 제한시간 - ((현재시간-발송시간)/1000)
        
        
        if(timeLeft <= 0){
          clearInterval(curruntTimer);
          $("#demo").html("<div>인증 시간이 초과되었습니다.<div>");
          return;
        }
        
        let minute = Math.floor(timeLeft / 60);
        let second = timeLeft % 60;
        let timeString = minute + ":" + (second < 10 ? "0" + second : second);
        $("#timer").html("남은 시간: " + timeString);
      }, 1000);
    }
    
    function emailCeritificationOk() {
      let code = $("#checkCode").val().trim();
      
      if(code == ""){
        alert("인증번호를 입력해주세요.");
        return false;
      }
      
      $.ajax({
        url : "${ctp}/user/emailCodeConfirm",
        type : "post",
        data : {code : code},
        success : function(res){
          if(res == "1"){
            alert("이메일 인증이 완료되었습니다.");
            clearInterval(curruntTimer); //타이머 종료
            emailVerifiedSw = 1; // 닉네임 중복검사 완료 플래그
            
                // 인증번호 입력창, 확인 버튼 제거
                $("#checkCode").remove();
                $("#checkBtn").remove();
                
                // 타이머 문구 제거
                $("#timer").remove();
            
                // 이메일 입력창 readonly 처리
                $("#email1").prop("readonly", true);
                $("#email2").prop("disabled", true);
                
                // 인증번호확인 버튼 숨기기
                $("#checkCodeBtn").hide();
                
              // 인증번호 받기 버튼 숨기기
                $("#emailCertificationBtn").hide();
                
                // 완료 체크 아이콘 표시
                let okIcon = "<span style='color:green; font-weight:bold;'>&nbsp;✔ 인증완료</span>";
                $("#emailStatus").html(okIcon);
          }
          else{
            alert("인증번호가 일치하지 않습니다.");
          }
        },
        error : function(){
          alert("전송 오류!");
        }
      });
    }
    
    
    
    //비밀번호는 영문자, 숫자, 특수문자가 포함되어야 함
    function passwordCheck(){
      
      let password = myform.password.value.trim();
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
      let password = myform.password.value.trim();
      let password2 = myform.password2.value.trim();
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
    
    function usernameCheck()  {
        let username = myform.username.value.trim();
      
      if(username.trim() == "") {
        alert("아이디를 입력하세요");
        myform.username.focus();
      }
      else{
        $.ajax({
          url : "${ctp}/user/usernameCheck",
          type : "get",
          data : {username : username},
          success:function(res){
            if (res != '0') {
                  alert("이미 사용 중인 닉네임입니다. 다시 입력하세요");
                  usernameCheckSw = 0;
                  myform.username.focus();
                } else {
                  alert("사용 가능한 닉네임입니다.");
                  usernameCheckSw = 1; // 닉네임 중복검사 완료 플래그
                  usernameChecked = username; //중복확인 통과한 닉네임 최신화
                  $("#usernameStatus").text("✔ 사용 가능").css("color", "green");
                }
          },
            error: function() { alert("전송 오류!"); }
        });
      }
    }
    
    //username 입력값 변경하면
    function checkUsernameChanged() {
      let current = myform.username.value.trim();

      if (current !== usernameChecked) {
        usernameCheckSw = 0;
        $("#usernameStatus").text(""); // 체크표시 제거
      }
    }
    
    //개인정보 처리 체크박스
    function privacyPolicyCheck() {
    	privacyPolicyCheckSw = (privacyPolicyCheckSw === 0) ? 1 : 0;
    }
</script>
<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<div class="container">
  <div class="form-wrapper">
    <h3 class="text-center fw-bold mb-4">회 원 가 입</h3>
    <form name="myform" method="post" action="${ctp}/user/userJoin" enctype="multipart/form-data">
    <table class="table table-bordered text-center align-middle">
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
            <input type="hidden" name="email" id="email">
            <input type="button" value="인증번호받기" onclick="emailCertification()" id="emailCertificationBtn">
            <span id="emailStatus"></span>
          </div>
          <div id="demo"></div>
        </td>
      </tr>
      <tr>
        <th>비밀번호</th>
        <td>
          <div>
            <input type="password" name="password" id="password" placeholder="비밀번호를 입력하세요" required onblur="passwordCheck()">
            <br><span id="passwordMessage" style="color:red; font-size:0.9em;"></span>
          </div>
        </td>
      </tr>
      <tr>
        <th>비밀번호 확인</th>
        <td>
          <div>
            <input type="password" name="password2" id="password2" placeholder="비밀번호를 한번 더 입력하세요" required oninput="passwordCheck2()">
            <br><span id="password2Message" style="color:red; font-size:0.9em;"></span>
          </div>
        </td>
      </tr>
      <tr>
        <th>이름(닉네임)</th>
        <td>
          <div>
            <input type="text" name="username" id="username" placeholder="사용하실 이름을 입력하세요" required oninput="checkUsernameChanged()">
            <input type="button" value="중복체크" id="usernameBtn" onclick="usernameCheck()">
            <span id="usernameStatus"></span>
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
            <input type="hidden" name="phone_number" id="phone_number">
          </div>
        </td>
      </tr>
    </table>
    <div class="mt-3">
      <div class="form-check mb-3">
        <input class="form-check-input" type="checkbox" name="privacy" onclick="privacyPolicyCheck()" id="privacyCheck" />
        <label class="form-check-label" for="privacyCheck">
          개인정보 처리방침에 동의합니다.
        </label>
        <a href="${ctp}/privacyPolicy" target="_blank" class="ms-2">[자세히 보기]</a>
      </div>
      <div class="d-grid gap-2">
        <input type="button" value="회원가입" onclick="finalCheck()" class="btn btn-primary" />
        <input type="reset" value="초기화" class="btn btn-secondary" />
        <input type="button" value="돌아가기" onclick="location.href='${ctp}';" class="btn btn-light" />
      </div>
    </div>
    </form>
  </div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>