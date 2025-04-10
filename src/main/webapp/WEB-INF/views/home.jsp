<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
	Hello world!  
</h1>

<P>  The time on the server is ${serverTime}. </P>
<P>   <a href="${ctp}/data/test" class="w3-bar-item w3-button">/data/test</a></P>
<p>안녕!!!</p>
<p>안녕!!!</p>
<p>안녕!!!</p>
</body>
</html>
