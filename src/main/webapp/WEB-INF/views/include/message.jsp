<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>마법사의 메시지</title>
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<style>
		.wizard-img {
			max-width: 180px;
			animation: float 2s ease-in-out infinite;
		}
		.wizard-message {
			font-size: 1.4rem;
			font-weight: bold;
			color: #3b60a0;
		}
		@keyframes float {
			0%, 100% { transform: translateY(0); }
			50% { transform: translateY(-10px); }
		}
	</style>
</head>
<body>
	<div class="container text-center mt-5">
		<img src="${ctp}/resources/img/helper_wizard.png" alt="도우미 마법사" class="wizard-img mb-4" />
		<p class="wizard-message">“${message}”</p>
		<p class="text-muted">잠시 후 자동으로 이동합니다...</p>
	</div>

	<script>
		setTimeout(function() {
			location.href = "${ctp}/${url}";
		}, 800);
	</script>
</body>
</html>
