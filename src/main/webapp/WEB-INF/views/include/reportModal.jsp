<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>reportModal.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp"/>
</head>
<body>
<p><br/><p>
<div class="modal fade" id="reportModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">신고하기</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <h5>신고사유 선택</h5>
        <hr class="border">
        <form name="modalForm">
          <div><input type="radio" name="reportReason" id="reportReason1" value="광고,홍보,영리목적"/> 광고,홍보,영리목적</div>
          <div><input type="radio" name="reportReason" id="reportReason2" value="욕설,비방,차별,혐오"/> 욕설,비방,차별,혐오</div>
          <div><input type="radio" name="reportReason" id="reportReason3" value="불법정보"/> 불법정보</div>
          <div><input type="radio" name="reportReason" id="reportReason4" value="음란,청소년유해"/> 음란,청소년유해</div>
          <div><input type="radio" name="reportReason" id="reportReason5" value="개인정보노출,유포,거래"/> 개인정보노출,유포,거래</div>
          <div><input type="radio" name="reportReason" id="reportReason6" value="도배,스팸"/> 도배,스팸</div>
          <div><input type="radio" name="reportReason" id="reportReason7" value="기타" onclick="etcShow()"/> 기타</div>
          <div id="etc"><textarea rows="2" id="reportText" class="form-control" style="display:none"></textarea></div>
          <hr class="border">
          <input type="hidden" id="modalPart" value=""/>
          <input type="hidden" id="modalCommentId" />
          <input type="hidden" id="modalReplyId" />
          <input type="button" value="확인" onclick="reportCheck()" class="btn btn-success form-control" />
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
<p><br/><p>
</body>
</html>