<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
  String uri = request.getRequestURI();
%>

<!DOCTYPE html>
<html>
<head>
  <title>메뉴바</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style type="text/css">
    body {
      margin: 0;
      font-family: 'Gowun Dodum', sans-serif;
      display: flex;
      height: 100vh;
    }

    .sidebar {
      width: 250px;
      background-color: rgb(253, 242, 241); 
      color: #333;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding-top: 30px;
      position: fixed;
      top: 0;
      bottom: 0;
      left: 0;
      border-right: 1px solid #ddd;
    }

    .logo {
      width: 180px;
      height: 180px;
      margin-bottom: 10px;
    }

    .logo img {
      width: 100%;
      height: 100%;
      object-fit: contain;
    }

    .site-name {
      font-size: 22px;
      font-weight: bold;
      color: #ff4f9a;
      margin-bottom: 40px;
    }

    .menu {
      list-style: none;
      padding: 0;
      width: 100%;
      text-align: center;
    }

    .menu li {
      margin: 28px 0;
    }

    .menu a {
      text-decoration: none;
      color: #444;
      font-size: 16px;
      transition: all 0.3s;
    }

    .menu a:hover {
      color: #ff4f9a;
      font-weight: bold;
    }

    .menu .active {
      color: #ff4f9a;
      font-weight: bold;
    }

    .content {
      margin-left: 250px;
      padding: 30px;
      flex: 1;
      background-color: #f7f7f7;
    }
  </style>
</head>
<body>

<div class="sidebar">
  <div class="logo">
    <a href=""><img src="./image/DateCocklogo.png" alt="로고"></a> 
  </div>

  <ul class="menu">
    <c:choose>
      <c:when test="${personalloginstate == true}">
        <a href="businessmypage">${name} 님 어서오세요.</a>
        <li><a href="mypage">[ 마이 페이지 ] </a>
        <a href="logout">[ 로그아웃 ]</a></li>
        <li><a href="loginmain" class="<%= uri.endsWith("loginmain") ? "active" : "" %>">[ Home ]</a></li>
        <li><a href="datecourseout" class="<%= uri.endsWith("datecourseout") ? "active" : "" %>">[ 데이트코스 ]</a></li>
        <li><a href="recommendation" class="<%= uri.endsWith("about") ? "active" : "" %>">[ 데이트코스 추천 ]</a></li>
        <li><a href="game" class="<%= uri.endsWith("contact") ? "active" : "" %>">[ 하트 피하기 게임 ]</a></li>
        <li><a href="listup" class="<%= uri.endsWith("contact") ? "active" : "" %>">[ 커뮤니티 ]</a></li>
        <li><a href="support" class="<%= uri.endsWith("contact") ? "active" : "" %>">[ 고객센터 ]</a></li>
      </c:when>

      <c:when test="${buisnessloginstate == true}">
        <a href="businessmypage">${businessname} 대표님 어서오세요.</a>
        <li><a href="businessmypage">[ 마이 페이지 ] </a>
        <a href="businesslogout">[ 로그아웃 ]</a></li>
        <li><a href="loginmain" class="<%= uri.endsWith("loginmain") ? "active" : "" %>">[ Home ]</a></li>
        <li><a href="businessinput" class="<%= uri.endsWith("businessinput") ? "active" : "" %>">[ 가게 등록 ]</a></li>
        <li><a href="businessout" class="<%= uri.endsWith("businessout") ? "active" : "" %>">[ 내가 등록한 가게 정보 ]</a></li>
        <li><a href="support" class="<%= uri.endsWith("contact") ? "active" : "" %>">[ 고객센터 ]</a></li>
      </c:when>

      <c:otherwise>
        <li><a href="DateCocklog" class="<%= uri.endsWith("DateCocklog") ? "active" : "" %>">Login</a></li>
        <li><a href="main" class="<%= uri.endsWith("main") && !uri.contains("login") ? "active" : "" %>">[ Home ]</a></li>
        <li><a href="datecourseout" class="<%= uri.endsWith("datecourseout") ? "active" : "" %>">[ 데이트코스 ]</a></li>
        <li><a href="recommendation" class="<%= uri.endsWith("about") ? "active" : "" %>">[ 데이트코스 추천 ]</a></li>
        <li><a href="game" class="<%= uri.endsWith("contact") ? "active" : "" %>">[ 하트 피하기 게임 ]</a></li>
        <li><a href="listup" class="<%= uri.endsWith("contact") ? "active" : "" %>">[ 커뮤니티 ]</a></li>
        <li><a href="support" class="<%= uri.endsWith("contact") ? "active" : "" %>">[ 고객센터 ]</a></li>
      </c:otherwise>
    </c:choose>
  </ul>
</div>
</body>
</html>