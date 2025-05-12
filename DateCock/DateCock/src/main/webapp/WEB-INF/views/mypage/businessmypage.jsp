<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
    }
    
    .highlight {
    font-size: 18px;
    font-weight: bold;
    }
    
    .mypage-container {
      max-width: 900px;
      margin: auto;
      background-color: #fff;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      position: relative;
    }

    .mypage-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
    }

    .mypage-title {
      font-size: 24px;
      font-weight: bold;
      color: #333;
      display: flex;
      align-items: center;
    }

    .main-link {
      font-size: 24px;
      margin-right: 10px;
      color: #f24e4e;
      text-decoration: none;
    }

    .header-right {
      display: flex;
      align-items: center;
      gap: 15px;
      font-size: 14px;
    }

    .gear-icon {
      font-size: 24px;
      cursor: pointer;
      text-decoration: none;
      color: #A9A9A9;
    }

    .logout-link {
      font-size: 14px;
      text-decoration: none;
      color: #333;
    }

    .logout-link:hover {
      color: #d63384;
    }

    .mypage-section {
      margin-bottom: 40px;
    }

    .mypage-section h3 {
      font-size: 18px;
      margin-bottom: 15px;
      color: #555;
      border-bottom: 1px solid #ddd;
      padding-bottom: 5px;
    }

    .mypage-list {
      list-style: none;
    }

    .mypage-list li {
      margin-bottom: 12px;
    }

    .mypage-list a {
      text-decoration: none;
      color: #333;
      font-size: 16px;
      display: block;
      padding: 10px;
      border-radius: 6px;
      transition: background-color 0.2s;
    }

    .mypage-list a:hover {
      background-color: #ffe6f0;
      color: #d63384;
    }
  </style>
</head>
<body>

<c:if test="${not empty errorMessage}">
<script>
    alert("${errorMessage}");
</script>
</c:if>

<c:if test="${not empty successMessage}">
<script>
    alert("${successMessage}");
</script>
</c:if>


   

  <div class="mypage-container">
    <div class="mypage-header">
      <div class="mypage-title">
        <a href="/main" class="main-link">&#11013;</a>
        사업자 마이페이지
      </div>
      <div class="header-right">
        <span class="highlight">${businessname}</span>대표님
        <a href="businessmypagelogout" class="logout-link">로그아웃</a>
        <a href="/setting" class="gear-icon">&#9881;</a>
      </div>
    </div>

    <div class="mypage-section">
      <h3>매장 관리</h3>
      <ul class="mypage-list">
        <li><a href="businessout">나의 매장정보</a></li>
        <li><a href="businessinput">매장등록</a></li>
        
      </ul>
    </div>

    <div class="mypage-section">
      <h3>문의 / 안내</h3>
      <ul class="mypage-list">
        <li><a href="businessnotice">공지사항</a></li>
        <li><a href="support">고객센터</a></li>
       <!--  <li><a href="#">사업자 Q&amp;A</a></li>
        <li><a href="#">일반 Q&amp;A</a></li>
        <li><a href="#">1:1 문의하기</a></li> -->
      </ul>
    </div>

    <div class="mypage-section">
      <h3>서비스 관리</h3>
      <ul class="mypage-list">
        <li><a href="businessmanual">서비스 정보 (약관)</a></li>
        <li><a href="businessmodify">회원정보 수정</a></li>
        <li><a href="businessdelete">회원 탈퇴</a></li>
      </ul>
    </div>
  </div>
</body>
</html>
