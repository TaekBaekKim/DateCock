<%@ page language="java" contentType="text/html; charset=UTF-8"%>
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
  <title>예약페이지</title>
  <link href="https://fonts.googleapis.com/css2?family=Gowun+Dodum&display=swap" rel="stylesheet">
   <!-- 외부 방명록 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/guestbook-ajax.css?v=1.0">
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

    .map-section {
      width: 100%;
      height: 350px;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      overflow: hidden;
      margin-bottom: 40px;
    }

    #staticMap {
      width: 100%;
      height: 100%;
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

    .fixed-buttons button:hover {
      background-color: #e64589;
    }

    .overlay {
      position: fixed;
      top: 0; left: 0;
      width: 100vw;
      height: 100vh;
      z-index: 999;
      display: none;
    }

    .overlay-bg {
      position: absolute;
      top: 0; left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0,0,0,0.5);
    }

    .reservation-form {
      position: absolute;
      top: 50%; left: 50%;
      transform: translate(-50%, -50%);
      background: white;
      padding: 30px 40px;
      border-radius: 12px;
      width: 400px;
      box-shadow: 0 8px 20px rgba(0,0,0,0.3);
    }

    .reservation-form h2 {
      margin-top: 0;
      margin-bottom: 20px;
      color: #333;
      text-align: center;
    }

    .reservation-form label {
      display: block;
      margin: 12px 0 4px;
      font-weight: bold;
      font-size: 14px;
    }

    .reservation-form input {
      width: 100%;
      padding: 10px;
      font-size: 14px;
      margin-bottom: 10px;
      border: 1px solid #ccc;
      border-radius: 6px;
    }

    .reservation-form .buttons {
      display: flex;
      justify-content: space-between;
      margin-top: 20px;
    }

    .reservation-form button {
      flex: 1;
      padding: 14px 0;
      margin: 0 5px;
      background-color: #ff4f9a;
      color: white;
      border: none;
      border-radius: 8px;
      font-weight: bold;
      font-size: 16px;
      cursor: pointer;
      transition: background 0.3s;
    }

    .reservation-form button:hover {
      background-color: #e64589;
    }
    .guestbook-list { list-style:none; padding:0; margin:40px auto; max-width:800px; }
    .guestbook-item { border-top:1px solid #e6e6e6; padding:20px 0; display:flex; justify-content:space-between; align-items:flex-start; }
    .guestbook-item:last-child { border-bottom:1px solid #e6e6e6; }
    .writer { font-weight:700; color:#333; width:100px; flex-shrink:0; }
    .memo { flex:1; margin:0 16px; color:#555; line-height:1.6; }
    .time { font-size:0.85em; color:#999; white-space:nowrap; }
  h1 {
  font-family: 'Gowun Dodum', Nanum Round;
  }
    /* 알럿창 */
     .modal {
  display: none;
  position: fixed;
  z-index: 9999;
  left: 0; top: 0;
  width: 100%; height: 100%;
  background: rgba(0, 0, 0, 0.4);
}
/* 모달 콘텐츠에 success 클래스 추가 */
.modal-content.success {
  background: #ffe6f8;             /* 연한 분홍 배경 */
  border: 2px solid #ff85c0;
  padding: 20px;
  width: 320px;
  margin:auto;
  border-radius: 10px;
  text-align: center;
}
#successMessage {
   color: #d63384;
  font-size: 16px;
  line-height: 1.2;
}
.modal-buttons button#successOkBtn {
  padding: 10px 20px;
  border: none;
  border-radius: 6px;
  background-color: #ff85c0;  
  color: #fff;
  cursor: pointer;
  font-weight: bold;
}
.modal-buttons button#successOkBtn:hover {
   background-color: #d63384; 
}
      /* 알럿창 end*/
  </style>
</head>
<body>
<c:forEach items="${list}" var ="result"> 
<div class="container">
  <div class="image-section">
    <img src="./image/${result.image}" alt="${result.businessname}">
  </div>

  <div class="text-section">
    <p>${result.businessname}<br>주소: ${result.address}<br>영업시간: ${result.businesstime}<br>
    전화번호: ${result.phone}<br>추가정보: ${result.information}</p>
  </div>

  <div class="map-section">
    <div id="staticMap"></div>
  </div>
</div>
</c:forEach>

<div class="fixed-buttons">
  <button onclick="openReservation()">예약하기</button>
  <button onclick="location.href='datecourseout'">취소</button>
</div>

<!-- 예약 폼 -->
<div id="reservationOverlay" class="overlay">
  <div class="overlay-bg"></div>
  <div class="reservation-form">
    <h2>예약하기</h2>
    <form action="reservationsave" method="post">
      <input type="hidden" name="image" value ="${image}">
      <input type="hidden" name="id" value="${dto.id}">	
      <input type="hidden" name="businessname" value="${businessname}">
      <label>이름</label>
      <input type="text" name="name" value="${dto.name}" readonly>
      <label>전화번호</label>
      <input type="tel" name="phone" value="${dto.phone}" readonly="readonly">
      <label>방문날짜</label>
	  <input type="date" name="day" id="visitDate" required>
	  <label>방문시간</label>
	  <input type="time" name="intime" id="visitTime" required>
      <div class="buttons">
        <button type="submit">예약하기</button>
        <button type="button" onclick="closeReservation()">닫기</button>
      </div>
    </form>
  </div>
</div>

<!-- 댓글 목록 -->
<div class="guestbook-wrap">
  <h1>리뷰🌸</h1>
  <ul id="guestList" class="guestbook-list">
  <c:forEach var="g" items="${guestList}">
    <li class="guestbook-item"
        data-name="${g.name}"
        data-todays="${g.todays}">
      <div class="writer">${g.name}</div>
      <div class="memo">${g.memo}</div>
      <div class="time">
        <fmt:formatDate value="${g.todays}" pattern="yyyy-MM-dd HH:mm:ss"/>
      </div>
      <c:if test="${g.name eq sessionScope.name}">
        <button class="btn-delete">삭제</button>
      </c:if>
    </li>
  </c:forEach>
</ul>
</div>

<!-- 댓글 입력 -->
<div class="guestbook-wrap">
  <form id="guestForm" class="guestbook-form">
    <input type="text" name="name" placeholder="이름" required readonly value="${sessionScope.name}">
    <textarea name="memo" placeholder="후기를 입력하세요" required></textarea>
    <button type="submit" class="btn-ajax-submit">등록</button>
    <div id="ajaxFeedback" class="ajax-feedback"></div>
  </form>
</div>

<!-- 삭제 모달 -->
<div id="deleteConfirmModal" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
  <div style="background:#fff; padding:30px; border-radius:12px; text-align:center; width:300px;">
    <p style="margin-bottom:20px;">정말 삭제하시겠습니까?</p>
    <button id="confirmDeleteBtn" style="background:#ff4f9a; color:white; padding:10px 20px; border:none; border-radius:6px; margin-right:10px;">삭제</button>
    <button id="cancelDeleteBtn" style="background:#ccc; color:black; padding:10px 20px; border:none; border-radius:6px;">취소</button>
  </div>
</div>
<!-- 예약 모달 -->
<div id="successModal" class="modal">
  <div class="modal-content success">
    <p id="successMessage">예약이 완료됐습니다.<br>마이페이지에서 확인하세요.</p>
    <div class="modal-buttons">
      <button id="successOkBtn">확인</button>
    </div>
  </div>
</div>
<!-- Kakao 지도 SDK -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=805a8eb80a70687a1a47fefb25d70a0a&libraries=services"></script>

<script>

const personalloginstate = "${personalloginstate2}";

function openReservation() {
  if (personalloginstate !== "true") {
    alert("로그인이 필요합니다!");
    window.location.href = 'DateCocklog';
    return;
  }

  document.getElementById('reservationOverlay').style.display = 'block';
}



  function closeReservation() {
    document.getElementById('reservationOverlay').style.display = 'none';
  }

  // 지도 호출
  var address = "${mapaddress.address}";
  var mapContainer = document.getElementById('staticMap');
  var mapOption = {
    center: new kakao.maps.LatLng(33.450701, 126.570667),
    level: 3
  };

  var map = new kakao.maps.Map(mapContainer, mapOption);
  var geocoder = new kakao.maps.services.Geocoder();

  geocoder.addressSearch(address, function(result, status) {
    if (status === kakao.maps.services.Status.OK) {
      var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
      var marker = new kakao.maps.Marker({
        map: map,
        position: coords
      });
      map.setCenter(coords);
    } else {
      alert("주소를 찾을 수 없습니다.");
    }
  });
</script>

<script>

// 예약 날짜 제한 오늘 이전 선택 불가 (지난 날짜 선택 불가)
const today = new Date().toISOString().split("T")[0];
document.getElementById('visitDate').setAttribute("min", today);

// 예약 시간 제한 오늘이면 현재 시간 이후만 선택 가능 (지난 시간 선택 불가)
document.getElementById('visitDate').addEventListener('change', function () {
  const selectedDate = this.value;
  const timeInput = document.getElementById('visitTime');

  const now = new Date();
  const currentTime = now.toTimeString().slice(0, 5); 
  const todayStr = now.toISOString().split("T")[0];

  if (selectedDate === todayStr) {
    timeInput.min = currentTime;
  } else {
    timeInput.removeAttribute("min");
  }
}); //날짜 시간 제한 끝
</script>

<!-- 댓글 등록 & 삭제 -->
<script> 
  let targetToDelete = null;

  //  댓글 등록
  document.getElementById('guestForm').addEventListener('submit', function (e) {
    e.preventDefault();
    const form = e.target;
    const data = new URLSearchParams(new FormData(form));

    fetch('${pageContext.request.contextPath}/insertGuest', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: data
    })
    .then(res => res.json())
    .then(entry => {
      form.reset();
      document.getElementById('ajaxFeedback').textContent = '등록되었습니다!';
      location.reload(); //  등록 후 자동 새로고침
    })
    .catch(err => {
      alert('저장 실패: ' + err);
      console.error(err);
    });
  });

  //  삭제 버튼 클릭 시 모달 띄우기
  document.addEventListener('click', function (e) {
    if (e.target.classList.contains('btn-delete')) {
      targetToDelete = e.target.closest('li');
      document.getElementById('deleteConfirmModal').style.display = 'flex';
    }
  });

  //  삭제 확정
 document.getElementById('confirmDeleteBtn').addEventListener('click', function () {
  const name   = targetToDelete.dataset.name;
  const todays = targetToDelete.dataset.todays;  // dataset에 todays가 있다는 가정

  fetch(`${pageContext.request.contextPath}/deleteGuest`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 
      'name='   + encodeURIComponent(name) +
      '&todays=' + encodeURIComponent(todays)
  })
  .then(() => {
    document.getElementById('deleteConfirmModal').style.display = 'none';
    location.reload();
  })
  .catch(err => {
    alert('삭제 실패: ' + err);
    document.getElementById('deleteConfirmModal').style.display = 'none';
  });
});

  //  삭제 취소
  document.getElementById('cancelDeleteBtn').addEventListener('click', function () {
    document.getElementById('deleteConfirmModal').style.display = 'none';
  });
  </script>
  <script>
  document.querySelector('.reservation-form form').addEventListener('submit', function(e) {
     e.preventDefault();
     // 실제 전송은 모달 확인 버튼 클릭 시
     document.getElementById('successModal').style.display = 'flex';
   });

   // 모달 “확인” 클릭 → 폼 전송 & 모달 닫기
   document.getElementById('successOkBtn').addEventListener('click', function() {
     document.getElementById('successModal').style.display = 'none';
     // 실제 예약 저장 액션 호출
     document.querySelector('.reservation-form form').submit();
   });
</script>
</body>
</html>
