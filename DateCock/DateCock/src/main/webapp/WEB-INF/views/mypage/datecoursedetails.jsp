<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:choose>
  <c:when test="${not empty sessionScope.personalloginstate2}">
    <c:set var="personalloginstate2" value="true" />
  </c:when>
  <c:otherwise>
    <c:set var="personalloginstate2" value="false" />
  </c:otherwise>
</c:choose>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>예약 내역</title>
  <link href="https://fonts.googleapis.com/css2?family=Gowun+Dodum&display=swap" rel="stylesheet">
  <style>
    body {
      margin: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #fff;
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 40px 20px;
      position: relative;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .image-section {
      width: 100%;
      height: 400px;
      background-color: #eee;
      display: flex;
      justify-content: center;
      align-items: center;
      border-radius: 12px;
      margin-bottom: 40px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .image-section img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
      border-radius: 12px;
    }

    .text-section {
      background-color: #f9f9f9;
      padding: 30px;
      text-align: center;
      font-size: 20px;
      line-height: 1.8;
      border-radius: 12px;
      margin-bottom: 40px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      font-family: 'Gowun Dodum', sans-serif;
    }

    .fixed-buttons {
      position: fixed;
      top: 50%;
      right: 40px;
      display: flex;
      flex-direction: column;
      gap: 20px;
      transform: translateY(-50%);
    }
 .fixed-buttons button {
      background-color: #ff4f9a;
      color: #fff;
      font-weight: bold;
      font-size: 18px;
      padding: 18px 40px;
      border: none;
      border-radius: 30px;
      cursor: pointer;
      box-shadow: 0 4px 12px rgba(0,0,0,0.2);
      transition: background 0.3s;
    }
    /* 추가: 삭제(예약취소) 버튼 스타일 */
    .red-button {
      box-sizing: border-box;
      appearance: none;
      background-color: transparent;
      border: 2px solid #e74c3c;
      border-radius: 0.6em;
      color: #e74c3c;
      font-size: 1rem;
      font-weight: 700;
      margin: 20px 0;
      padding: 1.2em 2.8em;
      text-transform: uppercase;
      cursor: pointer;
    }
    .red-button:hover {
      background-color: #e74c3c;
      color: #fff;
    }

    /* 추가: 삭제 모달 스타일 */
    .modal {
      display: none;
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0,0,0,0.4);
      z-index: 9999;
    }
    .modal-content {
      background: #fff;
      padding: 20px;
      width: 300px;
      margin: 15% auto;
      border-radius: 10px;
      text-align: center;
    }
    .modal-buttons {
      margin-top: 15px;
      display: flex;
      justify-content: space-around;
    }
    .modal-buttons button {
      padding: 8px 16px;
      border: none;
      border-radius: 6px;
      background-color: #e74c3c;
      color: #fff;
      cursor: pointer;
    }
    .modal-buttons button:hover {
      background-color: #c0392b;
    }

    h1 {
      font-family: 'Gowun Dodum', 'Nanum Round';
    }
  </style>
</head>
<body>

<div class="container">
  <div class="image-section">
    <img src="./image/${dto.image}" alt="${dto.businessname}">
  </div>

  <div class="text-section">
    <p>
      ${dto.businessname}<br>
      주소: ${dto.address}<br>
      영업시간: ${dto.businesstime}<br>
      전화번호: ${dto.phone}<br>
      추가정보: ${dto.information}
    </p>
  </div>

  <c:forEach items="${list}" var="result">
    <div class="text-section">
      <p>
        예약자명: ${result.name}<br>
        전화번호: ${result.phone}<br>
        예약날짜: <fmt:formatDate value="${result.day}" pattern="yyyy-MM-dd"/><br>
        예약시간: ${result.intime}
      </p>
    </div>
  
</c:forEach>
 <c:forEach items="${list}" var="result">
  <div class="fixed-buttons">
    <!-- 예약취소 버튼 -->
    <button class="red-button delete-btn"
            data-name="${result.name}"
            data-day="${result.day}"
            data-businessname="${result.businessname}">
      예약 취소
    </button>
   
    <button onclick="location.href='mypage'">닫기</button>
   </div>
   </c:forEach>
</div>

<!-- 삭제(예약취소) 모달 -->
<div id="customConfirm" class="modal">
  <div class="modal-content">
    <p id="confirmMessage">정말 예약을 취소하시겠습니까?</p>
    <div class="modal-buttons">
      <button onclick="confirmYes()">예약 취소</button>
      <button onclick="confirmNo()">되돌아가기</button>
    </div>
  </div>
</div>

<!-- jQuery 및 모달 제어 스크립트 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
  let selectedName = "";
  let selectedDay  = "";
  let selectedBusinessname  = "";
  
  $(document).on("click", ".delete-btn", function(e) {
    e.preventDefault();
    selectedName = $(this).data("name");
    selectedDay  = $(this).data("day");
    selectedBusinessname = $(this).data("businessname");
    $("#customConfirm").fadeIn();
  });

  function confirmYes() {
    $("#customConfirm").fadeOut();
    $.ajax({
      type: "post",
      url: "reservationdelete",               // ← 실제 예약취소 매핑 URL로 변경
      data: {                         // ← 필요한 파라미터로 조정
        name: selectedName,
        day: selectedDay,
        businessname : selectedBusinessname
      },
      success: function() {
        alert("예약이 취소되었습니다.");
        location.href = "mypage";
      },
      error: function() {
        alert("오류 발생! 다시 시도해주세요.");
      }
    });
  }

  function confirmNo() {
    $("#customConfirm").fadeOut();
  }
</script>

</body>
</html>