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
</head>
<body>
<div class="container">
	<h2>test</h2>
	<span><a href="${ctp }">홈으로</a></span>
</div>
</body>
</html>