<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>개인정보 처리방침</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <style>
    .policy-wrapper {
      max-width: 900px;
      margin: 50px auto;
      padding: 40px;
      background: #fff;
      border: 1px solid #ddd;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0,0,0,0.05);
      font-family: "맑은 고딕", sans-serif;
      line-height: 1.8;
    }
    .policy-wrapper h1 {
      font-size: 2rem;
      font-weight: bold;
      margin-bottom: 30px;
    }
    .policy-wrapper h2 {
      margin-top: 40px;
      font-size: 1.25rem;
      border-left: 4px solid #0d6efd;
      padding-left: 10px;
    }
    .policy-wrapper ul {
      padding-left: 20px;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<div class="container">
  <div class="policy-wrapper">
    <h1>개인정보 처리방침</h1>
    <p>Blinkos(이하 "회사")는 이용자의 개인정보를 소중하게 생각하며, 관련 법령을 준수하여 아래와 같이 개인정보를 수집 및 처리하고 있습니다.</p>

    <h2>1. 수집하는 개인정보 항목</h2>
    <ul>
      <li>필수항목: 아이디, 비밀번호, 이름, 생년월일, 성별, 이메일, 휴대폰 번호</li>
      <li>서비스 이용 과정에서 수집되는 정보: 접속 로그, 쿠키, 접속 IP 정보, 서비스 이용 기록</li>
    </ul>

    <h2>2. 개인정보 수집 및 이용 목적</h2>
    <ul>
      <li>회원 가입 의사 확인 및 본인 확인</li>
      <li>서비스 제공 및 계약의 이행</li>
      <li>고지사항 전달, 민원 처리, 고객 상담</li>
      <li>맞춤형 콘텐츠 제공 및 서비스 개선</li>
    </ul>

    <h2>3. 개인정보 보유 및 이용 기간</h2>
    <ul>
      <li>회원 탈퇴 시까지</li>
      <li>단, 관련 법령에 따라 일정 기간 보존이 필요한 경우 해당 기간까지</li>
      <li>(예: 전자상거래법 - 계약 또는 청약철회에 관한 기록: 5년 등)</li>
    </ul>

    <h2>4. 개인정보 제3자 제공</h2>
    <ul>
      <li>회사는 원칙적으로 개인정보를 외부에 제공하지 않습니다.</li>
      <li>단, 법률에 특별한 규정이 있거나 사용자의 사전 동의를 얻은 경우에만 제공합니다.</li>
    </ul>

    <h2>5. 개인정보 처리 위탁</h2>
    <ul>
      <li>회사는 서비스 향상을 위해 필요한 경우 일부 업무를 외부에 위탁할 수 있습니다.</li>
      <li>위탁 시 위탁받는 자와 업무 내용은 홈페이지를 통해 공지합니다.</li>
    </ul>

    <h2>6. 이용자의 권리 및 행사 방법</h2>
    <ul>
      <li>이용자는 언제든지 자신의 개인정보에 대한 조회, 수정, 삭제 요청을 할 수 있습니다.</li>
      <li>개인정보 관련 권리 행사는 이메일 또는 고객센터를 통해 가능합니다.</li>
    </ul>

    <h2>7. 개인정보 보호책임자</h2>
    <ul>
      <li>이름: 홍길동</li>
      <li>소속: Blinkos 개인정보보호팀</li>
      <li>연락처: privacy@blinkos.com</li>
    </ul>

    <p class="mt-4"><small>본 개인정보처리방침은 2025년 4월 1일부터 적용됩니다.</small></p>
  </div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>