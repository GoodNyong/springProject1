<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<link rel="stylesheet" href="${ctp}/resources/css/helper_wizard.css" />
<script src="${ctp}/resources/js/helper_wizard.js" defer></script>

<main class="container mt-4 mb-5" data-page="goalExerciseList">
	<div class="row">
		<div class="mb-4 col">
			<h2>🎯 운동 목표 목록</h2>
			<p class="text-muted">당신이 설정한 마법의 루틴을 확인해보세요.</p>
		</div>
		<div class="col-auto text-center" style="max-width: 180px;">
			<jsp:include page="/WEB-INF/views/include/helper_wizard.jsp" />
		</div>
	</div>

	<c:if test="${empty exerciseGoalList}">
		<div class="alert alert-info text-center">등록된 운동 목표가 없습니다. 새로운 마법 목표를 설정해보세요.</div>
	</c:if>

	<div class="text-end mb-2">
		<a href="${ctp}/rec/goalInputExercise" class="btn btn-outline-primary">+목표 설정</a>
	</div>

	<c:if test="${not empty exerciseGoalList}">
		<div class="p-4 rounded-4 shadow-sm bg-info-subtle" style="overflow-x:auto;">
			<table class="table text-center align-middle rounded-3 overflow-hidden mb-0" style="min-width: 700px;">
				<thead>
					<tr class="bg-light">
						<th>no.</th>
						<th>운동명</th>
						<th>목표 수치</th>
						<th>기준</th>
						<th>기간</th>
						<th>설정자</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${exerciseGoalList}" varStatus="st">
						<tr>
							<td>${st.count}</td>
							<td>${vo.exercise_name}</td>
							<td>
								<c:choose>
									<c:when test="${vo.target_value % 1 == 0}">
										<fmt:formatNumber value="${vo.target_value}" type="number" maxFractionDigits="0" />
										${vo.goal_unit_label}
									</c:when>
									<c:otherwise>
										<fmt:formatNumber value="${vo.target_value}" type="number" maxFractionDigits="2" />
										${vo.goal_unit_label}
									</c:otherwise>
								</c:choose>
							</td>
							<td><c:choose>
								<c:when test="${vo.target_type == 1}">시간</c:when>
								<c:when test="${vo.target_type == 2}">칼로리</c:when>
								<c:otherwise>기타</c:otherwise>
							</c:choose></td>
							<td>
								<fmt:formatDate value="${vo.start_date}" pattern="yyyy-MM-dd" />
								~
								<fmt:formatDate value="${vo.end_date}" pattern="yyyy-MM-dd" />
							</td>
							<td>
								<c:choose>
									<c:when test="${vo.set_by == 1}">🙋‍♂️ 본인</c:when>
									<c:otherwise>🧙 전문가</c:otherwise>
								</c:choose>
							</td>
							<td>
								<a href="${ctp}/rec/goalEditExercise?goal_id=${vo.goal_id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
								<a href="javascript:void(0);" class="btn btn-sm btn-outline-danger" onclick="confirmSingleGoalDelete(${vo.goal_id});">삭제</a>
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

<script type="text/javascript">
const ctp = "${ctp}";
function confirmSingleGoalDelete(goalId) {
	const confirmBox = document.querySelector("#wizard-delete-confirm");
	const yesBtn = document.getElementById("wizard-confirm-yes");
	const noBtn = document.getElementById("wizard-confirm-no");

	confirmBox.classList.remove("d-none");

	yesBtn.onclick = () => {
		confirmBox.classList.add("d-none");
		location.href = ctp + "/rec/goalDeleteExercise?goal_id=" + goalId;
	};

	noBtn.onclick = () => {
		confirmBox.classList.add("d-none");
	};
}

</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
