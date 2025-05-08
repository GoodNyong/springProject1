<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>boardList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
<script>
	'user strict'
	
    function changePageSize() {
    	let pageSize = document.getElementById("pageSize").value;
    	location.href = "${ctp}/board/boardList/${category}?pageSize=" + pageSize;
    }
</script>
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
    <h4 class="fw-bold">📌 게시판 - ${category}</h4>
    <a href="${ctp}/board/boardInput" class="btn btn-sm btn-primary">글쓰기</a>
  </div>

  <!-- 카테고리 및 페이지 사이즈 선택 -->
  <div class="d-flex justify-content-between align-items-center mb-3">
    <div>
      <a href="${ctp}/board/boardList/all" class="btn btn-outline-secondary btn-sm me-1">전체</a>
      <a href="${ctp}/board/boardList/free" class="btn btn-outline-secondary btn-sm me-1">자유</a>
      <a href="${ctp}/board/boardList/exercise" class="btn btn-outline-secondary btn-sm me-1">운동</a>
      <a href="${ctp}/board/boardList/meal" class="btn btn-outline-secondary btn-sm">식단</a>
    </div>
    <div class="d-flex align-items-center">
      <label for="pageSize" class="me-2 mb-0">페이지 사이즈</label>
      <select id="pageSize" class="form-select form-select-sm" style="width:auto;" onchange="changePageSize()">
        <option ${pageVo.pageSize==5  ? 'selected' : ''}>5</option>
        <option ${pageVo.pageSize==10 ? 'selected' : ''}>10</option>
        <option ${pageVo.pageSize==15 ? 'selected' : ''}>15</option>
        <option ${pageVo.pageSize==20 ? 'selected' : ''}>20</option>
        <option ${pageVo.pageSize==30 ? 'selected' : ''}>30</option>
      </select>
    </div>
  </div>

  <!-- 게시글 목록 -->
  <div class="list-group">
    <c:forEach var="vo" items="${vos}">
      <a href="${ctp}/board/boardContent/${category}/${vo.board_id}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-start">
        <div class="ms-2 me-auto">
          <small class="text-muted">${vo.category}</small>
          <div class="fw-bold">${vo.title}
            <c:if test="${vo.comment_count > 0}"><span class="text-danger"> (${vo.comment_count})</span></c:if>
          </div>
          <small class="text-muted">
            ${vo.username} ·
            <i class="bi bi-eye"></i> ${vo.read_count} ·
            <i class="bi bi-hand-thumbs-up"></i> ${vo.like_count} ·
            ${vo.formattedTime}
          </small>
        </div>
      </a>
    </c:forEach>
  </div>

  <!-- 블록 페이지 -->
  <div class="text-center mt-4">
    <ul class="pagination justify-content-center">
      <c:if test="${pageVo.pag > 1}">
        <li class="page-item"><a class="page-link" href="${ctp}/board/boardList/${category}?pag=1&pageSize=${pageVo.pageSize}">처음</a></li>
      </c:if>
      <c:if test="${pageVo.curBlock > 0}">
        <li class="page-item"><a class="page-link" href="${ctp}/board/boardList/${category}?pag=${(curBlock-1)*blockSize+1}&pageSize=${pageVo.pageSize}">이전</a></li>
      </c:if>
      <c:forEach var="i" begin="${(pageVo.curBlock*pageVo.blockSize)+1}" end="${(pageVo.curBlock*pageVo.blockSize)+pageVo.blockSize}">
        <c:if test="${i <= pageVo.totPage}">
          <li class="page-item ${i == pageVo.pag ? 'active' : ''}">
            <a class="page-link" href="${ctp}/board/boardList/${category}?pag=${i}&pageSize=${pageVo.pageSize}">${i}</a>
          </li>
        </c:if>
      </c:forEach>
      <c:if test="${pageVo.curBlock < pageVo.lastBlock}">
        <li class="page-item"><a class="page-link" href="${ctp}/board/boardList/${category}?pag=${(pageVo.curBlock+1)*pageVo.blockSize+1}&pageSize=${pageVo.pageSize}">다음</a></li>
      </c:if>
      <c:if test="${pageVo.pag < pageVo.totPage}">
        <li class="page-item"><a class="page-link" href="${ctp}/board/boardList/${category}?pag=${pageVo.totPage}&pageSize=${pageVo.pageSize}">끝</a></li>
      </c:if>
    </ul>
  </div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>