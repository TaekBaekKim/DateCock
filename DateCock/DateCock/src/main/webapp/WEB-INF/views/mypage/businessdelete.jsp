<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<head>
  <meta charset="UTF-8">
  <title>DateCock 회원 탈퇴</title>
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #fff;
      color: #333;
    }
    
    .highlight {
      color: #0077FF;
    }
    
    .container {
      max-width: 900px;
      margin: auto;
      background-color: #fff;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      position: relative;
    }
    h1 {
      font-size: 26px;
      font-weight: bold;
      margin-bottom: 20px;
    }
    .section {
      margin-bottom: 30px;
    }
    .section-title {
      font-weight: bold;
      margin-bottom: 10px;
      font-size: 18px;
    }
    .warning {
      color: #ff3300;
      font-weight: bold;
    }
    .info-box {
      background: #f7f7f7;
      border: 1px solid #ddd;
      padding: 15px;
      margin-top: 10px;
    }
    .blue-box {
      background-color: #f0f8ff;
      padding: 10px;
      border-left: 5px solid #4a90e2;
      margin-top: 10px;
    }
    select, input[type="checkbox"] {
      margin-top: 10px;
    }
    button {
      background-color: #2c54ff;
      color: white;
      border: none;
      padding: 12px 25px;
      font-size: 16px;
      cursor: pointer;
      margin-top: 20px;
      border-radius: 4px;
    }
    button:hover {
      background-color: #003ddb;
    }
    
    .radio-group label {
      display: block;
      margin: 12px 0;
      font-size: 16px;
      cursor: pointer;
    }
    
    .hidden {
  	display: none;
	}
    
  </style>
</head>
<body>

  <div class="container" id="step1">
  	<h1>왜 떠나게<br><span class="highlight">되셨나요?</h1>
  	
  	<form>
      <div class="radio-group">
        <label><input type="radio" name="reason">사용을 잘 안하게 돼요</label>
        <label><input type="radio" name="reason"> 적당한 데이트코스가 없어요</label>
        <label><input type="radio" name="reason"> 예약, 취소, 혜택받기 등 사용이 어려워요</label>
        <label><input type="radio" name="reason"> 혜택(쿠폰, 이벤트)이 너무 적어요</label>
        <label><input type="radio" name="reason"> 개인정보 보호를 위해 삭제할 정보가 있어요</label>
        <label><input type="radio" name="reason"> 다른 계정이 있어요</label>
        <label><input type="radio" name="reason" value="기타"> 기타</label>
<input type="text" id="reasonText" class="hidden" placeholder="기타 사유를 입력해주세요.">
      </div>
      
      <div class="buttons">
        <button type="button" class="btn-secondary" onclick="location.href='businessmypage'">취소</button>
        <button type="button" class="btn-primary" id="nextBtn">다음으로</button>
      </div>
     </form>
  </div>
  
  <div class="container hidden" id="step2">
    <h1>DateCock 회원 탈퇴하기 전<br>꼭 확인해 주세요</h1>

    <div class="section">
      <div class="section-title">1. 서비스 이용 및 계정 복구 불가</div>
      <p class="warning">DateKock 회원을 탈퇴하시면 DateKock 계정으로 이용 중인 모든 서비스에서 함께 탈퇴됩니다.</p>
      <p>DateKock 회원 탈퇴가 완료되면 계정 정보가 즉시 삭제되며 복구할 수 없습니다.</p>
      <div class="info-box">
        <p><strong>이용 중인 DateKock 사업자 등록번호</strong>: ${sessionScope.businessnumberA}</p>
        <p><strong>이용 중인 서비스</strong>: DateKock</p>
      </div>
    </div>

    <div class="section">
      <div class="section-title">2. 유료 가입 서비스 이용 불가</div>
      <p>탈퇴 후에는 유료 서비스 재가입이 제한될 수 있습니다.</p>
    </div>

    <div class="section">
      <div class="section-title">3. 게시판 등록 글 유지</div>
      <p>회원 탈퇴 시 작성한 게시글은 자동 삭제되지 않습니다.</p>
    </div>

    <div class="section">
      <div class="section-title">4. 탈퇴 처리 및 재가입 제한</div>
      <p class="warning">DateKock 회원 탈퇴 후 7일간 동일 이메일로 재가입이 불가능합니다.</p>
    </div>

    <div class="section">
      <div class="section-title">5. 탈퇴 후 정보 보관 및 삭제</div>
      <p>관련 법령에 따라 일부 데이터는 일정 기간 보관될 수 있습니다.</p>
    </div>
    
    <form action="businessdelete1" method="post" onsubmit="return confirmDelete();">
	  <input type="hidden" name="businessnumber" value="${sessionScope.businessnumberA}">
	  <button type="submit">회원 탈퇴하기</button>
	</form>

	
    <button onclick="location.href='businessmypage'">도망치기</button>
    </div>

  
  <script type="text/javascript">
  document.getElementById("nextBtn").addEventListener("click", function () {
    const checked = document.querySelector('input[name="reason"]:checked');
    if (!checked) {
      alert("탈퇴 사유를 선택해주세요.");
      return;
    }

    // 기타 사유 선택 시 텍스트 입력도 확인
    if (checked.value === "기타") {
      const etcText = document.getElementById("reasonText").value.trim();
      if (!etcText) {
        alert("기타 사유를 입력해주세요.");
        return;
      }
    }

    // 1단계 숨기고 2단계 보여주기
    document.getElementById("step1").classList.add("hidden");
    document.getElementById("step2").classList.remove("hidden");
  });

  function confirmDelete() {
    alert("탈퇴가 완료되었습니다.");
    
    return true;
  }

  // 기타 선택 시 입력창 보이기
  document.querySelectorAll('input[name="reason"]').forEach((radio) => {
    radio.addEventListener('change', function () {
      const etcInput = document.getElementById("reasonText");
      if (this.value === "기타") {
        etcInput.classList.remove("hidden");
      } else {
        etcInput.classList.add("hidden");
      }
    });
  });
</script>

</body>
</html>