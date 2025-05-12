<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 변경</title>
    <style>
        .container {
            width: 500px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
        }
        .form-group {
            margin-bottom: 20px;
            
        }
        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            padding: 10px 20px;
            background: #3366ff;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-align: right;
        }
        .message {
            margin-bottom: 15px;
            font-weight: bold;
        }
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
<div class="container">
    <h2>비밀번호 변경</h2>

    <!-- 메시지 출력 -->
    <c:if test="${not empty errorMessage}">
        <div class="message error">${errorMessage}</div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="message success">${successMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/userpwmodify1" method="post">
        <div class="form-group">
            <label>현재 비밀번호</label>
            <input type="password" name="pwd" required>
        </div>
        <div class="form-group">
            <label>새 비밀번호</label>
            <input type="password" name="newpwd" required>
        </div>
        <div class="form-group">
            <label>새 비밀번호 확인</label>
            <input type="password" name="newpwd_confirm" required>
        </div>
        <div style="text-align: right;">
	        <button type="submit">비밀번호 변경</button>
	        <button type="button" onclick="location.href='mypage'" class="btn">돌아가기</button>
        </div>
    </form>
</div>

<script type="text/javascript">
	document.addEventListener("DOMContentLoaded", function () {
	    const form = document.querySelector("form");
	    const pwd = document.querySelector("input[name='pwd']");
	    const newpwd = document.querySelector("input[name='newpwd']");
	    const newpwd_confirm = document.querySelector("input[name='newpwd_confirm']");
	
	    form.addEventListener("submit", function (e) {
	        console.log("✅ 폼 제출 감지됨");
	        console.log("현재 비번:", pwd.value);
	        console.log("새 비번:", newpwd.value);
	        console.log("확인:", newpwd_confirm.value);
	
	        if (newpwd.value === pwd.value) {
	            alert("새 비밀번호는 현재 비밀번호와 달라야 합니다.");
	            e.preventDefault();
	            newpwd.focus();
	            return;
	        }
	
	        if (newpwd.value !== newpwd_confirm.value) {
	            alert("새 비밀번호와 확인 값이 일치하지 않습니다.");
	            e.preventDefault();
	            newpwd_confirm.focus();
	            return;
	        }
	
	        if (!/[!@#$%^&*(),.?{}|<>]/.test(newpwd.value)) {
	            alert("비밀번호는 특수문자를 1개 이상 포함해야 합니다.");
	            e.preventDefault();
	            newpwd.focus();
	            return;
	        }
	    });
	});

</script>

</body>
</html>
