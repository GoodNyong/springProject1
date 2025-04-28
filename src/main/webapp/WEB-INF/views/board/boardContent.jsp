<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>boardContent.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp"/>
<script>
    function likeComment(commentId) {
      // AJAX 좋아요 기능
    }
    function showReplyForm(commentId) {
      document.getElementById('replyForm' + commentId).classList.toggle('d-none');
    }
    function submitReply(commentId) {
      // AJAX 대댓글 등록 기능
    }
    function reportComment(commentId) {
      // 댓글 신고 모달 열기
    }
    function reportReply(replyId) {
      // 대댓글 신고 모달 열기
    }
    function submitComment() {
      // AJAX 댓글 등록 기능
    }
    function submitReport() {
      // AJAX 신고 기능
    }
</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />
<p><br/><p>
<div class="container mt-4">
  <div class="card">
    <div class="card-header">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <strong>${boardVo.title}</strong>
        </div>
        <div class="text-muted">
          조회수: ${boardVo.view_count}
        </div>
      </div>
    </div>

    <div class="card-body">

      <div class="mb-3 text-muted">
        작성자: ${boardVo.username} | 작성일: ${boardVo.created_at} | IP: ${boardVo.host_ip}
      </div>

      <div class="mt-4 mb-4">
        ${boardVo.content}
      </div>

      <div class="d-flex align-items-center">
        <button id="likeButton" class="btn btn-outline-primary me-2" onclick="toggleLike(${boardVo.board_id})" style="font-size: 24px; transition: transform 0.2s;">
          <span id="likeIcon">
            <c:choose>
              <c:when test="${userLiked}">
                👍🏻 <!-- 채워진 엄지 -->
              </c:when>
              <c:otherwise>
                👍 <!-- 비워진 엄지 -->
              </c:otherwise>
            </c:choose>
          </span> <span id="likeButtonText">
            <c:choose>
              <c:when test="${userLiked}">
                좋아요 취소
              </c:when>
              <c:otherwise>
                좋아요
              </c:otherwise>
            </c:choose>
          </span> (<span id="likeCount">${boardVo.like_count}</span>)
        </button>

        <button id="reportButton" class="btn btn-outline-danger" onclick="openReportModal(${boardVo.board_id})">
          신고
        </button>
      </div>

      <div class="mt-4">
        <a href="/board/boardList" class="btn btn-secondary">목록으로</a>
      </div>

      <!-- 이전글/다음글 이동 -->
      <div class="mt-5">
        <c:if test="${not empty previousBoard}">
          <div>이전글: <a href="/board/boardContent?board_id=${previousBoard.board_id}">${previousBoard.title}</a></div>
        </c:if>
        <c:if test="${not empty nextBoard}">
          <div>다음글: <a href="/board/boardContent?board_id=${nextBoard.board_id}">${nextBoard.title}</a></div>
        </c:if>
      </div>

    </div>
  </div>

  <!-- 댓글/대댓글 영역 -->
  <div class="mt-5">
    <h5>댓글</h5>

    <c:forEach var="comment" items="${commentList}">
      <div class="border-bottom py-2">
        <div class="d-flex justify-content-between">
          <div>
            <strong>${comment.username}</strong>
            <small class="text-muted">${comment.created_at}</small>
          </div>
          <div>
            <c:if test="${comment.is_deleted == 0}">
              <button class="btn btn-sm btn-outline-primary" onclick="likeComment(${comment.comment_id})">좋아요 (<span id="commentLikeCount${comment.comment_id}">${comment.like_count}</span>)</button>
              <button class="btn btn-sm btn-outline-secondary" onclick="showReplyForm(${comment.comment_id})">답글</button>
              <button class="btn btn-sm btn-outline-danger" onclick="reportComment(${comment.comment_id})">신고</button>
            </c:if>
          </div>
        </div>

        <div class="mt-2">
          <c:choose>
            <c:when test="${comment.is_deleted == 1}">
              <span class="text-muted">삭제된 댓글입니다.</span>
            </c:when>
            <c:otherwise>
              ${comment.content}
            </c:otherwise>
          </c:choose>
        </div>

        <!-- 대댓글 리스트 -->
        <c:forEach var="reply" items="${comment.replyList}">
          <div class="ms-4 mt-2 p-2 border-start">
            <div class="d-flex justify-content-between">
              <div>
                <strong>${reply.username}</strong> 
                <small class="text-muted">${reply.created_at}</small>
              </div>
              <div>
                <c:if test="${reply.is_deleted == 0}">
                  <button class="btn btn-sm btn-outline-danger" onclick="reportReply(${reply.reply_id})">신고</button>
                </c:if>
              </div>
            </div>

            <div class="mt-1">
              <c:choose>
                <c:when test="${reply.is_deleted == 1}">
                  <span class="text-muted">삭제된 답글입니다.</span>
                </c:when>
                <c:otherwise>
                  ${reply.content}
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </c:forEach>

        <!-- 대댓글 입력 폼 -->
        <div id="replyForm${comment.comment_id}" class="d-none mt-2 ms-4">
          <textarea class="form-control mb-2" id="replyContent${comment.comment_id}" rows="2" placeholder="답글을 입력하세요"></textarea>
          <button class="btn btn-sm btn-primary" onclick="submitReply(${comment.comment_id})">등록</button>
        </div>
      </div>
    </c:forEach>

    <!-- 댓글 입력 폼 -->
    <div class="mt-4">
      <textarea class="form-control mb-2" id="commentContent" rows="3" placeholder="댓글을 입력하세요"></textarea>
      <button class="btn btn-primary" onclick="submitComment()">댓글 등록</button>
    </div>
  </div>
</div>

<!-- 신고 모달 -->
<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="reportModalLabel">신고하기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <select id="reportReason" class="form-select mb-3">
          <option value="욕설/비방">욕설/비방</option>
          <option value="홍보/광고">홍보/광고</option>
          <option value="개인정보노출">개인정보노출</option>
          <option value="기타">기타</option>
        </select>
        <textarea class="form-control" id="reportDetail" rows="3" placeholder="신고 내용을 입력하세요"></textarea>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" onclick="submitReport()">신고하기</button>
      </div>
    </div>
  </div>
</div>

<p><br/><p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>