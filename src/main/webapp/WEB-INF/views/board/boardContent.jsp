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
    
    let sUser_id = '${sessionScope.loginUser}';
    let ctp = '${ctp}';
    let board_id = ${vo.board_id}
    
    
    $(function(){
      $(".baseReply").hide();
    });
    
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
    
    function updateCommentLike(comment_id) {
        $.ajax({
          url: '${ctp}/board/updateCommentLike',
          type: 'POST',
          data: {
            comment_id : comment_id 
            },
          success: function(res) {
            if (res === 'updateCommentLikeOk') {
              $('#commentlikeCount' + comment_id).text(parseInt($('#likeCount' + comment_id).text()) + 1);
              $('#commentlikeIcon' + comment_id).addClass("text-primary");
              location.reload();
            } else if (res === 'nologin') {
              alert('로그인이 필요합니다.');
              location.href = '${ctp}/user/userLogin';
            } else if (res === 'alreadyCommentLike'){
              alert('이미 좋아요를 누르셨습니다.')
            }else{
              alert('댓글 좋아요 실패');
            }
          },
          error : function() { alert("전송오류!"); }
        });
    }
    
    function openReportModal(part, comment_id, reply_id) {
      console.log(part, comment_id, reply_id);
      $("#modalPart").val(part);
      $("#modalCommentId").val(comment_id);
      $("#modalReplyId").val(reply_id);
      let modal = new bootstrap.Modal(document.getElementById('reportModal'));
      modal.show();
    }
    
    function reportCheck(part, comment_id, reply_id) {
      if(!$("input[type=radio][name=reportReason]:checked").is(':checked')) {
        alert("신고항목을 선택하세요");
        return false;
      }

      if($("input[type=radio]:checked").val() == '기타' && $("#reportText").val().trim() == '') {
        alert("기타 사유를 입력해 주세요");
        return false;
      }

      let reportReason = modalForm.reportReason.value;
      if(reportReason === '기타') reportReason += '/' + $("#reportText").val();

      let query = {
          board_id: '${vo.board_id}',
          part: $("#modalPart").val(),
          comment_id: $("#modalCommentId").val(),
          reply_id: $("#modalReplyId").val(),
          reason: reportReason
        };

      $.ajax({
        url: '${ctp}/board/reportInput',
        type: 'POST',
        data: query,
        success: function(res) {
          console.log(query);
          if(res === 'setReportOk') {
            alert('신고가 접수되었습니다.');
            location.reload();
          } else if (res === 'nologin') {
              alert('로그인이 필요합니다.');
              location.href = '${ctp}/user/userLogin';
          } else {
            alert('신고 실패');
          }
        },
        error: function() {
          alert('전송 실패!');
        }
      });
    }       
      
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
        $("#replyContent" + comment_id).focus();
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
          if (res === 'setReplyOk') {
            alert('답글이 등록되었습니다.');
            loadReplyList(comment_id); // 답글 다시 로드
            $('#replyContent' + comment_id).val('');
            $('#replyForm' + comment_id).hide();
          } else if (res === 'nologin') {
            alert('로그인이 필요합니다.');
            location.href = '${ctp}/user/userLogin';
          } else { alert('답글 등록 실패'); }
        },
        error: function() {
          alert('전송 실패!');
        }
      });
    }
    
    function openReplyList(comment_id) {
      let replyListArea = $('#replyListArea' + comment_id);
    
      if (replyListArea.is(':visible')) {
        replyListArea.hide(); // 열려있으면 닫기
        $('#replyForm' + comment_id).hide();
      } else {
        replyListArea.show(); // 닫혀있으면 보여주기
        openReplyForm(comment_id);
        loadReplyList(comment_id); // ajax로 내용 로드
      }
    }

    function loadReplyList(comment_id) {
        $.ajax({
          url: '${ctp}/board/replyload',
          type: 'GET',
          data: { comment_id: comment_id },
          success: function(replyVos) {
            console.log(replyVos);
            let html = '';
            if (replyVos.length === 0) {
              html = '<div class="text-muted small">등록된 답글이 없습니다.</div>';
            } else {
            	replyVos.forEach(replyVo => {
            		  html += '<div class="border-start ps-3 mb-2">';
            		  html += '<strong>' + replyVo.username + '</strong> : ' + replyVo.content;
            		  html += '<div class="text-muted small">' + replyVo.formattedTime + '</div>';

            		  if (sUser_id === String(replyVo.user_id)) {
            		    html += '<form id="deleteReplyForm" action="' + ctp + '/board/boardDelete" method="post">';
            		    html += '<input type="hidden" name="board_id" value="' + board_id + '" />';
            		    html += '<input type="hidden" name="reply_id" value="' + replyVo.reply_id + '" />';
            		    html += '<input type="hidden" name="part" value="boardReply">';
            		    html += '<input type="hidden" name="category" value="${category}">';
            		    html += '<input type="button" value="삭제" onclick="boardDeleteCheck(\'reply\')" class="btn btn-outline-danger btn-sm" />';
            		    html += '</form>';
            		  } else {
            		    html += '<button class="btn btn-outline-danger btn-sm" onclick="openReportModal(\'boardReply\', ' + replyVo.comment_id + ', ' + replyVo.reply_id + ')">신고</button>';
            		  }

            		  html += '</div>';
            		});
/*               replyVos.forEach(replyVo => {
                html += '<div class="border-start ps-3 mb-2">';
                html += '<strong>'+replyVo.username+'</strong> : '+replyVo.content;
                html += '<div class="text-muted small">'+replyVo.formattedTime+'</div>';
                html += '<button class="btn btn-outline-danger btn-sm" onclick="openReportModal(\'boardReply\', ' + replyVo.comment_id + ', ' + replyVo.reply_id + ')">신고</button>';
                html += '<form id="deleteForm" action="${ctp}/board/boardDelete" method="post">'
                html += '<input type="hidden" name="board_id" value="${vo.board_id}" />'
                html += '<input type="hidden" name="part" value="boardContent">'
                html += '<input type="button" value="삭제" onclick="boardDeleteCheck()" class="btn btn-outline-danger btn-sm" />'
                html += '</form>'
                html += '</div>';
              }); */
            }
            $('#replyListArea' + comment_id).html(html);
            $('#reply_count'+comment_id).html(replyVos.length);
          },
          error: function() {
            alert('전송 오류!');
          }
       });
    }
    
    function boardDeleteCheck(type) {
    	if (confirm("정말 삭제하시겠습니까?")) {
    	    let formId = '';
    	    if (type === 'reply') {
    	      formId = 'deleteReplyForm';
    	    } else if (type === 'comment') {
    	      formId = 'deleteCommentForm';
    	    } else {
    	      formId = 'deleteContentForm';
    	    }
    	    document.getElementById(formId).submit();
    	  }    	
    }
    //이렇게 가면 왜 get요청이 되고 밑에서 jsp로 <a href= ..> 으로 하면 안되지?
    
    //$(window).scroll(function(){
    $(function(){
      /* if($(this).scrollTop() > 100) {
        $("#topBtn").addClass("on");
      }
      else {
        $("#topBtn").removeClass("on");
      } */
      
      $("#topBtn").click(function(){
        window.scrollTo({top:0, behavior: "smooth"});
      });
      
      $("#bottomBtn").click(function(){
          window.scrollTo({top:5000, behavior: "smooth"});
      });
    });
    /*
    $(window).scroll(function(){
      if($(this).scrollBottom() < 100) {
        $("#bottomBtn").addClass("on");
      }
      else {
        $("#bottomBtn").removeClass("on");
      }
      
      $("#bottomBtn").click(function(){
        window.scrollTo({top:5000, behavior: "smooth"});
      });
    });
    */
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
      <a href="${ctp}/board/boardListByUser/${vo.user_id}">${vo.username}</a> | ${vo.formattedTime} | ${vo.read_count}
      <c:if test="${not empty vo.updated_at}">
        <small class="text-muted">수정: ${vo.updated_at}</small>
      </c:if>
    </div>

    <div style="font-size: 16px; margin-bottom: 30px;">${vo.content}</div>

    <div class="d-flex gap-2 mb-4">
      <c:if test="${sessionScope.loginUser eq vo.user_id}">
        <a href="${ctp}/board/boardUpdateForm?board_id=${vo.board_id}" class="btn btn-outline-success btn-sm">수정</a>
        <form id="deleteContentForm" action="${ctp}/board/boardDelete" method="post">
          <input type="hidden" name="board_id" value="${vo.board_id}" />
          <input type="hidden" name="part" value="boardContent">
          <input type="hidden" name="category" value="${category}">
          <input type="button" value="삭제" onclick="boardDeleteCheck('content')" class="btn btn-outline-danger btn-sm" />
        </form>
      </c:if>
      <c:if test="${sessionScope.sRole_id eq 1}">
        <a href="${ctp}/board/boardDelete?board_id=${vo.board_id}" class="btn btn-outline-danger btn-sm">삭제(관리자)</a>
      </c:if>
      <button onclick="openReportModal('boardContent', '', '')"class="btn btn-outline-secondary btn-sm">신고</button>
    </div>

    <div class="text-center my-4">
      <div id="likeIcon" onclick="updateBoardLike(${vo.board_id})"
        style="font-size: 32px; cursor: pointer;">
        <c:choose>
          <c:when test="${isLiked}">
          ❤
          </c:when>
          <c:otherwise>
          🤍
          </c:otherwise>
        </c:choose>
      </div>
      <div id="likeCount" style="font-size: 14px; margin-top: 5px;">${vo.like_count}</div>
    </div>

    <div class="d-flex justify-content-between align-items-center mt-5">
      <c:choose>
        <c:when test="${not empty preVo}">
          <a href="${ctp}/board/boardContent/${category}/${preVo.board_id}"
            class="btn btn-outline-secondary btn-sm">◀ 이전글</a>
        </c:when>
        <c:otherwise>
          <button class="btn btn-outline-secondary btn-sm" disabled>이전글 없음</button>
        </c:otherwise>
      </c:choose>

      <a href="${ctp}/board/boardList/${category}?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}"
        class="btn btn-outline-dark btn-sm">목록</a>

      <c:choose>
        <c:when test="${not empty nextVo}">
          <a href="${ctp}/board/boardContent/${category}/${nextVo.board_id}"
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
              <span class="text-muted small ms-2">${commentVo.formattedTime}</span>
            </div>
            <div>
              <c:choose>
                <c:when test="${sessionScope.sUser_id eq commentVo.user_id}">
                  <span id="commentLikeIcon${commentVo.comment_id}">👍</span>
                  <span id="commentLikeCount${commentVo.comment_id}">${commentVo.like_count}</span>
                </c:when>
                <c:otherwise>
                  <button type="button" class="btn btn-sm btn-outline-primary"
                          onclick="updateCommentLike(${commentVo.comment_id})">
                     <span id="commentLikeIcon${commentVo.comment_id}">👍</span>
                     <span id="commentLikeCount${commentVo.comment_id}">${commentVo.like_count}</span>
                  </button>
                </c:otherwise>
              </c:choose>
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
              답글 [<span id="reply_count${commentVo.comment_id}">${commentVo.reply_count}</span>]
            </button>
            
            <c:choose>
              <c:when test="${sessionScope.sUser_id eq commentVo.user_id}">
                <form id="deleteCommentForm" action="${ctp}/board/boardDelete" method="post">
                  <input type="hidden" name="board_id" value="${vo.board_id}" />
                  <input type="hidden" name="comment_id" value="${commentVo.comment_id}" />
                  <input type="hidden" name="part" value="boardComment">
                  <input type="hidden" name="category" value="${category}">
                  <input type="button" value="삭제" onclick="boardDeleteCheck('comment')" class="btn btn-outline-danger btn-sm" />
                </form>
              </c:when>
              <c:otherwise>
                <button class="btn btn-outline-danger btn-sm" onclick="openReportModal('boardComment', ${commentVo.comment_id}, '')">
                  신고
                </button>
              </c:otherwise>
            </c:choose>
          </div>
    
          <!-- 답글이 표시될 영역 -->
          <div id="replyListArea${commentVo.comment_id}" class="ms-4 mt-3 baseReply"></div>
    
          <!-- 답글 작성 폼 (숨김처리, 답글쓰기 누르면 보이게) -->
          <div id="replyForm${commentVo.comment_id}" class="mt-3" style="display:none;">
            <textarea id="replyContent${commentVo.comment_id}" class="form-control mb-2" rows="2" placeholder="답글을 입력하세요"></textarea>
            <button class="btn btn-success btn-sm" onclick="replyCheck(${commentVo.comment_id})">확인</button>
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- 고정 버튼 -->
    <div class="d-none d-md-flex flex-column align-items-center gap-2" style="position:fixed; top:30%; right:30px;">
      <button onclick="focusCommentWrite()" class="btn btn-light border">💬</button>
      <a href="${ctp}/board/boardList/${category}?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}"
        class="btn btn-outline-dark btn-sm">ℹ</a>
      <a href="${ctp}/board/boardContent/${category}/${preVo.board_id}"
        class="btn btn-light border">◀</a>
      <a href="${ctp}/board/boardContent/${category}/${nextVo.board_id}"
        class="btn btn-light border">▶</a>
      <button id="bottomBtn" class="btn btn-light border">⏬</button>
      <button id="topBtn" class="btn btn-light border">⏫</button>
    </div>
  
  </div>
  <p><br /></p>
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>