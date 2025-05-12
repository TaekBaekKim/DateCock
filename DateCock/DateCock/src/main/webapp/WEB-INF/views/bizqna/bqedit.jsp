<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기업 문의 수정 (글번호: ${dto.bno})</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"> <%-- 공통 CSS --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
    
    .container {
        width: 70%;
        margin: 40px auto;
        padding: 30px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        font-family: 'Noto Sans KR', sans-serif;
    }
    h2 {
        text-align: center;
        color: #333;
        margin-bottom: 30px;
        font-weight: 700;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: #555;
    }
    .form-control {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
        font-size: 15px;
        transition: border-color .3s ease, box-shadow .3s ease;
    }
    .form-control:focus {
        border-color: #FF5597;
        box-shadow: 0 0 0 0.2rem rgba(255, 85, 151, 0.25);
        outline: none;
    }
    textarea.form-control {
        resize: vertical;
        min-height: 180px;
    }
    .form-control-file {
        display: block;
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
        font-size: 14px;
    }
    .current-image-display {
        margin-top: 10px;
        font-size: 14px;
        color: #555;
    }
    .current-image-display img {
        max-width: 250px;
        max-height: 250px;
        margin-bottom: 8px;
        display: block;
        border: 1px solid #ddd;
        padding: 4px;
        border-radius: 4px;
    }
    .current-image-display label {
        font-weight: normal;
        margin-left: 5px;
        font-size: 14px;
        color: #555;
    }
    .current-image-display input[type="checkbox"] {
        margin-right: 5px;
        vertical-align: middle;
    }
    .form-check {
        display: flex;
        align-items: center;
        margin-top: 10px;
    }
    .form-check-input {
        margin-right: 8px;
        width: auto;
        height: auto;
        vertical-align: middle;
    }
    .form-check-label {
        font-weight: 500;
        margin-bottom: 0;
        font-size: 15px;
        color: #555;
        cursor: pointer;
    }
    .btn {
        display: inline-block;
        font-weight: 500;
        color: #fff;
        text-align: center;
        vertical-align: middle;
        cursor: pointer;
        user-select: none;
        background-color: #FF5597;
        border: 1px solid #FF5597;
        padding: 10px 20px;
        font-size: 15px;
        line-height: 1.5;
        border-radius: 5px;
        text-decoration: none;
        transition: background-color .3s ease, border-color .3s ease, box-shadow .3s ease;
        min-width: 100px;
    }
    .btn-primary {
        background-color: #FF5597;
        border-color: #FF5597;
    }
    .btn-primary:hover {
        background-color: #E64C88;
        border-color: #E64C88;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    .btn-secondary {
        color: #333;
        background-color: #f0f0f0;
        border-color: #ccc;
    }
    .btn-secondary:hover {
        background-color: #e0e0e0;
        border-color: #bbb;
        color: #333;
    }
    .button-group {
        margin-top: 30px;
        text-align: right;
        padding-top: 20px;
        border-top: 1px solid #eee;
    }
    .button-group .btn + .btn {
        margin-left: 10px;
    }
    .text-danger {
        color: #dc3545;
        font-size: 0.875em;
        display: block;
        margin-top: .25rem;
    }
    .alert {
        padding: 15px;
        border: 1px solid transparent;
        margin-top: 20px;
        margin-bottom: 20px;
        border-radius: 5px;
    }
    .alert-danger {
        color: #721c24;
        background-color: #f8d7da;
        border-color: #f5c6cb;
    }
    .help-block {
        font-size: 14px;
        color: #555;
        margin-top: 8px;
    }
</style>
</head>
<body>

<div class="container">
    <h2>기업 문의 수정</h2>

    <%-- action 경로는 bizqna 컨트롤러의 수정 처리 URL로 지정 --%>
    <form:form modelAttribute="dto" action="${pageContext.request.contextPath}/bqeditAction" method="post" enctype="multipart/form-data">
        <form:hidden path="bno"/>
        <%-- 페이징 및 검색 조건 유지를 위한 hidden input 필드 --%>
        <input type="hidden" name="nowPage" value="${paging.nowPage}">
        <input type="hidden" name="cntPerPage" value="${paging.cntPerPage}">
        <input type="hidden" name="searchType" value="${paging.searchType}">
        <input type="hidden" name="keyword" value="${paging.keyword}">

        <div class="form-group">
            <label for="title">제목</label>
            <form:input path="title" id="title" cssClass="form-control" required="true"/>
            <form:errors path="title" cssClass="text-danger"/>
        </div>

        <div class="form-group">
            <label>작성자 (사업자번호)</label>
            <%-- bizqna는 작성자가 사업자 번호이므로 readonly --%>
            <input type="text" value="${dto.writer}" class="form-control" readonly="readonly"/>
        </div>

        <div class="form-group">
            <label for="content">내용</label>
            <form:textarea path="content" id="content" cssClass="form-control" rows="10" required="true"/>
            <form:errors path="content" cssClass="text-danger"/>
        </div>

        <div class="form-group">
            <label for="qnaImageFile">이미지 파일</label>
            <c:if test="${not empty dto.imageFile}">
                <div class="current-image-display">
                    <p><strong>현재 이미지:</strong></p>
                    <%-- UserQna와 동일한 이미지 경로 사용 (/image/) --%>
                    <img src="${pageContext.request.contextPath}/image/${dto.imageFile}" alt="현재 첨부 이미지">
                    <span>${dto.imageFile}</span>
                    <input type="checkbox" id="deleteExistingImage" name="deleteExistingImage" value="yes" style="margin-left: 15px;">
                    <label for="deleteExistingImage">기존 이미지 삭제</label>
                </div>
                <p style="margin-top: 10px;">새로운 이미지를 첨부하면 기존 이미지는 교체됩니다.</p>
            </c:if>
            <c:if test="${empty dto.imageFile}">
                <p>현재 첨부된 이미지가 없습니다.</p>
            </c:if>
            <%-- DTO의 qnaImageFile 필드와 연결 --%>
            <input type="file" name="qnaImageFile" id="qnaImageFile" class="form-control-file" style="margin-top: 5px;"/>
        </div>

        <div class="form-group">
            <div class="form-check">
                <%-- BizQnaDTO의 secret 필드(int) 값에 따라 checked 설정 --%>
                <input type="checkbox" name="secret" id="secret" value="1" class="form-check-input" <c:if test="${dto.secret == 1}">checked</c:if> />
                <label for="secret" class="form-check-label">이 글을 비밀글로 설정합니다.</label>
            </div>
        </div>

        <div class="button-group">
            <button type="submit" class="btn btn-primary">수정 완료</button>
             <%-- 취소 버튼: bizqna 상세보기 페이지로 이동 --%>
            <a href="<c:url value='/bqview'>
                        <c:param name='bno' value='${dto.bno}'/>
                        <c:param name='nowPage' value='${paging.nowPage}'/>
                        <c:param name='cntPerPage' value='${paging.cntPerPage}'/>
                        <c:if test='${not empty paging.searchType}'><c:param name='searchType' value='${paging.searchType}'/></c:if>
                        <c:if test='${not empty paging.keyword}'><c:param name='keyword' value='${paging.keyword}'/></c:if>
                      </c:url>" class="btn btn-secondary">취소</a>
        </div>
    </form:form>

    <%-- 서버에서 전달된 에러 메시지 표시 --%>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">
            <strong>오류:</strong> ${errorMessage}
        </div>
    </c:if>
    <c:if test="${not empty message}"> <%-- 성공 메시지 (필요시 사용) --%>
        <div class="alert alert-success" role="alert">
            ${message}
        </div>
    </c:if>

</div>

</body>
</html>