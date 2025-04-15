<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!-- 공통 푸터 -->
<footer class="bg-dark text-white text-center py-4 mt-5">
  <div class="container">
    <div class="row">
      <!-- 브랜드 및 팀 정보 -->
      <div class="col-md-4 mb-3 mb-md-0">
        <h5 class="fw-bold text-info">Blinkos</h5>
        <small>데이터 기반 건강 루틴 관리 플랫폼</small>
      </div>

      <!-- 링크 섹션 -->
      <div class="col-md-4 mb-3 mb-md-0">
        <ul class="list-unstyled">
          <li><a href="${pageContext.request.contextPath}/" class="text-white text-decoration-none">홈</a></li>
          <li><a href="${pageContext.request.contextPath}/content/list" class="text-white text-decoration-none">콘텐츠</a></li>
          <li><a href="${pageContext.request.contextPath}/user/signup" class="text-white text-decoration-none">회원가입</a></li>
        </ul>
      </div>

      <!-- 연락처 정보 -->
      <div class="col-md-4">
        <small>📧 contact@blinkos.health</small><br>
        <small>© 2025 Blinkos Team. All rights reserved.</small>
      </div>
    </div>
  </div>
</footer>