<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>boardInput.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script src="${ctp}/resources/ckeditor/ckeditor.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/navbar.jsp" />

<div class="container my-5" style="max-width: 800px;">
  <h3 class="mb-4 fw-bold">📝 게시글 작성</h3>
  <form method="post" action="${ctp}/board/boardInput" enctype="multipart/form-data">

    <!-- 제목 -->
    <div class="mb-3">
      <label for="title" class="form-label">제목</label>
      <input type="text" class="form-control" id="title" name="title" placeholder="제목을 입력하세요" required>
    </div>

    <!-- 카테고리 -->
    <div class="mb-3">
      <label for="category" class="form-label">카테고리</label>
      <select class="form-select" id="category" name="category" required>
        <option value="">카테고리 선택</option>
        <option value="free">자유</option>
        <option value="exercise">운동</option>
        <option value="meal">식단</option>
      </select>
    </div>

    <!-- 내용 -->
    <div class="mb-3">
      <label for="content" class="form-label">내용</label>
      <textarea class="form-control" id="content" name="content" rows="10" placeholder="내용을 입력하세요" required></textarea>
          <script>
            CKEDITOR.replace("content",{
              height:460,
              filebrowserUploadUrl:"${ctp}/board/imageUpload",
              uploadUrl : "${ctp}/board/imageUpload"
            });
          </script>      
    </div>

<!--     파일 첨부
    <div class="mb-3">
      <label class="form-label">파일 첨부</label>
      <input class="form-control" type="file" name="files" multiple>
      <small class="text-muted">※ 이미지 파일만 첨부할 수 있습니다. (최대 20MB)</small>
    </div> -->

    <!-- 제출 버튼 -->
    <div class="d-flex justify-content-center gap-2">
      <button type="submit" class="btn btn-primary">등록</button>
      <button type="reset" class="btn btn-secondary">초기화</button>
      <button type="button" class="btn btn-light" onclick="location.href='${ctp}/board/boardList/all'">목록</button>
    </div>
    <input type="hidden" name="user_id" value="${loginUser}"/>
    <input type="hidden" name="username" value="${sUsername}"/>
  </form>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
