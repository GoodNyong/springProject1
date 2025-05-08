<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>작성자 게시글 목록</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <style>
    a {text-decoration: none}
    a:hover {
      text-decoration: underline;
      color: orange;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<div class="container my-5" style="max-width: 900px;">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="fw-bold">${listTitle}</h4>
  </div>

  <!-- 게시글 목록 -->
  <div class="list-group">
    <c:if test="${empty vos}">
      <div class="text-center text-muted my-3">등록된 게시글이 없습니다.</div>
    </c:if>
    <c:forEach var="vo" items="${vos}">
      <a href="${ctp}/board/boardContent/${category}/${vo.board_id}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-start">
        <div class="ms-2 me-auto">
          <small class="text-muted">${vo.category}</small>
          <div class="fw-bold">${vo.title}
            <c:if test="${vo.comment_count > 0}">
              <span class="text-danger"> (${vo.comment_count})</span>
            </c:if>
          </div>
          <div class="text-muted small">
            ${vo.username}
            · <i class="bi bi-eye"></i> ${vo.read_count}
            · <i class="bi bi-hand-thumbs-up"></i> ${vo.like_count}
            · ${vo.formattedTime}
          </div>
        </div>
      </a>
    </c:forEach>
  </div>

  <!-- 블록 페이지 -->
  <div class="text-center mt-4">
    <ul class="pagination justify-content-center">
      <c:if test="${pageVo.pag > 1}">
        <li class="page-item"><a class="page-link" href="${ctp}/board/boardListByUser?user_id=${vo.user_id}&pag=1">처음</a></li>
      </c:if>
      <c:if test="${pageVo.curBlock > 0}">
        <li class="page-item"><a class="page-link" href="${ctp}/board/boardListByUser?user_id=${vo.user_id}&pag=${(pageVo.curBlock-1)*pageVo.blockSize+1}">이전</a></li>
      </c:if>
      <c:forEach var="i" begin="${(pageVo.curBlock*pageVo.blockSize)+1}" end="${(pageVo.curBlock*pageVo.blockSize)+pageVo.blockSize}">
        <c:if test="${i <= pageVo.totPage}">
          <li class="page-item ${i == pageVo.pag ? 'active' : ''}">
            <a class="page-link" href="${ctp}/board/boardListByUser?user_id=${vo.user_id}&pag=${i}">${i}</a>
          </li>
        </c:if>
      </c:forEach>
      <c:if test="${pageVo.curBlock < pageVo.lastBlock}">
        <li class="page-item"><a class="page-link" href="${ctp}/board/boardListByUser?user_id=${vo.user_id}&pag=${(pageVo.curBlock+1)*pageVo.blockSize+1}">다음</a></li>
      </c:if>
      <c:if test="${pageVo.pag < pageVo.totPage}">
        <li class="page-item"><a class="page-link" href="${ctp}/board/boardListByUser?user_id=${vo.user_id}&pag=${pageVo.totPage}">끝</a></li>
      </c:if>
    </ul>
  </div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>