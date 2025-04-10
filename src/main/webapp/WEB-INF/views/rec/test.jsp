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
		function goDelete(id) {
			if(confirm('정말 삭제하시겠습니까?')) {
				location.href = '${ctp}/rec/delete?behavior_id=' + id;
			}
		}
		
		function startEdit(rowId) {
			const row = document.getElementById("row-" + rowId);
			const userId = row.querySelector(".user_id").innerText.trim();
			const contentId = row.querySelector(".content_id").innerText.trim();
			const eventType = row.querySelector(".event_type").getAttribute("data-value")?.trim();
			
			row.querySelector(".user_id").innerHTML =
				'<input type="number" name="user_id" value="' + userId + '" />';

			row.querySelector(".content_id").innerHTML =
				'<input type="number" name="content_id" value="' + contentId + '" />';

			row.querySelector(".event_type").innerHTML =
				'<select name="event_type">' +
					'<option value="1"' + (eventType == 1 ? ' selected' : '') + '>조회</option>' +
					'<option value="2"' + (eventType == 2 ? ' selected' : '') + '>완독</option>' +
					'<option value="3"' + (eventType == 3 ? ' selected' : '') + '>좋아요</option>' +
					'<option value="4"' + (eventType == 4 ? ' selected' : '') + '>운동</option>' +
				'</select>';


			row.querySelector(".actions").innerHTML =
				'<button onclick="submitEdit(' + rowId + ')">저장</button>' +
				'<button onclick="cancelEdit(' + rowId + ')">취소</button>';

		}
		
		function cancelEdit(rowId) {
			location.reload(); // 간단하게 새로고침으로 복구
		}

		function submitEdit(rowId) {
			const row = document.getElementById("row-" + rowId);
			const behaviorId = row.querySelector(".behavior_id").innerText;
			const userId = row.querySelector("input[name='user_id']").value;
			const contentId = row.querySelector("input[name='content_id']").value;
			const eventType = row.querySelector("select[name='event_type']").value;

			const form = document.createElement("form");
			form.method = "post";
			form.action = "${ctp}/rec/update";

			const fields = {
				behavior_id: behaviorId,
				user_id: userId,
				content_id: contentId,
				event_type: eventType
			};

			for (const key in fields) {
				const input = document.createElement("input");
				input.type = "hidden";
				input.name = key;
				input.value = fields[key];
				form.appendChild(input);
			}

			document.body.appendChild(form);
			form.submit();
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
					<tr id="row-${vo.behavior_id}">
						<td class="behavior_id">${vo.behavior_id}</td>
						<td class="user_id">${vo.user_id}</td>
						<td class="content_id">${vo.content_id}</td>
						<td class="event_type" data-value="${vo.event_type}"><c:choose>
								<c:when test="${vo.event_type == 1}">조회</c:when>
								<c:when test="${vo.event_type == 2}">완독</c:when>
								<c:when test="${vo.event_type == 3}">좋아요</c:when>
								<c:when test="${vo.event_type == 4}">운동</c:when>
								<c:otherwise>기타</c:otherwise>
							</c:choose></td>
						<td>${vo.occurred_at}</td>
						<td class="actions">
							<button type="button" onclick="startEdit('${vo.behavior_id}')">수정</button>
							<button type="button" onclick="goDelete('${vo.behavior_id}')">삭제</button>
						</td>
					</tr>

				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>