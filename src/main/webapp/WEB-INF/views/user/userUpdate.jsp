<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원정보 수정</title>
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
  	'use strict'
  	
  	$(function(){
      $("#usernameBtn").hide();
      $("#usernameStatus").text("");
    });
  	
    let usernameCheckSw = 1; // 처음값은 true
    let usernameChecked = ""; //중복검사 완료한 이름
    
    // 정규식정의...(아이디,닉네임(한글/영문,숫자,밑줄),성명(한글/영문),이메일,전화번화({2,3}/{3,4}/{4}))
    let regNickName = /^[가-힣a-zA-Z0-9_]+$/;
    let regTel = /\d{2,3}-\d{3,4}-\d{4}$/g;
    
    $(function() {
    	  let phoneNumber = "${vo.phone_number}";
    	  if (phoneNumber.length === 11) {
    	    $("#tel1").val(phoneNumber.substring(0, 3));
    	    $("#tel2").val(phoneNumber.substring(3, 7));
    	    $("#tel3").val(phoneNumber.substring(7));
    	  }
    	});
    
	function finalCheck() {
      let username = myform.username.value.trim();
      
      // 닉네임 중복확인 체크
      if (usernameCheckSw !== 1) {
        alert("닉네임 중복확인을 해주세요.");
        return false;
      }
      
      // 최종 제출
      alert("수정 완료");
      myform.submit();
    }  	  
  	
  	//username 입력값 변경하면
    function checkUsernameChanged() {
      let current = myform.username.value.trim();
      let username = "${vo.username}";
       
      if(current === username) {
    	  $("#usernameBtn").hide();
    	  $("#usernameStatus").text("");
      }
      
      else{
        $("#usernameBtn").show();
  
        if (current !== usernameChecked) {
          usernameCheckSw = 0;
          $("#usernameStatus").text("❗ 중복검사 필요").css("color", "red"); // 체크표시 제거
        }
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
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<div class="container">
  <div class="form-wrapper">
    <h3 class="text-center fw-bold mb-4">🙍 회원정보 수정</h3>
    <form name="myform" method="post" action="${ctp}/user/userUpdate" enctype="multipart/form-data">
      <div class="mb-3">
        <label for="email" class="form-label">이메일</label>
        <input type="email" class="form-control" id="email" name="email" value="${vo.email}" readonly>
      </div>
      <div class="mb-3">
        <label for="username" class="form-label">닉네임</label>
        <input type="text" name="username" id="username" value="${vo.username}" required oninput="checkUsernameChanged()" class="form-control d-inline w-auto" />
        <input type="button" value="중복체크" id="usernameBtn" onclick="usernameCheck()" class="btn btn-outline-secondary btn-sm ms-2" />
        <span id="usernameStatus" class="ms-2"></span>
      </div>
      <div class="mb-3">
        <label for="phone_number" class="form-label">전화번호</label><br/>
        <input type="text" value="010" name="tel1" id="tel1" readonly class="form-control d-inline w-auto" />
        <input type="text" name="tel2" id="tel2" value="" class="form-control d-inline w-auto" />
        <input type="text" name="tel3" id="tel3" value="" class="form-control d-inline w-auto" />
      </div>
      <div class="d-grid gap-2">
        <input type="button" value="수정하기" onclick="finalCheck()" class="btn btn-primary" />
        <input type="reset" value="초기화" class="btn btn-secondary" />
        <input type="button" value="돌아가기" onclick="location.href='${ctp}';" class="btn btn-light" />
      </div>
    </form>
  </div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>