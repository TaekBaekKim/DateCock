<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 600px;
            margin: 40px auto;
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 6px;
        }
        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
        }
        .form-actions {
            text-align: right;
        }
        .form-actions button {
            padding: 10px 20px;
            border: none;
            background-color: #3366ff;
            color: white;
            border-radius: 8px;
            cursor: pointer;
        }
        .form-actions button:hover {
            background-color: #254edb;
        }
        .form-actions-firebrick button:hover {
            background-color: #B22222;
        }
        .masked {
            color: #888;
        }
       
    .hidden {
        display: none;
    }
   .button-row {
    overflow: hidden; /* clearfix */
}

.form-actions-left {
    float: left;
}

.form-actions {
    float: right;
}

.button {
    padding: 10px 20px;
    border: none;
    background-color: #3366ff;
    color: white;
    border-radius: 8px;
    cursor: pointer;
    margin-left: 10px;
}

.button:hover {
    background-color: #254edb;
}
</style>
</head>
<body>
<div class="container">
    <h2>회원 정보 수정</h2>

    <form id="updateForm" action="businessmodify1" method="post">

        <div class="form-group">
            <label>사업자 등록 번호</label>
            <span class="masked">${business.businessnumber}</span>
            <input type="text" name="businessnumber" class="input hidden" value="${business.businessnumber}" readonly>
        </div>

        <div class="form-group">
            <label>이름</label>
            <span class="masked">${business.businessname}</span>
            <input type="text" name="businessname" class="input hidden" value="${business.businessname}">
        </div>

        <div class="form-group">
            <label>이메일</label>
            <span class="masked">${business.email}</span>
            <input type="text" name="email" class="input hidden" value="${business.email}">
        </div>
        
        <div class="form-group">
            <label>휴대폰 번호</label>
            <span class="masked">${business.phone}</span>
            <input type="text" name="phone" class="input hidden" value="${business.phone}">
        </div>

		<div class="button-row clearfix">
		    <div class="form-actions-left">
		        <button type="button" class="button" onclick="location.href='businesspwmodify'">비밀번호 수정하기</button>
		    </div>

		    <div class="form-actions">
		        <button type="button" id="editBtn" class="button">정보 수정</button>
		        <button type="submit" id="saveBtn" class="button hidden">확인</button>
		        <button type="button" class="button" onclick="location.href='businessmypage'">도망가기</button>
		    </div>
		</div>


		
        
    </form>
</div>



<script>
    document.getElementById("editBtn").addEventListener("click", function () {
        document.querySelectorAll(".masked").forEach(el => el.classList.add("hidden"));
        document.querySelectorAll(".input").forEach(el => el.classList.remove("hidden"));

        document.getElementById("editBtn").classList.add("hidden");
        document.getElementById("saveBtn").classList.remove("hidden");
    });
</script>


</body>
</html>