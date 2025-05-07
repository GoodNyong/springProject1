<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath }" />

<!-- wizardHelper.jsp -->
<div id="wizard-container" style="position: relative;">
	<img src="${ctp}/resources/img/helper_wizard.png" id="helper_wizard-img" class="img-fluid" alt="입력도우미 마법사">
	<div id="wizard-message" class="wizard-message" style="display: none;"></div>

	<!-- 삭제 확인 박스 -->
	<div id="wizard-delete-confirm" class="wizard-confirm-box d-none">
		<div class="confirm-text">정말 마법의 흔적을 지우시겠습니까?</div>
		<div class="wizard-buttons mt-2 d-flex justify-content-between">
			<button id="wizard-confirm-yes" class="btn btn-sm btn-danger">삭제할래!</button>
			<button id="wizard-confirm-no" class="btn btn-sm btn-outline-secondary">아니야</button>
		</div>
	</div>
</div>


