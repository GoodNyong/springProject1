<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="mealRecordList">
	<div class="row">
		<div class="mb-4 col">
			<h2>🍽 식단 기록 목록</h2>
			<p class="text-muted">기록한 식단 내역을 확인하세요.</p>
		</div>
		<div class="col-auto text-center" style="max-width: 180px;">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>

	<c:if test="${empty mealRecordList}">
		<div class="alert alert-info text-center">아직 등록된 식단 기록이 없습니다.</div>
	</c:if>

	<div class="text-end mb-2">
		<a href="${ctp}/rec/mealRecordInput" class="btn btn-outline-primary">+식단기록추가</a>
	</div>

	<c:if test="${not empty mealRecordList}">
		<div class="p-4 rounded-4 shadow-sm bg-info-subtle" style="overflow-x: auto;">
			<table class="table text-center align-middle rounded-3 overflow-hidden mb-0" style="min-width: 600px;">
				<thead>
					<tr>
						<th class="bg-info-subtle">no.</th>
						<th class="bg-info-subtle">음식명</th>
						<th class="bg-info-subtle">섭취량</th>
						<th class="bg-info-subtle">시간대</th>
						<th class="bg-info-subtle">식사 날짜</th>
						<th class="bg-info-subtle">관리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${mealRecordList}" varStatus="st">
						<tr>
							<td>${st.count}</td>
							<td>${vo.food_name}</td>
							<td>${vo.quantity}</td>
							<td>
								<c:choose>
									<c:when test="${vo.meal_time == 1}">아침</c:when>
									<c:when test="${vo.meal_time == 2}">점심</c:when>
									<c:when test="${vo.meal_time == 3}">저녁</c:when>
									<c:otherwise>간식</c:otherwise>
								</c:choose>
							</td>
							<td><fmt:formatDate value="${vo.meal_date}" pattern="yyyy-MM-dd" /></td>
							<td>
								<input type="hidden" name="record_id" value="${vo.meal_id}" />
								<a href="${ctp}/rec/mealRecordEdit?record_id=${vo.meal_id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
								<a href="${ctp}/rec/mealRecordDelete?record_id=${vo.meal_id}" class="btn btn-sm btn-outline-danger"
								   onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</c:if>

	<div class="mt-4 text-center">
		<a href="${ctp}/user/main" class="btn btn-outline-primary">🏠 메인으로 돌아가기</a>
	</div>
</main>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
