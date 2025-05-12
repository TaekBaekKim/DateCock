<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>지난 데이트</title>
  <style>
    body {
      margin: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #f3f3f3;
    }
    .container {
      max-width: 900px;
      margin: 40px auto;
      padding: 0 20px;
    }
    .date-box {
      background-color: #fff;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      margin-bottom: 30px;
      overflow: hidden;
      border: 1px solid #eee;
    }
    .box-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16px 20px;
      border-bottom: 1px solid #eee;
      font-size: 16px;
      font-weight: bold;
    }
    .box-header .link {
      font-size: 14px;
      color: #007bff;
      cursor: pointer;
      text-decoration: underline;
    }
    .box-body {
      display: flex;
      padding: 20px;
    }
    .box-body img {
      width: 180px;
      height: 130px;
      object-fit: cover;
      border-radius: 8px;
      margin-right: 20px;
    }
    .info-area {
      display: flex;
      flex-direction: column;
      justify-content: center;
      gap: 8px;
      font-size: 15px;
      color: #333;
    }
    .info-title {
      font-size: 17px;
      font-weight: bold;
    }
    .pink-btn {
      width: 100%;
      padding: 14px;
      text-align: center;
      background-color: #ffb6d1;
      color: #fff;
      border: none;
      font-size: 15px;
      font-weight: bold;
      cursor: pointer;
      transition: background-color 0.3s;
    }
    .pink-btn:hover {
      background-color: #ff4f9a;
    }
  </style>
</head>
<body>
<div class="container">
  <h2 style="text-align:center; margin-bottom: 40px;">지난 데이트 기록</h2>

  <c:forEach items="${list}" var="result">
    <div class="date-box">
      <div class="box-header">
        <div><fmt:formatDate value="${result.day}" pattern="yyyy.MM.dd (E)" /></div>
       <form action="datereservation" method="get" style="display:inline;">
  <input type="hidden" name="businessname" value="${result.businessname}" />
  <button type="submit" class="link" style="background:none; border:none; padding:0; font-size:14px; text-decoration:underline; color:#007bff; cursor:pointer;">
    상세보기
  </button>
</form>
      </div>
      <div class="box-body">
        <img src="./image/${result.image}" alt="이미지">
        <div class="info-area">
          <div class="info-title">${result.businessname}</div>
          <div>예약일시: <fmt:formatDate value="${result.day}" pattern="yyyy-MM-dd" /> ${result.intime}</div>
          <div>인원: 2명 기준</div>
        </div>
      </div>
       <form action="datereservation" method="get" style="margin: 0;">
    <input type="hidden" name="businessname" value="${result.businessname}" />
    <button type="submit" class="pink-btn">후기 작성</button>
  </form>
    </div>
  </c:forEach>

  <c:if test="${empty list}">
    <div class="date-box">
      <div class="box-body" style="justify-content: center;">
        지난 데이트 내역이 없습니다.
      </div>
    </div>
  </c:if>
</div>
</body>
</html>
