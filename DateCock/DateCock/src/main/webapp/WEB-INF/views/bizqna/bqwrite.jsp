<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기업 문의 작성</title>
<style>
    /* --- "고객 문의 작성" 페이지의 스타일 유지 --- */
    .container { width: 70%; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h2 { text-align: center; color: #333; margin-bottom: 20px; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
    input.form-control, textarea.form-control { width: calc(100% - 22px); padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
    textarea.form-control { resize: vertical; min-height: 150px; }
    .form-check { display: flex; align-items: center; margin-bottom: 5px; }
    .form-check-inline { display: inline-flex; align-items: center; margin-right: 15px; }
    .form-check-input { margin-right: 5px; width: auto; /* 크기 자동 조절 */ } /* 체크박스/라디오버튼 자체의 스타일 */
    .form-check-label { font-weight: normal; margin-bottom: 0; /* 라벨 여백 제거 */ }
    .form-control-file { display: block; width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; margin-top: 5px; } /* 파일 인풋 패딩 및 테두리 추가 */
    .btn { display: inline-block; font-weight: 400; color: #212529; text-align: center; vertical-align: middle; cursor: pointer; user-select: none; background-color: transparent; border: 1px solid transparent; padding: .375rem .75rem; font-size: 1rem; line-height: 1.5; border-radius: .25rem; text-decoration: none; }
    .btn-primary { color: #fff; background-color: #007bff; border-color: #007bff; }
    .btn-secondary { color: #fff; background-color: #6c757d; border-color: #6c757d; text-decoration: none;}
    .btn-primary:hover { background-color: #0069d9; border-color: #0062cc; }
    .btn-secondary:hover { background-color: #5a6268; border-color: #545b62; }
    .button-group { margin-top:20px; text-align:right; }
    .error-message { color: red; font-size: 0.9em; margin-top: 5px; display: block; }
    .alert { padding:10px; border:1px solid transparent; margin-bottom:15px; border-radius:4px; }
    .alert-danger { color:#721c24; background-color:#f8d7da; border-color:#f5c6cb; }
    .alert-success { color:#155724; background-color:#d4edda; border-color:#c3e6cb; }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<div class="container">
    <h2>기업 문의 작성</h2>

    <%-- 에러/성공 메시지 표시 (폼 상단으로 이동) --%>
    <c:if test="${not empty errorMessageGlobal}"> <%-- 컨트롤러에서 addFlashAttribute("errorMessageGlobal", "메시지 내용") 등으로 전달 --%>
        <div class="alert alert-danger" role="alert">
            <strong>오류:</strong> ${errorMessageGlobal}
        </div>
    </c:if>
    <c:if test="${not empty successMessageGlobal}"> <%-- 컨트롤러에서 addFlashAttribute("successMessageGlobal", "메시지 내용") 등으로 전달 --%>
        <div class="alert alert-success" role="alert">
            ${successMessageGlobal}
        </div>
    </c:if>

    <form:form modelAttribute="bizQnaBoardDTO" action="${pageContext.request.contextPath}/bqwriteAction" method="post" enctype="multipart/form-data" id="bizQnaWriteForm">
        <div class="form-group">
            <label for="title">제목</label>
            <form:input path="title" id="title" cssClass="form-control" required="true"/>
            <form:errors path="title" cssClass="error-message"/>
        </div>

        <div class="form-group">
            <label>작성자 (사업자번호)</label>
            <input type="text" value="${sessionScope.businessnumberA}" class="form-control" readonly/>
            <%-- 실제 writer 값은 컨트롤러에서 DTO에 세션 정보로 설정 --%>
        </div>

        <div class="form-group">
            <label for="content">내용</label>
            <form:textarea path="content" id="content" cssClass="form-control" rows="10" required="true"/>
            <form:errors path="content" cssClass="error-message"/>
        </div>

        <div class="form-group">
            <label for="qnaImageFile">이미지 파일 첨부 (선택)</label>
            <form:input type="file" path="qnaImageFile" id="qnaImageFile" cssClass="form-control-file" accept="image/*"/>
            <%-- path="qnaImageFile"은 DTO의 MultipartFile 타입 필드와 연결 --%>
        </div>

        <div class="form-group">
            <label>공개여부:</label>
            <div class="form-check"> <%-- form-check로 감싸기 --%>
                <form:checkbox path="secret" value="1" id="secret" cssClass="form-check-input"/>
                <label for="secret" class="form-check-label">비밀글로 설정</label>
                 <form:errors path="secret" cssClass="error-message"/>
            </div>
            <%-- 체크 안하면 secret은 0 또는 null. DTO에서 boolean이나 Integer로 받고 기본값 처리.
                 value="1"은 체크 시 서버로 전달될 값. 체크 안되면 이 필드는 전송되지 않거나, _secret (히든필드)에 의해 false/0 처리됨 (Spring 설정에 따라 다름) --%>
        </div>

        <div class="button-group">
            <button type="submit" class="btn btn-primary">등록</button>
            <a href="<c:url value='/bqlist'/>" class="btn btn-secondary">취소</a>
        </div>
    </form:form>
</div>

<script type="text/javascript">
    $(document).ready(function(){
        $("#bizQnaWriteForm").submit(function(event){ // event 파라미터 추가
            if($("#title").val().trim() === ""){
                alert("제목을 입력해주세요.");
                $("#title").focus();
                event.preventDefault(); // 폼 제출 중단
                return false;
            }
            if($("#content").val().trim() === ""){
                alert("내용을 입력해주세요.");
                $("#content").focus();
                event.preventDefault(); // 폼 제출 중단
                return false;
            }
            // 비밀글 체크박스는 필수가 아니므로 별도 검사 생략
            return true; // 폼 제출 진행
        });
    });
</script>

</body>
</html>