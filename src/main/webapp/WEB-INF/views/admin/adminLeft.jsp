<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>adminLeft.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
</head>
<body style="background-color:#f8f9fa">
<div class="text-center">
  <div class="card m-1 p-1"><a href="${ctp}/admin/adminContent" target="adminContent">관리자메뉴</a></div>
  <div class="card m-1 p-1"><a href="${ctp}/" target="_top">홈으로</a></div>

  <div class="card m-1">
    <div class="card-header p-1"><a href="#post" class="btn w-100" data-bs-toggle="collapse">📁 게시글관리</a></div>
    <div id="post" class="collapse">
      <div class="card-body p-2">
        <div><a href="#" target="adminContent">게시판리스트</a></div>
        <div><a href="#" target="adminContent">공지사항리스트</a></div>
        <div><a href="#" target="adminContent">신고처리완료 리스트</a></div>
      </div>
    </div>
  </div>

  <div class="card m-1">
    <div class="card-header p-1"><a href="#user" class="btn w-100" data-bs-toggle="collapse">👤 회원관리</a></div>
    <div id="user" class="collapse">
      <div class="card-body p-2">
        <div><a href="#" target="adminContent">회원리스트</a></div>
        <div><a href="#" target="adminContent">회원문의 메시지리스트</a></div>
      </div>
    </div>
  </div>

  <div class="card m-1">
    <div class="card-header p-1"><a href="#report" class="btn w-100" data-bs-toggle="collapse">🚨 신고관리</a></div>
    <div id="report" class="collapse">
      <div class="card-body p-2">
        <div><a href="#" target="adminContent">게시글 신고 리스트</a></div>
        <div><a href="#" target="adminContent">댓글 신고 리스트</a></div>
        <div><a href="#" target="adminContent">답글 신고 리스트</a></div>
      </div>
    </div>
  </div>

  <div class="card m-1">
    <div class="card-header p-1"><a href="#log" class="btn w-100" data-bs-toggle="collapse">📝 로그관리</a></div>
    <div id="log" class="collapse">
      <div class="card-body p-2">
        <div><a href="#" target="adminContent">로그관리</a></div>
      </div>
    </div>
  </div>
</div>
</body>
</html>