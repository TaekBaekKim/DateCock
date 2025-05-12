<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>가게 등록</title>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

  <style>
  /*뒷 배경 사진*/
   .cotn_principal {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  
  background-image: url('./image/그리스 산토리노.png'); 
  background-size: cover;      /* 화면 꽉 채우기 */
  background-position: center; /* 가운데 정렬 */
  background-repeat: no-repeat; /* 반복 없이 */
  /*뒷 배경 사진*/
}
  /* "등록하기" 버튼 스타일 */
  .register-button {
    display: block;
    width: 100%;
    background-color: rgb(253,166,165); /* 버튼 색 */
    color: #fff; 
    border: none;
    border-radius: 5px;
    padding: 12px;
    font-size: 16px;
    cursor: pointer;
    text-align: center;
    margin-top: 20px; /* 입력란들 위에 공간을 주기 위해 */
      /* "등록하기" 버튼 스타일 끝*/
  }

  .register-button:hover {
    background-color: rgb(253,166,165); /* 버튼 호버 시 색상 */
  }
  
  widget-image{
  right: 50px;
  width: 50px;
 
  }
   .box-content {
    padding: 0; /* 여백 제거 */
  }
  
.floating-box {
  position: fixed;
  bottom: 20px; 
  right: 160px; 
  width: 150px;
  background-color: #ffffff; 
  border-radius: 10px; 
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); 
  padding: 10px; 
  font-family: Arial, sans-serif; 
  text-align: center;
}

/* 텍스트 스타일 */
.title {
  font-size: 16px;
  font-weight: bold;
  margin: 0;
  padding: 0;
  line-height: 1.2;
}

.description {

  font-size: 14px;
  color: #555555;
   margin-bottom: 5px;
}


.subscribe-button {
  display: block;
  width: 100%;
  height:40px;
  background-color: #6c63ff; 
  color: #ffffff; 
  border: none;
  border-radius: 5px;
  padding: 8px;
  font-size: 12px;
  cursor: pointer;
}

.subscribe-button:hover {
  background-color: #574bff; 
}

/* 닫기 버튼 스타일 */
.close-button {
  position: absolute;
  top: 10px;
  right: 10px;
  background-color: transparent;
  border: none;
  font-size: 14px;
  cursor: pointer;
}
 .age-radios {
  display: flex;
  justify-content: center; 
}
  .age-wrapper {
    margin-bottom: 20px;
  }

  .age-input {
    width: 100%;
    padding: 10px;
    font-size: 14px;
    border-radius: 5px;
    border: 1px solid #ccc;
    margin-bottom: 10px;
  }
  .age-wrapper {
    margin-bottom: 20px;
    text-align: center; 
  }

  .age-input {
    display: none; 
  }
  .age-radios {
    display: flex;
    gap: 10px;
  }

  .age-radios input[type="radio"] {
    display: none;
  }

  .age-radios label {
    padding: 8px 15px;
    border: 1px solid #ccc;
    border-radius: 20px;
    background-color: #f0f0f0;
    cursor: pointer;
    font-size: 13px;
    transition: 0.3s;
    display: inline-block;
  }

  .age-radios input[type="radio"]:checked + label {
    background-color: #4AD395;
    color: white;
    border-color: #4AD395;
    
    
  }
   .age-radios label:hover {
    background-color: #d3d3d3; 
  }
  //
   .zone-radios {
  display: flex;
  justify-content: center; 
}
  .zone-wrapper {
    margin-bottom: 20px;
  }

  .zone-input {
    width: 100%;
    padding: 10px;
    font-size: 14px;
    border-radius: 5px;
    border: 1px solid #ccc;
    margin-bottom: 10px;
  }
  .zone-wrapper {
    margin-bottom: 20px;
    text-align: center; 
  }

  .zone-input {
    display: none; 
  }
  .zone-radios {
  display: flex;
  justify-content: center; /* 가로로 중앙 정렬 */
  align-items: center; /* 수직 정렬 */
  gap: 20px; /* 버튼들 사이 간격 */
  width: 100%; /* 전체 너비 사용 */
  }

  .zone-radios input[type="radio"] {
    display: none;
  }

  .zone-radios label {
    padding: 8px 15px;
    border: 1px solid #ccc;
    border-radius: 20px;
    background-color: #f0f0f0;
    cursor: pointer;
    font-size: 13px;
    transition: 0.3s;
    display: inline-block;
  }

  .zone-radios input[type="radio"]:checked + label {
    background-color: #4AD395;
    color: white;
    border-color: #4AD395;
   
    
  }
   .zone-radios label:hover {
    background-color: #d3d3d3; 
  }
  //
   .activity-radios {
  display: flex;
  justify-content: center; /* 가로로 중앙 정렬 */
  align-items: center; /* 수직 정렬 */
  gap: 20px; /* 버튼들 사이 간격 */
  width: 100%; /* 전체 너비 사용 */
}
  .activity-wrapper {
    margin-bottom: 20px;
  }

  .activity-input {
    width: 100%;
    padding: 10px;
    font-size: 14px;
    border-radius: 5px;
    border: 1px solid #ccc;
    margin-bottom: 10px;
  }
  .activity-wrapper {
    margin-bottom: 20px;
    text-align: center; 
  }

  .activity-input {
    display: none; 
  }
  .activity-radios {
    display: flex;
    gap: 10px;
  }

  .activity-radios input[type="radio"] {
    display: none;
  }

  .activity-radios label {
    padding: 8px 15px;
    border: 1px solid #ccc;
    border-radius: 18px;
    background-color: #f0f0f0;
    cursor: pointer;
    font-size: 11px;
    transition: 0.3s;
    display: inline-block;
  }

  .activity-radios input[type="radio"]:checked + label {
    background-color: #4AD395;
    color: white;
    border-color: #4AD395;
    
    
  }
   .activity-radios label:hover {
    background-color: #d3d3d3; 
  }
    .file-label {
    display: block;
    background-color: #fff;
    padding: 10px;
    border-radius: 5px;
    text-align: center;
    cursor: pointer;
    color: #555;
    margin-bottom: 10px;
    font-size: 14px;
    }
     input[type="file"] {
    display: none; 
  }
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Open Sans", sans-serif;
    }

    body, html {
      height: 100%;
    }

  

    .cont_forms {
      width: 400px;
      background: rgb(253, 242, 241);
      border-radius: 8px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.2);
      padding: 30px;
      position: relative;
    }

    .cont_form_sign_up {
      display: none;
      flex-direction: column;
      gap: 15px;
      align-items: center;
    }

    .cont_form_sign_up.show {
      display: flex;
    }

    .cont_form_sign_up h2 {
      margin-bottom: 10px;
      color: #444;
    }

    .cont_form_sign_up input {
      width: 100%;
      padding: 12px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    .btn_sign_up {
      background-color: #ef5350;
      border: none;
      padding: 12px;
      width: 100%;
      border-radius: 4px;
      color: #fff;
      cursor: pointer;
      font-size: 16px;
    }

    .btn_sign_up:hover {
      background-color: #d84343;
    }

    .close_btn {
      position: absolute;
      top: 10px;
      left: 10px;
      font-size: 24px;
      
      color: #aaa;
      cursor: pointer;
    }

    .cont_img_back_ {
      width: 100%;
      height: 150px;
      right:69px;
      max-height: 180px;
      overflow: hidden;
      border-radius: 16px;
      margin-bottom: 20px;
      text-align:right;
      position: relative;
    }

    .cont_img_back_ img {
      width: 60%;
      height 60%;
      object-fit: contain; 
       object-position: center; 
    }
    .speech-bubble {
   position: relative;
   background: #bc01a3;
   border-radius: .4em;
}

.speech-bubble:after {
   content: '';
   position: absolute;
   right: 0;
   top: 50%;
   width: 0;
   height: 0;
   border: 68px solid transparent;
   border-left-color: #bc01a3;
   border-right: 0;
   border-bottom: 0;
   margin-top: -34px;
   margin-right: -68px;
   
}

  </style>

</head>

<body>

  <div class="cotn_principal">
    <div class="cont_forms" id="formWrapper">
      <div class="cont_img_back_">
        <img src="./image/DateCocklogo.png" alt="로고">
      </div>

      <div class="cont_form_sign_up" id="signupForm">
        <span class="material-icons close_btn" onclick="hidden_login_and_sign_up()">close</span>
        <h2>가게 정보</h2>
        <form action="businesssavego" method="post" enctype="multipart/form-data">
          <input type="text" name="businessname" placeholder="업체 이름" required />
          <input type="text" name="address" placeholder="주소" required />
          <input type="text" name="businesstime" placeholder="영업 시간" required />
          <input type="text" name="phone" placeholder="전화번호" required />
          <label for="businessimage" class="file-label">👉 대표 이미지를 넣어주세요    (클릭)👈</label>
        <input type="file" id="businessimage" name="businessimage" required />
          <input type="text" name="information"placeholder="추가정보 (예: 무선인터넷, 반려동물 가능)"/>
          <div class="age-wrapper">
          <label for="ageInput" class="age-input-label">ex)필터 나이 선택 👇</label>
            <div class="age-radios">
              <input type="radio" id="age10" name="age" value="10">
             <label for="age10">10대</label>
         <input type="radio" id="age20" name="age" value="20">
         <label for="age20">20대</label>
         <input type="radio" id="age30" name="age" value="30">
              <label for="age30">30대</label>
           </div>
         </div>
         <div class="zone-wrapper">
          <label for="ageInput" class="zone-input-label">ex)필터 지역 선택 👇</label>
            <div class="zone-radios">
              <input type="radio" id="zone10" name="zone" value="홍대">
             <label for="zone10">홍대</label>
         <input type="radio" id="zone20" name="zone" value="강남">
         <label for="zone20">강남</label>
         <input type="radio" id="zone30" name="zone" value="명동">
              <label for="zone30">명동</label>
           </div>
         </div>
         <div class="activity-wrapper">
          <label for="activityInput" class="activity-input-label">데이트 취향 선택 ♥️</label>
            <div class="activity-radios">
              <input type="radio" id="activity10" name="activity" value="활동적인 데이트">
             <label for="activity10">활동적인 데이트</label>
         <input type="radio" id="activity20" name="activity" value="색다른 데이트">
         <label for="activity20">색다른 데이트</label>
         <input type="radio" id="activity30" name="activity" value="편안한 데이트">
              <label for="activity30">편안한 데이트</label>
           </div>
         </div>
          <!-- 등록 버튼 -->
          <div class="register-button-container" style="text-align: center;">
            <button type="submit" class="register-button">등록하기</button>
          </div>
        </form>
      </div>
    </div>
  </div>
<div class="floating-box">

  <div class="box-content">
    <p class="title" >가게 등록이 <br>어렵다면? <br>고민하지 말고 <br>상담하세요<br>직원이 친절하게 상담해드립니다</p>
    <img src="./image/pp1.png" class="widget-image" width="120px" height="120px"/>
    <p class="description">031-000-0000</p>
<button onclick="location.href='support'" class="subscribe-button">상담하러 가기</button>
</div>
  </div>
  <button class="close-button">✖</button>


  <script>
    // 처음에 보이게 처리
    window.onload = function () {
      document.getElementById("signupForm").classList.add("show");
    };

    function hidden_login_and_sign_up() {
      document.getElementById("signupForm").classList.remove("show");
    }
  
  </script>
  
</body>
</html>
