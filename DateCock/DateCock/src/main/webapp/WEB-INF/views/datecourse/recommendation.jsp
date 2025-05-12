<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="bodyClass" value="recommend-bg" />
<html>
<head>
  <meta charset="UTF-8">
  <title>데이트 코스 추천</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #fef7f7;
    }
    .recommend-wrapper {
      background: url('<c:url value="/image/데이트코스추천back.png" />') no-repeat center center fixed;
      background-size: cover;
      min-height: 100vh;
      padding: 60px 0;
    }
    #question-box {
      margin: 0 auto;
      max-width: 800px;
      padding: 40px;
    }
    .question {
      background-color: rgba(255, 255, 255, 0.85);
      border-radius: 20px;
      padding: 30px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }
    .answers {
      margin-top: 20px;
    }
    .selected-answer {
      margin-top: 30px;
    }
    .answer-btn {
      display: block;
      width: 400px;
      margin: 10px auto;
      padding: 20px;
      font-size: 18px;
      text-align: center;
      background-color: #e6f4f1;
      border: 2px solid #ccc;
      border-radius: 25px;
      cursor: pointer;
      transition: all 0.5s ease;
    }
    .selected {
      background-color: rgb(186,252,224) !important;
      color: #000 !important;
      border-color: rgb(145, 235, 200);
    }
    .fade-out-right {
      transform: translateX(1000px);
      opacity: 0;
      pointer-events: none;
    }
    #result {
      text-align: center;
      font-size: 20px;
      margin-top: 40px;
    }
 /* 결과물 추*/
.result-box {
  display: flex;
  background-color: #fef7f7;
  border-radius: 16px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  overflow: hidden;
  margin-left: 30px;
}
.result-image {
  flex: 1;
  max-width: 300px;
}
.result-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.result-info {
  flex: 2;
  padding: 20px;
}
.result-info h2 {
  margin-top: 0;
}
.result-info p {
  margin: 4px 0;
  font-size: 16px;
}
.tag {
  font-size: 14px;
  font-weight: bold;
  color: #ff6699;
  margin-bottom: 6px;
}
.result-button {
  flex: 0 0 auto;
  display: flex;
  align-items: center;
  padding: 20px;
}
.reserve-btn {
  padding: 10px 20px;
  background-color: #ff6699;
  color: white;
  border: none;
  border-radius: 20px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}
.reserve-btn:hover {
  background-color: #e65c8f;
}
  </style>
</head>
<body>
<div class="recommend-wrapper">
  <div id="question-box">
    <!-- 질문 1 -->
    <div class="question" id="step1">
      <p>1. 나이대를 선택해주세요!</p>
      <div class="answers">
        <button class="answer-btn button1" data-step="1" data-value="10">10대</button>
        <button class="answer-btn button1" data-step="1" data-value="20">20대</button>
        <button class="answer-btn button1" data-step="1" data-value="30">30대</button>
      </div>
    </div>
    <!-- 질문 2 -->
    <div class="question" id="step2">
      <p>2. 데이트 장소를 선택해주세요</p>
      <div class="answers">
        <button class="answer-btn button2" data-step="2" data-value="홍대">홍대</button>
        <button class="answer-btn button2" data-step="2" data-value="강남">강남</button>
        <button class="answer-btn button2" data-step="2" data-value="명동">명동</button>
      </div>
    </div>
    <!-- 질문 3 -->
    <div class="question" id="step3">
      <p>3. 원하는 데이트 종류는?</p>
      <div class="answers">
        <button class="answer-btn button3" data-step="3" data-value="활동적인 데이트">활동적인 데이트</button>
        <button class="answer-btn button3" data-step="3" data-value="색다른 데이트">색다른 데이트</button>
        <button class="answer-btn button3" data-step="3" data-value="편안한 데이트">편안한 데이트</button>
      </div>
    </div>
  </div>
  <div id="result" style="display:none;"></div>
</div>

<script>
let answers = {};
function handleAnswer(stepClass, stepNumber) {
  $(document).on("click", "." + stepClass, function () {
    const value = $(this).data("value");
    const $this = $(this);

    answers["step" + stepNumber] = value;
    $this.addClass("selected");
    $this.siblings(".answer-btn").each(function () {
      $(this).addClass("fade-out-right");
    });

    // 질문 박스 숨기기 및 결과 AJAX 요청
    if (answers.step1 && answers.step2 && answers.step3) {
      $("#question-box").fadeOut();
      setTimeout(() => {
        $.ajax({
          url: "<c:url value='/getDateCourse'/>",
          type: "POST",
          data: answers,
          dataType: "json",
          success: function (list) {
            $.ajax({
              url: "<c:url value='/recommendresult'/>",
              type: "POST",
              data: { resultList: JSON.stringify(list) },
              success: function (html) {
                $("#result").html(html).fadeIn();
              }
            });
          },
          error: function (xhr, status, error) {
            console.error("AJAX 실패:", error);
          }
        });
      }, 1000);
    }
  });
}

$(function () {
  handleAnswer("button1", 1);
  handleAnswer("button2", 2);
  handleAnswer("button3", 3);
});
</script>
</body>
</html>