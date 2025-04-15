<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath }" />
<% pageContext.setAttribute("newLine", "\n"); %>
<% pageContext.setAttribute("CRLF", "\r\n"); %>
<% pageContext.setAttribute("LF", "\n"); %>


<!-- ✅ 공통 HTML 헤더 영역 -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Blinkos는 건강한 루틴을 마법처럼 구성해주는 플랫폼입니다.">
<meta property="og:title" content="Blinkos - 건강을 마법처럼!" />
<title>${title != null ? title : 'Blinkos - 건강을 마법처럼!'}</title>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>

<!-- ✅ Bootstrap 5 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- ✅ Blinkos 전용 스타일 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/blinkos-style.css">

<!-- ✅ 파비콘 -->
<link rel="icon" href="${pageContext.request.contextPath}/resources/img/favicon.png" type="image/png">

<!-- ✅ Sticky Footer 관련 스타일 -->
<style>
  html, body {
    height: 100%;
  }
  body {
    display: flex;
    flex-direction: column;
  }
  main {
    flex: 1;
  }
</style>