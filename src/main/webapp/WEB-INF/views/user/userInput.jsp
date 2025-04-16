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
	
	let usernameCheckSw = 0; // 이름 중복 체크 했는지
	
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
  	
  	function emailCertification()	{
  		
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
  					alert('인증번호가 발송되었습니다. 메일을 확인해주세요.');
  					
  					//인증번호 입력창 띄우기
    				let str = '<div class="input-group">';
    				str += '<input type="text" name="checkCode" id="checkCode"/>';
    				str += '<input type="button" value="인증번호확인" onclick="emailCeritificationOk()"/></div>';
    				str += '<div id="timer"></div>';
    				$("#demo").html(str);
    				
    				startTimer(); //타이머 함수 실행
  				}
  				else alert("인증확인버튼을 다시 눌러주세요.");
  			},
  			error : function() { alert("전송오류!"); }
  		});
  	}
  	
  	function startTimer(){
  		timeLeft = 180;
  		clearInterval(curruntTimer); //현재 타이머 삭제(초기화)
  		
  		curruntTimer = setInterval(function(){
  			let minute = Math.floor(timeLeft / 60); //math.floor : 소수점 이하를 버리고 가장 가까운 **작은 정수(내림)**를 반환
  			let second = timeLeft % 60;
  			let timeLeft2  = '${min}:${sec < 10 ? "0" + sec : sec}';
  			$("#timer").html("남은 시간: " + timeLeft2);
  			
  			if(timeLeft <= 0){
  				clearInterval(curruntTimer);
  				$("#demo").html("<div>인증 시간이 초과되었습니다.<div>");
  			}
  			
  			timeLeft--;
  		}, 1000);
  	}
  	
  	
  	
  	//비밀번호는 영문자, 숫자, 특수문자가 포함되어야 함
  	function passwordCheck1(){
  		
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
  	  } 
  	  else {
  		message.style.color = "red";
  		message.innerHTML = "비밀번호가 일치하지 않습니다.";
  	  }
  	}
  	
  	function usernameCheck()  {
  	  let username = myform.username.value;
  		
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
  			        	myform.username.focus();
  			        } else {
  			        	alert("사용 가능한 닉네임입니다.");
  			        	usernameCheckSw = 1; // 닉네임 중복검사 완료 플래그
  			        	myform.username.readOnly = true;
  			        }
  				},
  			    error: function() { alert("전송 오류!"); }
  			});
  		}
  	}
</script>
<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
</head>
<body>
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
            <input type="button" value="인증번호받기" onclick="emailCertification()" id="emailCertificationBtn">
          </div>
          <div id="demo"></div>
        </td>
      </tr>
      <tr>
        <th>비밀번호</th>
        <td>
          <div>
            <input type="password" name="password" id="password" placeholder="비밀번호를 입력하세요" required onblur="passwordCheck1()">
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
            <input type="text" name="username" id="username" placeholder="사용하실 이름을 입력하세요" required>
            <input type="button" value="중복체크" id="usernameBtn" onclick="usernameCheck()">
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