<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 선택</title>
<style>
  body {
    margin: 0;
    font-family: 'Noto Sans KR', sans-serif;
    background-color: #f9f9f9;
  }

  .container {
    display: flex;
    flex-wrap: wrap;
    max-width: 1200px;
    margin: 50px auto;
    gap: 30px;
    justify-content: center;
    padding-bottom: 50px; /* footer랑 안 겹치게 여백 추가 */
  }

  .login-box {
    width: 500px;
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    cursor: pointer;
    transition: transform 0.3s;
  }

  .login-box:hover {
    transform: translateY(-5px);
  }

  .img-wrap img {
    width: 100%;
    height: 450px; /* 이미지 높이 고정 */
    object-fit: cover;
    display: block;
  }

  .text-box {
    padding: 30px 20px;
    text-align: center;
  }

  .title {
    font-size: 26px;
    font-weight: bold;
    color: #272729;
    margin-bottom: 10px;
  }

  .subtitle {
    font-size: 16px;
    color: #888;
    margin-bottom: 20px;
  }

  .description {
    font-size: 15px;
    color: #444;
    line-height: 1.6;
  }

  .view-text {
    margin-top: 20px;
    font-size: 15px;
    font-weight: bold;
    color: #272729;
    text-decoration: underline;
  }

  .hr-line {
    width: 50px;
    border: none;
    border-bottom: 2px solid #272729;
    margin: 15px auto 0;
  }

  @media (max-width: 768px) {
    .login-box {
      width: 90%;
    }
  }
</style>
</head>
<body>
<div class="container">
  <!-- 개인 로그인 -->
  <div class="login-box" onclick="location.href='memberinput'">
    <div class="img-wrap">
      <img src="./image/개인로그인.png" alt="개인 로그인 이미지">
    </div>
    <div class="text-box">
      <div class="title">개인 로그인</div>
      <div class="subtitle">Personal Login</div>
      <div class="description">
        개인 회원을 위한 로그인 페이지입니다.<br>
        다양한 데이트 코스와 추천 서비스를 경험해보세요.
      </div>
      <div class="view-text">로그인하기</div>
      <hr class="hr-line">
    </div>
  </div>

  <!-- 기업 로그인 -->
  <div class="login-box" onclick="location.href='businesssignup'">
    <div class="img-wrap">
      <img src="./image/기업로그인.png" alt="기업 로그인 이미지">
    </div>
    <div class="text-box">
      <div class="title">기업 로그인</div>
      <div class="subtitle">Business Account Login</div>
      <div class="description">
        기업 회원 전용 로그인입니다.<br>
        가게 등록 및 추천 코스 관리 기능을 제공합니다.
      </div>
      <div class="view-text">로그인하기</div>
      <hr class="hr-line">
    </div>
  </div>
</div>

</body>
</html>
