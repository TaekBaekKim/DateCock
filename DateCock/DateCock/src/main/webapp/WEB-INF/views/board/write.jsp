<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board_style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>
    /* write.jsp 특정 스타일 */
    .write-form-container {
        max-width: 800px;
        margin: 30px auto;
        padding: 30px;
        background-color: #fff;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .write-form-container h1 {
        text-align: center;
        margin-bottom: 30px;
        font-size: 1.5em;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
        font-size: 0.9em;
        color: #495057;
    }
    .form-group input[type=text],
    .form-group input[type=file],
    .form-group textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ced4da;
        border-radius: 4px;
        box-sizing: border-box;
        font-size: 1em;
    }
     .form-group input[readonly] {
        background-color: #e9ecef;
        cursor: not-allowed;
    }
    .form-group textarea {
        height: 250px;
        resize: vertical;
    }
    .button-group {
        text-align: center;
        margin-top: 30px;
    }
    .button-group .button {
        margin: 0 5px;
        padding: 10px 25px;
    }
    #formMessage {
        text-align: center;
        margin-bottom: 15px;
        font-weight: bold;
    }
    #formMessage.success { color: green; }
    #formMessage.error { color: red; }
</style>
</head>
<body>

<div class="write-form-container">
    <h1>새 글 작성</h1>

    <%-- enctype="multipart/form-data" 확인! --%>
    <form id="writeForm" action="#" method="post" enctype="multipart/form-data">
        <div id="formMessage"></div> <%-- AJAX 메시지 표시 영역 --%>

        <div class="form-group">
            <label for="writer">작성자</label>
            <input type="text" id="writer" name="writer" value="${sessionScope.id}" readonly required>
        </div>

        <%-- !!! 카테고리 입력 필드 완전 삭제됨 !!! --%>
        <%--
        <div class="form-group">
            <label for="category">카테고리 (선택)</label>
            <input type="text" id="category" name="category">
        </div>
         --%>

        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" id="title" name="title" required>
        </div>

        <div class="form-group">
            <label for="content">내용</label>
            <textarea id="content" name="content" required></textarea>
        </div>

        <%-- 썸네일 파일 입력 필드 --%>
        <div class="form-group">
            <label for="thumbnailFile">썸네일 이미지 (선택)</label>
            <input type="file" id="thumbnailFile" name="thumbnailFile" class="input" accept="image/*">
        </div>

        <div class="button-group">
            <button type="submit" class="button">등록</button>
            <%-- 목록 페이지 경로 확인 필요 (/listup 또는 /board/list) --%>
            <button type="button" class="button cancel" onclick="location.href='${pageContext.request.contextPath}/listup'">취소</button>
        </div>
    </form>
</div>

<script type="text/javascript">
$(document).ready(function() {
    $("#writeForm").on("submit", function(event) {
        event.preventDefault();

        // 유효성 검사 (category 검사 제거)
        var title = $("#title").val().trim();
        var content = $("#content").val().trim();
        var writer = $("#writer").val();
        if (!writer) { alert("로그인이 필요합니다."); location.href = '${pageContext.request.contextPath}/memberinput'; return; }
        if (!title) { alert("제목을 입력해주세요."); $("#title").focus(); return; }
        if (!content) { alert("내용을 입력해주세요."); $("#content").focus(); return; }

        // FormData 생성 (category 필드가 없으므로 자동으로 제외됨)
        var formData = new FormData(this);
        console.log("Submitting FormData (파일 포함 가능)...");

        var $submitButton = $(this).find("button[type=submit]");
        $submitButton.prop("disabled", true).text("등록 중...");

        // AJAX 요청 (이전과 동일)
        $.ajax({
            type: "POST",
            url: "${pageContext.request.contextPath}/writeAction", // Controller 경로 확인
            data: formData,
            dataType: "json",
            processData: false,
            contentType: false,
            success: function(response) {
                console.log("서버 응답:", response);
                var $messageDiv = $("#formMessage");
                if (response.success) {
                    $messageDiv.text(response.message).removeClass("error").addClass("success");
                    alert(response.message);
                    location.href = "${pageContext.request.contextPath}/listup"; // 목록 페이지 경로 확인
                } else {
                    $messageDiv.text(response.message).removeClass("success").addClass("error");
                    alert("오류: " + response.message);
                    $submitButton.prop("disabled", false).text("등록");
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error("AJAX 요청 실패:", textStatus, errorThrown);
                var $messageDiv = $("#formMessage");
                $messageDiv.text("요청 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.").removeClass("success").addClass("error");
                alert("서버와 통신 중 오류가 발생했습니다.");
                $submitButton.prop("disabled", false).text("등록");
            }
        }); // End $.ajax
    }); // End submit handler
}); // End ready
</script>

</body>
</html>