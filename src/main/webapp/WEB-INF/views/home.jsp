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
<P>   <a href="${ctp}/add/test" class="w3-bar-item w3-button">/add/test</a></P>
<P>   <a href="${ctp}/admin/test" class="w3-bar-item w3-button">/admin/test</a></P>
<P>   <a href="${ctp}/api/test" class="w3-bar-item w3-button">/api/test</a></P>
<P>   <a href="${ctp}/content/test" class="w3-bar-item w3-button">/content/test</a></P>
<P>   <a href="${ctp}/expert/test" class="w3-bar-item w3-button">/expert/test</a></P>
<P>   <a href="${ctp}/rec/test" class="w3-bar-item w3-button">/rec/test</a></P>
<P>   <a href="${ctp}/user/test" class="w3-bar-item w3-button">/user/test</a></P>
<P>   <a href="${ctp}/user/userInput" class="w3-bar-item w3-button">/user/userInput</a></P>
</body>
</html>
