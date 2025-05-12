<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>사업자 마이페이지</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Noto Sans KR', sans-serif;
    }

    body {
      background-color: #f5f5f5;
      padding: 20px;
      font-size: 17px;
    }

    .highlight {
      font-size: 20px;
      font-weight: bold;
    }

    .mypage-container {
      max-width: 1000px;
      margin: auto;
      background-color: #fff;
      padding: 35px;
      border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    .mypage-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
    }

    .mypage-title {
      font-size: 26px;
      font-weight: bold;
      color: #333;
      display: flex;
      align-items: center;
    }

    .main-link {
      font-size: 26px;
      margin-right: 10px;
      color: #f24e4e;
      text-decoration: none;
    }

    .header-right {
      display: flex;
      align-items: center;
      gap: 15px;
      font-size: 16px;
    }

    .gear-icon {
      font-size: 26px;
      cursor: pointer;
      text-decoration: none;
      color: #A9A9A9;
    }

    .logout-link {
      font-size: 16px;
      text-decoration: none;
      color: #333;
    }

    .logout-link:hover {
      color: #d63384;
    }

    .mypage-section {
      margin-bottom: 45px;
    }

    .mypage-section h3 {
      font-size: 20px;
      margin-bottom: 18px;
      color: #555;
      border-bottom: 1px solid #ddd;
      padding-bottom: 6px;
    }

    .mypage-list {
      list-style: none;
      padding: 0;
    }

    .mypage-list li {
      margin-bottom: 15px;
    }

    .mypage-list a {
      text-decoration: none;
      color: #333;
      font-size: 17px;
      display: block;
      padding: 12px;
      border-radius: 6px;
      transition: background-color 0.2s;
    }

    .mypage-list a:hover {
      background-color: #ffe6f0;
      color: #d63384;
    }

    .reservation-box {
      display: flex;
      align-items: center;
      background-color: #fff0f5;
      padding: 14px;
      border-radius: 10px;
      margin-bottom: 18px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      transition: background-color 0.2s;
    }

    .reservation-box:hover {
      background-color: #ffe6f5;
    }

    .reservation-box img {
      width: 120px;
      height: 80px;
      object-fit: cover;
      border-radius: 8px;
      margin-right: 18px;
    }

    .reservation-details {
      font-size: 17px;
      color: #333;
    }

    .reservation-details span {
      display: block;
      margin-bottom: 4px;
    }

    .reservation-link {
      text-decoration: none;
      color: inherit;
      display: block;
    }
  </style>
</head>
<body>

<c:if test="${not empty errorMessage}">
	<script>alert("${errorMessage}");</script>
</c:if>

<c:if test="${not empty successMessage}">
	<script>alert("${successMessage}");</script>
</c:if>

<div class="mypage-container">
  <div class="mypage-header">
    <div class="mypage-title">
      <a href="/main" class="main-link">&#11013;</a>
      개인 마이페이지
    </div>
    <div class="header-right">
      <span class="highlight">${name}</span>님
      <a href="businessmypagelogout" class="logout-link">로그아웃</a>
      <a href="/setting" class="gear-icon">&#9881;</a>
    </div>
  </div>

  <div class="mypage-section">
    <h3>예약</h3>

    <c:if test="${upcomingReservations}">
      <div class="mypage-list">
        <h3>다가오는 예약이 있어요!</h3>
        <c:forEach items="${list}" var="result">
          <a href="details?name=${result.name}&id=${result.id}&day=${result.day}" class="reservation-link">
            <div class="reservation-box">
              <img src="./image/${result.image}" alt="예약 이미지">
              <div class="reservation-details">
                <span><strong>${result.businessname}</strong></span>
                <span>${result.day} ${result.intime}</span>
              </div>
            </div>
          </a>
        </c:forEach>
      </div>
    </c:if>
    <ul class="mypage-list">
      <li><a href="datelist">지난 데이트</a></li>
    </ul>
  </div>

  <div class="mypage-section">
    <h3>문의 / 안내</h3>
    <ul class="mypage-list">
      <li><a href="businessnotice">공지사항</a></li>
      <li><a href="support">고객센터</a></li>
    </ul>
  </div>

  <div class="mypage-section">
    <h3>서비스 관리</h3>
    <ul class="mypage-list">
      <li><a href="businessmanual">서비스 정보 (약관)</a></li>
      <li><a href="usermodify">회원정보 수정</a></li>
      <li><a href="userdelete">회원 탈퇴</a></li>
    </ul>
  </div>
</div>

</body>
</html>
