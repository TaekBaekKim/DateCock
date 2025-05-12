<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>데이트코스 소개</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&display=swap" rel="stylesheet">
  <style>
    /* reset */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { font-family: 'Noto Sans KR', sans-serif; background: #fefefe; color: #333; }

    .content {
      padding: 80px 20px;
      max-width: 1200px;
      margin: 0 auto;
    }

    /* 각 가게 섹션 */
    .section {
      display: flex;
      align-items: center;
      gap: 20px;
      margin-bottom: 40px;
      border-bottom: 5px solid #eee;
      padding-bottom: 40px;
    }
    /* 텍스트 영역 */
    .section .text {
      flex: 1;
    }
    .section .text .tag {
      font-family: 'Oswald', sans-serif;
      font-size: 12px; color: #aaa; letter-spacing: 1px;
    }
    .section .text h2 {
      font-size: 28px; margin: 10px 0;
    }
    .section .text hr {
      width: 52px; border: none;
      border-bottom: 2px solid #aaa; margin: 10px 0 20px;
    }
    .section .text p {
      font-size: 14px; line-height: 1.6; margin-bottom: 8px;
    }

    /* 이미지 영역 */
    .section .image {
      flex: 0 0 350px; /* 너비 고정 */
      height: 240px;    /* 높이 고정 */
      overflow: hidden;
      border-radius: 8px;
     
      transform: translateX(-100px);

    }
    .section .image img {
      width: 100%; height: 100%;
      object-fit: cover;
      display: block;
      
    }

    /* 버튼 박스 */
    .button-box {
      margin-right:110px;
    }
    .button-box .reserve-btn {
      display: inline-block;
      background-color: #ff4f9a;
      color: #fff;
      border: none;
      border-radius: 20px;
      padding: 15px 50px;
      font-size: 18px;
      cursor: pointer;
      transition: background 0.2s;
    }
    .button-box .reserve-btn:hover {
      background-color: #e64589;
    }
  </style>
</head>
<body>
  <div class="content">
    <c:forEach items="${list}" var="result">
      <section class="section">
        <div class="text">
          <div class="tag">데이트코스</div>
          <h2>${result.businessname}</h2>
          <hr>
          <p>주소: ${result.address}</p>
          <p>영업시간: ${result.businesstime}</p>
          <p>전화번호: ${result.phone}</p>
          <p>추가정보: ${result.information}</p>
        </div>
        <div class="image">
          <img src="./image/${result.image}" alt="${result.businessname}">
        </div>
        <div class="button-box">
          <button class="reserve-btn" onclick="location.href='datereservation?businessname=${result.businessname}'">예약하기</button>
        </div>
      </section>
    </c:forEach>

  </div>
</body>
</html>
