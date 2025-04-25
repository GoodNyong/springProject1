<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="goalMealList">
	<div class="row">
		<div class="mb-4 col">
			<h2>🍱 식단 목표 목록</h2>
			<p class="text-muted">당신이 설정한 마법의 식단 목표를 확인해보세요.</p>
		</div>
		<div class="col-auto text-center" style="max-width: 180px;">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>

	<c:if test="${empty nutritionGoalList}">
		<div class="alert alert-info text-center">아직 등록된 식단 목표가 없습니다.</div>
	</c:if>

	<div class="text-end mb-2">
		<a href="${ctp}/rec/goalInputNutrition" class="btn btn-outline-primary">+목표 설정</a>
	</div>

	<c:if test="${not empty nutritionGoalList}">
		<div class="p-4 rounded-4 shadow-sm bg-info-subtle" style="overflow-x:auto;">
			<table class="table text-center align-middle rounded-3 overflow-hidden mb-0" style="min-width: 700px;">
				<thead>
					<tr class="bg-light">
						<th>no.</th>
						<th style="min-width:100px;">목표 유형</th>
						<th style="min-width:140px;">목표 항목</th>
						<th style="min-width:100px;">목표 수치</th>
						<th style="min-width:140px;">기간</th>
						<th style="min-width:100px;">설정자</th>
						<th style="min-width:120px;">관리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${nutritionGoalList}" varStatus="st">
						<tr>
							<td>${st.count}</td>
							<td>
								<c:choose>
									<c:when test="${vo.goal_type == 1}">영양소</c:when>
									<c:when test="${vo.goal_type == 2}">식품</c:when>
									<c:otherwise>알 수 없음</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${vo.goal_type == 1}">
										${vo.nutrient_name}
									</c:when>
									<c:otherwise>
										${vo.food_name}
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<fmt:formatNumber value="${vo.target_value}" maxFractionDigits="2" />
								${vo.goal_unit_label}
							</td>
							<td>
								<fmt:formatDate value="${vo.start_date}" pattern="yyyy-MM-dd" /> ~
								<fmt:formatDate value="${vo.end_date}" pattern="yyyy-MM-dd" />
							</td>
							<td>
								<c:choose>
									<c:when test="${vo.set_by == 1}">🙋‍♂️ 본인</c:when>
									<c:otherwise>🧙 전문가</c:otherwise>
								</c:choose>
							</td>
							<td>
								<a href="${ctp}/rec/goalEditNutrition?goal_id=${vo.goal_id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
								<a href="javascript:void(0);" class="btn btn-sm btn-outline-danger" onclick="confirmSingleGoalDelete(${vo.goal_id});">삭제</a>
								<input type="hidden" name="goal_id" value="${vo.goal_id}" />
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
