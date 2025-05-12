<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %> <%-- Spring Form 태그 라이브러리 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- 날짜 등 포맷팅 위해 추가 (필요시) --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%-- dto 객체가 모델에 있다는 가정하에 EL로 제목 설정 --%>
<title>문의글 수정 (글번호: ${dto.bno})</title>
<style>
    /* --- 기존 스타일 유지 --- */
    .container { width: 70%; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h2 { text-align: center; color: #333; margin-bottom: 20px; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
    /* CSS 클래스로 스타일 적용 */
    input.form-control, textarea.form-control { width: calc(100% - 22px); padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
    textarea.form-control { resize: vertical; min-height: 150px; /* 최소 높이 */ }
    .form-check { display: flex; align-items: center; margin-bottom: 5px; }
    .form-check-inline { display: inline-flex; align-items: center; margin-right: 15px; }
    .form-check-input { margin-right: 5px; width: auto; }
    .form-check-label { font-weight: normal; margin-bottom: 0; }
    .form-control-file { display: block; width: 100%; }
    .btn { display: inline-block; font-weight: 400; color: #212529; text-align: center; vertical-align: middle; cursor: pointer; user-select: none; background-color: transparent; border: 1px solid transparent; padding: .375rem .75rem; font-size: 1rem; line-height: 1.5; border-radius: .25rem; text-decoration: none; }
    .btn-primary { color: #fff; background-color: #007bff; border-color: #007bff; }
    .btn-secondary { color: #fff; background-color: #6c757d; border-color: #6c757d; }
    .btn-primary:hover { background-color: #0069d9; border-color: #0062cc; }
    .btn-secondary:hover { background-color: #5a6268; border-color: #545b62; }
    .button-group { margin-top:20px; text-align:right; }
    .error-message { color: red; font-size: 0.9em; margin-top: 5px; display: block; }
    .alert { padding:10px; border:1px solid transparent; margin-bottom:15px; border-radius:4px; }
    .alert-danger { color:#721c24; background-color:#f8d7da; border-color:#f5c6cb; }
    /* 현재 이미지 표시 스타일 */
    .current-image-display img { max-width: 200px; max-height: 200px; margin-bottom:5px; display: block; border: 1px solid #ddd; padding: 3px; }
    .current-image-display label { font-weight: normal; margin-left: 5px; }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<div class="container">
    <h2>문의글 수정 (글번호: ${dto.bno})</h2>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">
            ${errorMessage}
        </div>
    </c:if>

    <%-- Spring Form 태그 사용 --%>
    <form:form modelAttribute="dto" action="${pageContext.request.contextPath}/uqeditAction" method="post" id="qnaEditForm" enctype="multipart/form-data">
        <form:hidden path="bno" /> <%-- 수정 대상 글 번호 --%>
        <%-- 페이징 및 검색어 유지를 위한 hidden input --%>
        <c:if test="${not empty paging}">
            <input type="hidden" name="nowPage" value="${paging.nowPage}">
            <input type="hidden" name="searchType" value="${paging.searchType}">
            <input type="hidden" name="keyword" value="${paging.keyword}">
            <input type="hidden" name="cntPerPage" value="${paging.cntPerPage}">
        </c:if>

        <div class="form-group">
            <label for="writerDisplay">작성자:</label>
            <input type="text" class="form-control" id="writerDisplay" name="writerDisplay" value="${dto.writer}" readonly>
        </div>

        <div class="form-group">
            <label for="title">제목:</label>
            <form:input path="title" id="title" cssClass="form-control" required="required"/>
            <form:errors path="title" cssClass="error-message"/>
        </div>

        <div class="form-group">
            <label for="content">내용:</label>
            <form:textarea path="content" id="content" cssClass="form-control" rows="10" required="required"/>
            <form:errors path="content" cssClass="error-message"/>
        </div>

        <div class="form-group">
            <label>공개여부:</label>
            <div class="form-check form-check-inline">
                <form:radiobutton path="secret" id="secretN_edit" value="0" cssClass="form-check-input"/>
                <label class="form-check-label" for="secretN_edit">공개</label>
            </div>
            <div class="form-check form-check-inline">
                <form:radiobutton path="secret" id="secretY_edit" value="1" cssClass="form-check-input"/>
                <label class="form-check-label" for="secretY_edit">비밀글</label>
            </div>
            <form:errors path="secret" cssClass="error-message"/>
        </div>

        <div class="form-group">
            <label for="qnaImageFile">이미지 변경 (새 파일 선택 시 기존 파일 대체):</label>
            <form:input type="file" path="qnaImageFile" id="qnaImageFile" cssClass="form-control-file" accept="image/*"/>
            <%-- 기존 이미지가 있는 경우 표시 및 삭제 옵션 제공 --%>
            <c:if test="${not empty dto.imageFile}">
                <div class="current-image-display" style="margin-top: 10px;">
                    <p style="margin-bottom:5px;"><strong>현재 이미지:</strong> <c:out value="${dto.imageFile}"/></p>
                    <c:url var="imageUrl" value="/image/${dto.imageFile}"/>
                    <img src="${imageUrl}" alt="첨부이미지">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="deleteExistingImage" name="deleteExistingImage" value="yes">
                        <label class="form-check-label" for="deleteExistingImage">현재 이미지 삭제 (체크 후 수정 시 삭제됩니다)</label>
                    </div>
                </div>
            </c:if>
        </div>

        <div class="button-group">
            <button type="submit" class="btn btn-primary">수정 완료</button>
            <%-- 취소 버튼: 상세보기 페이지로 이동 (페이징 정보 포함) --%>
            <c:url var="viewUrl" value="/uqview">
                <c:param name="bno" value="${dto.bno}"/>
                <c:if test="${not empty paging}">
                    <c:param name="nowPage" value="${paging.nowPage}"/>
                    <c:param name="cntPerPage" value="${paging.cntPerPage}"/>
                    <c:param name="searchType" value="${paging.searchType}"/>
                    <c:param name="keyword" value="${paging.keyword}"/>
                </c:if>
            </c:url>
            <a href="${viewUrl}" class="btn btn-secondary">취소</a>
        </div>
    </form:form>
</div>

<script type="text/javascript">
    // jQuery 유효성 검사 (기존 로직 유지)
    $(document).ready(function(){
        $("#qnaEditForm").submit(function(){
            if($("#title").val().trim() === ""){
                alert("제목을 입력해주세요.");
                $("#title").focus();
                return false;
            }
            if($("#content").val().trim() === ""){
                alert("내용을 입력해주세요.");
                $("#content").focus();
                return false;
            }
            return true; // 폼 제출 진행
        });
    });
</script>

</body>
</html>