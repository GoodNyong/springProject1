<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />

<main class="container mt-4" data-page="report">
  <h2 class="mb-4">기록 리포트</h2>
  <div class="row text-center">
    <div class="col-md-6">
      <div class="card shadow-sm p-3 mb-4 rounded">
        <h4>운동 리포트 보기</h4>
        <p>운동 기록과 목표 달성률을 시각화해서 확인하세요.</p>
        <a href="${ctp}/rec/reportExercise" class="btn btn-primary">운동 리포트</a>
      </div>
    </div>
    <div class="col-md-6">
      <div class="card shadow-sm p-3 mb-4 rounded">
        <h4>식단 리포트 보기</h4>
        <p>식단 기록을 기준으로 하루 영양 밸런스를 분석합니다.</p>
        <a href="${ctp}/rec/reportMeal" class="btn btn-success">식단 리포트</a>
      </div>
    </div>
  </div>
</main>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
