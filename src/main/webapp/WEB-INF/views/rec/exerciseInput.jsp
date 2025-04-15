<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />


<main class="container mt-4 mb-5">
  <h2 class="mb-4">📍 페이지 제목</h2>
  <p class="text-muted">여기에 본문 내용을 작성하세요.</p>
</main>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
