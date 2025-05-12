<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
  .result-box {
    display: flex;
    background-color: rgba(255, 255, 255, 0.85);
    border-radius: 16px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    overflow: hidden;
    max-width: 1000px;
    margin: 20px auto;
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
<h2 style="color:white">추천된 데이트코스</h2>
<c:forEach var="item" items="${resultList}">
  <div class="result-box">
    <div class="result-image">
      <img src="<c:url value='/image/${item.image}'/>" alt="${item.businessname}" />
    </div>
    <div class="result-info">
      <div class="tag"></div>
      <h2>${item.businessname}</h2>
      <hr>
      <p>주소: ${item.address}</p>
      <p>영업시간: ${item.businesstime}</p>
      <p>전화번호: ${item.phone}</p>
      <p>추가정보: ${item.information}</p>
    </div>
    <div class="result-button">
      <button class="reserve-btn" onclick="location.href='datereservation?businessname=${item.businessname}'">예약하기</button>
    </div>
  </div>
</c:forEach>
