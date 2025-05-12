<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의사항 작성</title>

<style>
body {
  font-family: "Segoe UI", sans-serif;
  background: #f4f4f4;
  margin: 0;
  padding: 0;
}

.container {
  max-width: 800px;
  margin: 50px auto;
  padding: 30px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 0 15px rgba(0,0,0,0.1);
}

h2 {
  margin-bottom: 30px;
  font-size: 24px;
  font-weight: bold;
  text-align: center;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  font-weight: bold;
  display: block;
  margin-bottom: 8px;
}

.form-group input[type="text"],
.form-group input[type="email"],
.form-group textarea {
  width: 100%;
  padding: 12px;
  border-radius: 6px;
  border: 1px solid #ccc;
  font-size: 14px;
  box-sizing: border-box;
}

textarea {
  resize: vertical;
  min-height: 150px;
}

.radio-group {
  display: flex;
  gap: 20px;
  margin-top: 8px;
}

.radio-group label {
  font-weight: normal;
}

.submit-btn {
  width: 100%;
  padding: 14px;
  background: black;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
  margin-top: 30px;
}

.submit-btn:hover {
  background: #333;
}

.button-group {
  display: flex;
  justify-content: space-between;
  gap: 10px;
  margin-top: 30px;
}

.btn-submit, .btn-cancel {
  width: 48%;
  padding: 14px;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
  border: none;
}

.btn-submit {
  background: black;
  color: white;
}

.btn-submit:hover {
  background: #333;
}

.btn-cancel {
  background: #eee;
  color: #333;
}

.btn-cancel:hover {
  background: #ddd;
}
</style>
</head>
<body>

<div class="container">
  <h2>문의사항 작성</h2>
  <form action="${pageContext.request.contextPath}/support/supportqna" method="post">
    
    <div class="form-group">
      <label for="title">제목 <span style="color:red;">*</span></label>
      <input type="text" name="title" id="title" required>
    </div>

    <div class="form-group">
      <label for="writer">작성자 <span style="color:red;">*</span></label>
	  <input type="text" name="writer" id="writer" required>
    </div>

    <div class="form-group">
      <label for="content">문의내용 <span style="color:red;">*</span></label>
      <textarea name="content" id="content" required></textarea>
    </div>

    <div class="form-group">
      <label for="email">이메일 <span style="color:red;">*</span></label>
      <input type="email" name="email" id="email" required>
    </div>

    <div class="form-group">
      <label for="phone">휴대폰 번호 <span style="color:red;">*</span></label>
      <input type="text" name="phone" id="phone" required>
    </div>

    <div class="form-group">
      <label>답변 알림 수신 방법 <span style="color:red;">*</span></label>
      <div class="radio-group">
        <label><input type="radio" name="notifyType" value="email" required> 이메일</label>
        <label><input type="radio" name="notifyType" value="sms"> 문자(SMS)</label>
        <label><input type="radio" name="notifyType" value="kakao"> 카카오톡</label>
      </div>
    </div>

	<div class="button-group">
	    <button class="btn-submit" type="submit">문의 제출하기</button>
		<button class="btn-cancel" type="button" onclick="location.href='${pageContext.request.contextPath}/support'">돌아가기</button>
	</div>
  </form>
</div>

</body>
</html>
