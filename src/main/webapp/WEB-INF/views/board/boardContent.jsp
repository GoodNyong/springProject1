<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
pageContext.setAttribute("newLine", "\n");
%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>boardContent.jsp</title>
<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
<jsp:include page="/WEB-INF/views/include/reportModal.jsp" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    'use strict';
    
    function updateBoardLike(board_id) {
      $.ajax({
        url: '${ctp}/board/updateBoardLike',
        type: 'POST',
        data: { board_id: board_id },
        success: function(res) {
          if (res === 'updateLikeOk') {
            location.reload();
          } else if (res === 'nologin') {
            alert('로그인이 필요합니다.');
            location.href = '${ctp}/user/userLogin';
          }
        },
        error : function() { alert("전송오류!"); }
      });
    }
    function openReportModal() {
      const modal = new bootstrap.Modal(document.getElementById('reportModal'));
      modal.show();
    }
    
//     // 모달창에서 신고항목 선택후 '확인'버튼 클릭시 수행처리
//     function reportCheck(board_id) {
//     	if(!$("input[type=radio][name=report]:checked").is(':checked')) {
//     		alert("신고항목을 선택하세요");
//     		return false;
//     	}
//     	if($("input[type=radio]:checked").val() == '기타' && $("#reportText").val() == '') {
//     		alert("기타 사유를 입력해 주세요");
//     		return false;
//     	}
    	
//     	let reportContent = modalForm.report.value;
//     	if(reportContent == '기타') reportContent += '/' + $("#reportText").val();
    	
//     	let query = {
//     			part   : 'board',
//     			partIdx: ${vo.board_id},
//     			cpMid  : '${sMid}',
//     			cpContent: claimContent
//     	}
    	 
//     	$.ajax({
//     		url  : "boardReportInput",
//     		type : "post",
//     		data : query,
//     		success:function(res) {
//     			if(res != "0") {
//     				alert("신고 되었습니다.");
//     				location.reload();
//     			}
//     			else alert("신고 실패~~");
//     		},
//     		error : function() { alert("전송오류!"); }
//     	});
//     }	
    	
    function commentCheck() {
      let content = $('#commentContent').val().trim();
      if (content === '') {
        alert('댓글을 입력하세요.');
        $("#commentContent").focus();
        return false;
      }
    
      $.ajax({
        url: '${ctp}/board/commentInput',
        type: 'POST',
        data: {
        	board_id : '${vo.board_id}',
        	content : content
        },
        success: function(res) {
          if (res === 'setCommentOk') {
            alert('댓글이 등록되었습니다.');
            location.reload();
          } else if (res === 'nologin') {
            alert('로그인이 필요합니다.');
            location.href = '${ctp}/user/userLogin';
          } else { alert('댓글 등록 실패'); }
        },
        error: function() {
          alert('전송 실패!');
        }
      });
    }
    function openReplyForm(comment_id) {
    	  $('#replyForm' + comment_id).toggle();
    	}

    function replyCheck(comment_id) {
  	  const content = $('#replyContent' + comment_id).val().trim();
  	  if (content === '') {
  	    alert('답글을 입력하세요.');
  	    return;
  	  }

  	  $.ajax({
  	    url: '${ctp}/board/replyInput',
  	    type: 'POST',
  	    data: {
  	      comment_id: comment_id,
  	      content: content
  	    },
  	    success: function(res) {
  	      if (res === 'success') {
  	        alert('답글이 등록되었습니다.');
  	        loadReplies(comment_id); // 답글 다시 로드
  	        $('#replyContent' + comment_id).val('');
  	        $('#replyForm' + comment_id).hide();
  	      } else {
  	        alert('답글 등록 실패');
  	      }
  	    },
  	    error: function() {
  	      alert('전송 오류');
  	    }
  	  });
  	}   	

//     	function loadReplies(comment_id) {
//     	  $.ajax({
//     	    url: '${ctp}/board/getReplies',
//     	    type: 'GET',
//     	    data: { comment_id: comment_id },
//     	    success: function(replies) {
//     	      let replyHtml = '';

//     	      if (replies.length === 0) {
//     	        replyHtml = '<div class="text-muted">등록된 답글이 없습니다.</div>';
//     	      } else {
//     	        replies.forEach(function(reply) {
//     	          replyHtml += `
//     	            <div class="border-start ps-3 mb-2">
//     	              <div><strong>${reply.nickname}</strong> : ${reply.content}</div>
//     	              <div class="text-muted small">${reply.createdAt}</div>
//     	            </div>
//     	          `;
//     	        });
//     	      }

//     	      $('#replyArea' + comment_id).html(replyHtml);
//     	    },
//     	    error: function() {
//     	      alert('답글 불러오기 오류');
//     	    }
//     	  });
//     	}
    function scrollToTop() {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
    function scrollToBottom() {
      window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
    }
    function goBoardList() {
      location.href = '${ctp}/board/boardList?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}';
    }
    function goPreviousBoard() {
      history.back();
    }
    function goNextBoard() {
      // 다음글 이동
    }
    function focusCommentWrite() {
      document.getElementById('commentContent').focus();
    }
</script>
</head>

<body>
  <jsp:include page="/WEB-INF/views/include/navbar.jsp" />
  <p><br/></p>
  <div class="container mt-4">
    <div style="color: #3498db;">${vo.category}게시판</div>

    <div style="font-size: 24px; font-weight: bold;">${vo.title}
      <small class="text-muted">(${vo.comment_count})</small>
    </div>

    <div style="background: #f8f9fa; padding: 8px; font-size: 14px; color: #6c757d; margin-bottom: 20px;">
      ${vo.username} | ${vo.created_at} | ${vo.read_count}
      <c:if test="${not empty vo.updated_at}">
        <small class="text-muted">수정: ${vo.updated_at}</small>
      </c:if>
    </div>

    <div style="font-size: 16px; margin-bottom: 30px;">${vo.content}</div>

    <div class="d-flex gap-2 mb-4">
      <c:if test="${sessionScope.sUser_id eq vo.user_id}">
        <a href="${ctp}/board/boardUpdateForm?board_id=${vo.board_id}" class="btn btn-outline-success btn-sm">수정</a>
        <a href="${ctp}/board/boardDelete?board_id=${vo.board_id}" class="btn btn-outline-danger btn-sm">삭제</a>
      </c:if>
      <c:if test="${sessionScope.sRole_id eq 1}">
        <a href="${ctp}/board/boardDelete?board_id=${vo.board_id}" class="btn btn-outline-danger btn-sm">삭제(관리자)</a>
      </c:if>
      <button onclick="openReportModal(${vo.board_id}, '', )"class="btn btn-outline-secondary btn-sm">신고</button>
    </div>

    <div class="text-center my-4">
      <div id="likeIcon" onclick="updateBoardLike(${vo.board_id})"
        style="font-size: 32px; cursor: pointer;">
        <c:choose>
          <c:when test="${isLiked}">
          ❤
          </c:when>
          <c:otherwise>
          ❤
          </c:otherwise>
        </c:choose>
      </div>
      <div id="likeCount" style="font-size: 14px; margin-top: 5px;">${vo.like_count}</div>
    </div>

    <div class="d-flex justify-content-between align-items-center mt-5">
      <c:choose>
        <c:when test="${not empty previousBoard}">
          <a href="${ctp}/board/boardContent?board_id=${previousBoard.board_id}"
            class="btn btn-outline-secondary btn-sm">◀ 이전글</a>
        </c:when>
        <c:otherwise>
          <button class="btn btn-outline-secondary btn-sm" disabled>이전글 없음</button>
        </c:otherwise>
      </c:choose>

      <a href="${ctp}/board/boardList?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}"
        class="btn btn-outline-dark btn-sm">목록</a>

      <c:choose>
        <c:when test="${not empty nextBoard}">
          <a href="${ctp}/board/boardContent?board_id=${nextBoard.board_id}"
            class="btn btn-outline-secondary btn-sm">다음글 ▶</a>
        </c:when>
        <c:otherwise>
          <button class="btn btn-outline-secondary btn-sm" disabled>다음글 없음</button>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="mt-5">
      <textarea id="commentContent" class="form-control" rows="3" placeholder="댓글을 입력하세요" ></textarea>
      <button onclick="commentCheck()" class="btn btn-primary btn-sm">댓글 등록</button>
    </div>

    <div class="mt-4" id="commentList">
      <c:if test="${empty commentVos}">
        <div class="text-center text-muted my-3">등록된 댓글이 없습니다.</div>
      </c:if>

      <c:forEach var="commentVo" items="${commentVos}">
        <div class="border rounded p-3 mb-3">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <strong>${commentVo.username}</strong>
              <span class="text-muted small ms-2">${commentVo.created_at}</span>
            </div>
            <div class="text-muted small">
              👍: ${commentVo.like_count}
            </div>
          </div>
    
          <div class="mt-2">
            ${commentVo.content}
          </div>
    
          <div class="mt-2">
            <button class="btn btn-outline-primary btn-sm me-2"
              onclick="openReplyForm(${commentVo.comment_id})">
              답글 쓰기
            </button>
    
            <button class="btn btn-outline-secondary btn-sm"
              onclick="openReplyList(${commentVo.comment_id})">
              답글 보기
            </button>
            
            <c:choose>
              <c:when test="${sessionScope.sUser_id eq commentVo.user_id}">
                <button class="btn btn-outline-danger btn-sm" onclick="deleteComment(${commentVo.comment_id})">
                  삭제
                </button>
              </c:when>
              <c:otherwise>
                <button class="btn btn-outline-danger btn-sm" onclick="openReportModal('comment', ${commentVo.comment_id})">
                  신고
                </button>
              </c:otherwise>
            </c:choose>
          </div>
    
          <!-- 답글이 표시될 영역 -->
          <div id="replyList${commentVo.comment_id}" class="ms-4 mt-3"></div>
    
          <!-- 답글 작성 폼 (숨김처리, 답글쓰기 누르면 보이게) -->
          <div id="replyForm${commentVo.comment_id}" class="mt-3" style="display:none;">
            <textarea id="replyContent${commentVo.comment_id}" class="form-control mb-2" rows="2" placeholder="답글을 입력하세요"></textarea>
            <button value="확인" class="btn btn-success btn-sm" onclick="replyCheck(${commentVo.comment_id})"></button>
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- 고정 버튼 -->
    <div class="d-none d-md-flex flex-column align-items-center gap-2" style="position:fixed; top:30%; right:30px;">
      <button onclick="focusCommentWrite()" class="btn btn-light border">💬</button>
      <button onclick="goBoardList()" class="btn btn-light border">ℹ</button>
      <button onclick="goPreviousBoard()" class="btn btn-light border">◀</button>
      <button onclick="goNextBoard()" class="btn btn-light border">▶</button>
      <button onclick="scrollToBottom()" class="btn btn-light border">⏬</button>
      <button onclick="scrollToTop()" class="btn btn-light border">⏫</button>
    </div>
  
  </div>
  <p><br /></p>
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>