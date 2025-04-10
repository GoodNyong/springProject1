<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<% pageContext.setAttribute("CRLF", "\r\n"); %>
<% pageContext.setAttribute("LF", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>test.jsp</title>
	<script>
		function goUpdate(id) {
			location.href = '${ctp}/rec/updateForm?behavior_id=' + id;
		}
		
		function goDelete(id) {
			if(confirm('정말 삭제하시겠습니까?')) {
				location.href = '${ctp}/rec/delete?behavior_id=' + id;
			}
		}
	</script>
</head>
<body>
	<div>
		<h2>test</h2>
		<form method="post">
			<table>
				<tr>
					<th>유저아이디고유번호</th>
					<td><input type="number" name="user_id" /></td>
				</tr>
				<tr>
					<th>콘탠츠아이디고유번호</th>
					<td><input type="number" name="content_id" /></td>
				</tr>
				<tr>
					<th>행동유형코드</th>
					<td><input type="number" name="event_type" /></td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="submit" value="DB_insert"/>
						<input type="reset" value="reset"/>
						<input type="button" value="home" onclick="location.href='${ctp}'"/>
					</td>
				</tr>
			</table>
		</form>
		<table>
			<thead>
				<tr>
					<th>고유번호 (behavior_id)</th>
					<th>유저 ID</th>
					<th>콘텐츠 ID</th>
					<th>행동 유형</th>
					<th>발생 시각</th>
					<th>비고</th> <!-- 새로 추가 -->
				</tr>
			</thead>
			<tbody>
				<c:forEach var="vo" items="${logList}">
					<tr>
						<td>${vo.behavior_id}</td>
						<td>${vo.user_id}</td>
						<td>${vo.content_id}</td>
						<td>
							<c:choose>
								<c:when test="${vo.event_type == 1}">조회</c:when>
								<c:when test="${vo.event_type == 2}">완독</c:when>
								<c:when test="${vo.event_type == 3}">좋아요</c:when>
								<c:when test="${vo.event_type == 4}">운동</c:when>
								<c:otherwise>기타</c:otherwise>
							</c:choose>
						</td>
						<td>${vo.occurred_at}</td>
						<td>
							<button type="button" onclick="goUpdate('${vo.behavior_id}')">수정</button>
							<button type="button" onclick="goDelete('${vo.behavior_id}')">삭제</button>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>