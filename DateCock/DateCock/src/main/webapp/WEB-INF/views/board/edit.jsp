 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board_style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<%-- 필요시 추가 CSS/JS --%>
<style>
.edit-container { max-width: 800px; margin: 30px auto; padding: 30px; background-color: #fff; border: 1px solid #dee2e6; border-radius: 8px; }
 .edit-container h1 {
        text-align: center;  /* 텍스트 가운데 정렬 */
        margin-bottom: 30px; /* 제목 아래 여백 */
        font-size: 1.8em;    /* 폰트 크기 */
        color: #333;        /* 색상 */
    }
.form-group { margin-bottom: 20px; }
.form-group label { display: block; margin-bottom: 8px; font-weight: 500; }
.form-group input[type="text"], .form-group textarea {
width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 4px; box-sizing: border-box;
}
.form-group textarea { height: 250px; resize: vertical; }
.form-actions { text-align: center; margin-top: 30px; }
.form-actions .button {
    display: inline-block; /* 버튼들을 인라인 블록으로 */
    padding: 8px 20px;     /* 내부 여백 조정 */
    margin: 0 5px;         /* 버튼 사이 간격 */
    font-size: 0.95em;      /* 폰트 크기 */
    font-weight: 500;      /* 글자 두께 */
    color: #343a40;        /* 글자 색상 (진회색) */
    background-color: #ffffff; /* 배경 흰색 */
    border: 1px solid #ced4da; /* 테두리 색상 (연회색) */
    border-radius: 4px;    /* 약간 둥근 모서리 */
    cursor: pointer;
    text-align: center;
    text-decoration: none; /* a 태그 사용 대비 */
    vertical-align: middle;
    transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out;
    font-family: inherit; /* body 폰트 상속 */
}

/* 버튼 위에 마우스 올렸을 때 효과 */
.form-actions .button:hover {
    background-color: #f8f9fa; /* 약간 어두운 배경 */
    color: #212529;
    border-color: #adb5bd;
}




</style>
</head>
<body>   

<div class="edit-container">
    <h1>게시글 수정</h1>

    <%-- 수정 처리 Controller 경로 (/board/editAction) 지정 --%>
    <form action="${pageContext.request.contextPath}/board/editAction" method="post" id="editForm" enctype="multipart/form-data"> <%-- 파일 첨부 시 enctype 추가 --%>

        <%-- 게시글 번호 (hidden) --%>
        <input type="hidden" name="bno" value="${boardDTO.bno}">

        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" id="title" name="title" value="<c:out value='${boardDTO.title}'/>" required>
        </div>

        <div class="form-group">
            <label for="writer">작성자</label>
            <%-- 작성자는 수정 불가, 화면에 표시만 --%>
            <input type="text" id="writer" name="writer" value="<c:out value='${boardDTO.writer}'/>" readonly disabled style="background-color: #eee;">
        </div>

        <div class="form-group">
            <label for="content">내용</label>
            <textarea id="content" name="content" required><c:out value='${boardDTO.content}'/></textarea>
        </div>

         <%-- 썸네일 수정 기능 (선택적) --%>
         <div class="form-group">
             <label for="thumbnailFile">썸네일 이미지 변경 (선택)</label>
             <input type="file" id="thumbnailFile" name="thumbnailFile" accept="image/*">
             <c:if test="${not empty boardDTO.thumbnail}">
                 <p style="margin-top: 10px;">
                     현재 썸네일: <img src="${pageContext.request.contextPath}${boardDTO.thumbnail}" alt="현재 썸네일" style="max-height: 50px; vertical-align: middle;">
                     <input type="hidden" name="existingThumbnail" value="${boardDTO.thumbnail}"> <%-- 기존 파일 경로 전달 (삭제 로직 위함) --%>
                 </p>
             </c:if>
         </div>

        <div class="form-actions">
            <button type="submit" class="button primary">수정 완료</button>
            <%-- 취소 버튼: 상세 보기 페이지로 돌아가기 --%>
            <button type="button" class="button" onclick="location.href='${pageContext.request.contextPath}/view?bno=${boardDTO.bno}'">취소</button>
        </div>

    </form>
</div>

</body>
</html>