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
<p><br/></p>
<div class="container">
  <h2>📌 게시판 - ${category}</h2>
  <table>
    <tr>
      <td><a href="${ctp}/board/boardInput" class="btn btn-success btn-sm">글쓰기</a></td>
        <!-- 카테고리 선택 -->
        <td>
          <a href="/board/boardList/all">전체</a>
          <a href="/board/boardList/free">자유</a>
          <a href="/board/boardList/exercise">운동</a>
          <a href="/board/boardList/meal">식단</a>
        </td>

        <!-- 페이지사이즈 선택 -->
       <td>
         <label for="pageSize">페이지 사이즈:</label>
           <select name="pageSize" id="pageSize" onchange="changePageSize()">
             <option ${pageVo.pageSize==5  ? 'selected' : ''}>5</option>
             <option ${pageVo.pageSize==10 ? 'selected' : ''}>10</option>
             <option ${pageVo.pageSize==15 ? 'selected' : ''}>15</option>
             <option ${pageVo.pageSize==20 ? 'selected' : ''}>20</option>
             <option ${pageVo.pageSize==30 ? 'selected' : ''}>30</option>
           </select>	        
       </td>
    <tr>
  </table>

  <!-- 게시글 목록 -->
  <c:forEach var="vo" items="${boardList}">
    <div>
      <!-- 작성자: 클릭 시 해당 작성자 글 목록 -->
      <a href="/board/user/${vo.username}">${vo.username}</a> |
  
      <!-- 제목: 해당 글 보기 (댓글 수 포함) -->
      <a href="${ctp}/board/boardContent?board_id=${vo.board_id}">
        ${vo.title}
        <c:if test="${vo.comment_count > 0}">(${vo.comment_count})</c:if>
      </a> |
  
      <!-- 조회수: 클릭 불가 -->
      조회수 ${vo.read_count} |
  
      <!-- 좋아요: 클릭 불가 -->
      좋아요 ${vo.like_count}
      
      <!-- 작성일 -->
      <span>${vo.formattedTime}</span>
    </div>
  </c:forEach>

  <!-- 블록 페이지 (기본 구조 유지, 꾸밈 제거) -->
  <div>
    <ul>
      <c:if test="${pageVo.pag > 1}">
        <li><a href="boardList?pag=1&pageSize=${pageVo.pageSize}">첫페이지</a></li>
      </c:if>
  
      <c:if test="${pageVo.curBlock > 0}">
        <li><a href="boardList?pag=${(pageVo.curBlock-1)*pageVo.blockSize+1}&pageSize=${pageVo.pageSize}">이전블록</a></li>
      </c:if>
  
      <c:forEach var="i" begin="${(pageVo.curBlock*pageVo.blockSize)+1}" end="${(pageVo.curBlock*pageVo.blockSize)+pageVo.blockSize}">
        <c:if test="${i <= pageVo.totPage}">
          <li>
            <c:choose>
              <c:when test="${i == pageVo.pag}">
                <strong>${i}</strong>
              </c:when>
              <c:otherwise>
                <a href="boardList?pag=${i}&pageSize=${pageVo.pageSize}">${i}</a>
              </c:otherwise>
            </c:choose>
          </li>
        </c:if>
      </c:forEach>
  
      <c:if test="${pageVo.curBlock < pageVo.lastBlock}">
        <li><a href="boardList?pag=${(pageVo.curBlock+1)*pageVo.blockSize+1}&pageSize=${pageVo.pageSize}">다음블록</a></li>
      </c:if>
  
      <c:if test="${pageVo.pag < pageVo.totPage}">
        <li><a href="boardList?pag=${pageVo.totPage}&pageSize=${pageVo.pageSize}">마지막페이지</a></li>
      </c:if>
    </ul>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>