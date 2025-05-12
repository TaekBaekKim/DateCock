<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="t" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title><t:insertAttribute name="title"/></title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    html, body {
      width: 100%;
      height: 100%;
      min-height: 100vh;
      overflow-x: hidden;
      font-family: 'Noto Sans KR', sans-serif;
      display: flex;
      flex-direction: column;
    }

    .layout-wrapper {
      display: flex;
      flex: 1;
      flex-direction: row;
    }

    #top {
      width: 250px;
      flex-shrink: 0;
      background-color: rgb(255, 245, 245);
      position: fixed;
      top: 0;
      bottom: 0;
      left: 0;
      z-index: 1000;
      border-right: 1px solid #ddd;
    }

    /* 사이드바 있을 때 */
    #body.with-sidebar {
      flex: 1;
      margin-left: 250px;
      background-color: #f8f1f1;
      padding: 0;
      min-height: 100%;
    }

    /* 사이드바 없을 때 */
    #body.no-sidebar {
      flex: 1;
      margin-left: 0;
      background-color: #f8f1f1;
      padding: 0;
      min-height: 100%;
    }

    #footer {
      background-color: rgb(253,166,165);
      color: white;
      font-weight: lighter;
      font-size: 15px;
      font-family: 'NanumSquareRound';
      line-height: 20px;
      margin-top: auto;
      box-sizing: border-box;
      width: 100%;
    }

    /* footer 내부 정렬도 sidebar 유무에 따라 조절 */
    .footer-inner.with-sidebar {
      padding: 30px;
      padding-left: 250px;
    }

    .footer-inner.no-sidebar {
      padding: 30px;
      padding-left: 0;
    }
	
	.cursor-circle { /*마우스 커서 */
  width: 40px;
  height: 40px;
  border: 2px solid #ffa5c3;
  border-radius: 50%;
  position: fixed;
  top: 0;
  left: 0;
  pointer-events: none;
  z-index: 9999;
  transition: transform 0.1s ease;
}
  </style>
</head>
<body>
  <!-- 마우스 커서 원  -->
  <div class="cursor-circle"></div>

  <div class="layout-wrapper">
    <!-- 사이드바 조건 -->
    <c:if test="${empty notop}">
      <div id="top">
        <t:insertAttribute name="top" ignore="true" />
      </div>
    </c:if>

    <!-- 본문 영역 -->
    <c:choose>
      <c:when test="${empty notop}">
        <div id="body" class="with-sidebar">
          <t:insertAttribute name="body" ignore="true" />
        </div>
      </c:when>
      <c:otherwise>
        <div id="body" class="no-sidebar">
          <t:insertAttribute name="body" ignore="true" />
        </div>
      </c:otherwise>
    </c:choose>
  </div>

  <!-- footer 영역 -->
  <c:if test="${empty nofooter}">
    <div id="footer">
      <div class="footer-inner ${empty notop ? 'with-sidebar' : 'no-sidebar'}">
        <t:insertAttribute name="footer" ignore="true" />
      </div>
    </div>
  </c:if>




  <!-- 마우스 커서 이동 스크립트  -->
  <script>
    window.addEventListener('DOMContentLoaded', () => {
      const cursor = document.querySelector('.cursor-circle');

      document.addEventListener('mousemove', e => {
        cursor.style.left = e.clientX - 20 + 'px';
        cursor.style.top = e.clientY - 20 + 'px';
      });
    });
  </script>
</body>


</html>
