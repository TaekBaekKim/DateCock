<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="t" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><t:insertAttribute name="title" ignore="true" defaultValue="DateCock"/></title> <%-- 기본 제목 설정 --%>

<%-- (필수!) 외부 메인 CSS 파일 링크 --%>
<%-- 이 파일 안에 body 배경 이미지 설정이 있어야 합니다. --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

<%-- (추천!) 웹 폰트 링크 (필요시) --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
<%-- NanumSquareRound 폰트도 사용한다면 링크 추가 필요 --%>
<link href="https://hangeul.pstatic.net/hangeul_static/css/nanum-square-round.css" rel="stylesheet">


<%-- 레이아웃 자체 스타일 --%>
<style type="text/css">
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }

  html {
      height: 100%; /* html 높이 설정 */
  }

  body {
    width: 100%;
    min-height: 100%; /* 최소 높이를 100%로 설정 */
    overflow-x: hidden;
    /* background-color: rgb(248,241,241); */ /* <-- ### 제거 ### */
    font-family: 'Noto Sans KR', sans-serif; /* 기본 글꼴 */
    display: flex; /* Flexbox 레이아웃 사용 */
    flex-direction: column; /* 자식 요소들을 세로로 배치 */
    /* 외부 CSS에서 설정된 body 배경 이미지가 적용됩니다. */
  }

  .layout-wrapper {
    display: flex; /* 사이드바와 메인 컨텐츠를 가로로 배치 */
    flex: 1; /* 남은 세로 공간을 모두 차지 */
    /* height 관련 속성 제거 또는 min-height 사용 고려 */
  }

  #top { /* 사이드바 */
    width: 250px; /* 고정 너비 */
    flex-shrink: 0; /* 줄어들지 않음 */
    background-color: rgb(255, 245, 245); /* 사이드바 배경색 */
    /* 필요시 사이드바 내용 스크롤 */
    /* overflow-y: auto; */
  }

  #body { /* 메인 컨텐츠 영역 (Tiles body 삽입) */
    flex: 1; /* 남은 가로 공간 모두 차지 */
    /* background-color: #f8f1f1; */ /* <-- ### 제거 ### */
    background-color: transparent; /* 명시적으로 투명 설정 */
    padding: 20px; /* 컨텐츠 영역 내부 여백 (조절 가능) */
    margin: 0;
    box-sizing: border-box; /* 패딩 포함하여 크기 계산 */
  }

  #footer { /* 푸터 */
    /* padding: 20px 30px; */ /* 내부 패딩은 footer-inner에서 */
    background-color: rgb(253,166,165); /* 푸터 배경색 */
    color: white;
    width: 100%;
    box-sizing: border-box;
    /* margin-top: auto; */ /* flex-direction: column에서는 불필요 */
  }

  .footer-inner { /* 푸터 내용 컨테이너 */
    /* 사이드바 유무에 따라 너비/마진 동적 처리 필요 */
    /* 여기서는 일단 기본 레이아웃 기준으로 작성 */
    width: calc(100% - 250px);  /* 사이드바 너비 제외 */
    margin-left: 250px;         /* 사이드바 너비만큼 왼쪽 여백 */
    padding: 20px 30px; /* 푸터 내부 여백 */
    color: white;
    font-weight: lighter;
    font-size: 15px;
    font-family: 'NanumSquareRound', sans-serif; /* 푸터 글꼴 */
    line-height: 22px;
    box-sizing: border-box;
  }

  /* 사이드바가 없는 페이지를 위한 푸터 스타일 (body에 특정 클래스가 없을 때) */
  body:not(.has-sidebar) #footer .footer-inner {
       width: 100%;
       margin-left: 0;
  }


  /* 페이지별 컨텐츠 영역 기본 스타일 (필요시 사용) */
  .datecourse-section {
    padding: 40px;
    background-color: #fff; /* 컨텐츠 영역 배경 흰색 */
    border-radius: 8px;
  }
</style>
</head>
<%-- body 클래스: 사이드바 유무에 따라 footer 스타일 조절하기 위함 (선택적) --%>
<body class="${empty notop ? 'has-sidebar' : ''}">

  <div class="layout-wrapper">
    <%-- Top (사이드바) 영역 --%>
    <c:if test="${empty notop}">
      <div id="top">
        <%-- ignore="true": top 속성이 Tiles definition에 없어도 오류 발생 안 함 --%>
        <t:insertAttribute name="top" ignore="true" />
      </div>
    </c:if>

    <%-- Body (메인 컨텐츠) 영역 --%>
    <%-- 이 div(#body)의 배경이 투명해져서 body 태그의 배경 이미지가 보임 --%>
    <c:if test="${empty nobody}">
      <div id="body">
        <t:insertAttribute name="body" ignore="true" />
      </div>
    </c:if>
    <%-- nobody=true 이면 이 영역 자체가 렌더링 안 됨 --%>

  </div> <%-- layout-wrapper 끝 --%>


  <%-- Footer 영역 --%>
  <c:if test="${empty nofooter}">
    <div id="footer">
      <div class="footer-inner">
        <t:insertAttribute name="footer" ignore="true" />
      </div>
    </div>
  </c:if>

</body>
</html>