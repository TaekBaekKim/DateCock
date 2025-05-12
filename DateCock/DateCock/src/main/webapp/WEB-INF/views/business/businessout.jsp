<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>타임라인</title>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

  <script type="text/javascript">
    let selectedNumber = "";
    let selectedImage = "";

    $(document).on("click", ".delete-btn", function (e) {
      e.preventDefault();
      selectedNumber = $(this).data("number");
      selectedImage = $(this).data("image");
      $("#customConfirm").fadeIn();
    });

    function confirmYes() {
      $("#customConfirm").fadeOut();

      $.ajax({
        type: "post",
        url: "alldelete",
        data: {
          businessnumber: selectedNumber,
          businessimage: selectedImage
        },
        success: function () {
          alert("삭제되었습니다.");
          location.href = "loginmain";
        },
        error: function () {
          alert("오류 발생! 다시 시도해주세요.");
        }
      });
    }

    function confirmNo() {
      $("#customConfirm").fadeOut();
    }
  </script>

  <style>

    .red-button {
      box-sizing: border-box;
      appearance: none;
      background-color: transparent;
      border: 2px solid #e74c3c;
      border-radius: 0.6em;
      color: #e74c3c;
      cursor: pointer;
      display: flex;
      align-self: center;
      font-size: 1rem;
      font-weight: 700;
      line-height: 1;
      margin: 20px;
      padding: 1.2em 2.8em;
      text-decoration: none;
      text-align: right;
      text-transform: uppercase;
      font-family: 'Montserrat', sans-serif;
    }

    .red-button:hover,
    .red-button:focus {
      color: #fff;
      background-color: #e74c3c;
      outline: 0;
    }

    .mint-button {
      box-sizing: border-box;
      appearance: none;
      background-color: transparent;
      border: 2px solid #AAF0D1;
      border-radius: 0.6em;
      color: #AAF0D1;
      cursor: pointer;
      display: flex;
      align-self: center;
      font-size: 1rem;
      font-weight: 700;
      line-height: 1;
      margin: 20px;
      padding: 1.2em 2.8em;
      text-decoration: none;
      text-align: center;
      text-transform: uppercase;
      font-family: 'Montserrat', sans-serif;
    }

    .mint-button:hover,
    .mint-button:focus {
      color: #fff;
      background-color: #AAF0D1;
      outline: 0;
    }

    .button-group {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 30px;
    }

    body {
      margin: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #f5f5f5;
    }

    .timeline-container {
      max-width: 1200px;
      margin: 50px auto;
      background-color: #fff;
      display: flex;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      border-radius: 8px;
      overflow: hidden;
    }

    .timeline-image {
      flex: 1;
      min-width: 400px;
      background-color: #ddd;
    }

    .timeline-image img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }

    .timeline-text {
  flex: 1;
  padding: 40px 30px;
  background-color: #fff;
  display: flex;
  flex-direction: column;
  align-items: center; /* 가운데 정렬 */
  text-align: center; /* 텍스트도 가운데 */
}
    

    .timeline-item {
      margin-bottom: 30px;
    }

    .timeline-item h3 {
      font-size: 18px;
      color: #333;
      margin-bottom: 5px;
    }

    .timeline-item p {
      font-size: 14px;
      color: #666;
      line-height: 1.6;
    }

    .modal {
      display: none;
      position: fixed;
      z-index: 9999;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.4);
    }

    .modal-content {
      background: white;
      padding: 20px;
      width: 300px;
      border-radius: 10px;
      text-align: center;
      margin: 15% auto;
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
      color: white;
      cursor: pointer;
    }

    .modal-buttons button:hover {
      background-color: #c0392b;
    }
  </style>
</head>
<body>

<c:forEach items="${list}" var="result">
  <div class="timeline-container">
    <div class="timeline-image">
      <img src="./image/${result.image}" alt="ex)대표 이미지">
    </div>

    <div class="timeline-text">
      <div class="timeline-item"><h3>사업자등록번호</h3><p>${result.businessnumber}</p></div>
      <div class="timeline-item"><h3>업체 이름</h3><p>${result.businessname}</p></div>
      <div class="timeline-item"><h3>업체 주소</h3><p>${result.address}</p></div>
      <div class="timeline-item"><h3>영업시간</h3><p>${result.businesstime}</p></div>
      <div class="timeline-item"><h3>전화번호</h3><p>${result.phone}</p></div>
      <div class="timeline-item"><h3>추가 정보</h3><p>${result.information}</p></div>
      <div class="timeline-item"><h3>필터 나이</h3><p>${result.age}대</p></div>
      <div class="timeline-item"><h3>필터 주소</h3><p>${result.zone}지역</p></div>
      <div class="timeline-item"><h3>필터 데이트취향</h3><p>${result.activity}</p></div>

      <div class="button-group">
        <a href="businessupdate?businessnumber=${result.businessnumber}" class="mint-button">수정</a>
        <button class="red-button delete-btn"
                data-number="${result.businessnumber}"
                data-image="${result.image}">
          삭제
        </button>
      </div>
    </div>
  </div>
</c:forEach>

<!-- 삭제 모달 -->
<div id="customConfirm" class="modal">
  <div class="modal-content">
    <p id="confirmMessage">정말 삭제하시겠습니까?</p>
    <div class="modal-buttons">
      <button onclick="confirmYes()">삭제</button>
      <button onclick="confirmNo()">취소</button>
    </div>
  </div>
</div>

</body>
</html>
