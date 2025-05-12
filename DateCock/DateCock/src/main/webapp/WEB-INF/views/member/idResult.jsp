<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기 결과</title>
<%-- 1. CSS 파일 링크 추가 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
<style>
    /* 결과 내용 컨테이너 */
    .result-content {
        padding: 50px 0; /* 위아래 여백 늘림 */
        text-align: center;
        color: #333; /* (수정!) 기본 텍스트: 검은색 계열 */
        font-size: 18px; /* (수정!) 기본 글자 크기 키움 */
        line-height: 1.7; /* 줄간격 */
        font-family: 'Noto Sans KR', 'Open Sans', sans-serif; /* 가독성 좋은 글꼴 */
        font-weight: 500; /* 약간 두껍게 */
    }
    /* 결과 없음 또는 오류 메시지 */
    .result-content .inquiry,
    .result-content .error-message {
        color: #dc3545; /* (수정!) 표준 오류 빨간색 */
        font-weight: bold;
        font-size: 17px; /* 크기 약간 조정 */
    }
    /* 성공 메시지 텍스트 (아이디 제외) */
    .result-content .success-message {
        color: #333; /* 기본 텍스트 색상 */
        /* 특별한 스타일 없이 기본 텍스트와 어우러지도록 */
        display: inline; /* 줄바꿈 방지 */
    }
    /* 찾은 아이디 강조 */
    .result-content .found-id {
        color: #007bff; /* (수정!) 파란색 계열 */
        font-weight: bold;
        font-size: 24px; /* (수정!) 아이디 부분 더 크게 강조 */
        display: inline-block; /* 독립적인 스타일 적용 용이 */
        margin: 0 5px; /* 앞뒤 여백 */
        padding: 2px 5px; /* 약간의 내부 여백 (선택) */
        background-color: #e7f3ff; /* 연한 하늘색 배경 (선택) */
        border-radius: 4px; /* 모서리 둥글게 (선택) */
    }
    /* 버튼 영역 */
    .result-button-wrap {
        margin-top: 35px; /* 버튼 위 여백 늘림 */
        text-align: center; /* 버튼 가운데 정렬 */
    }
    /* 버튼 자체 스타일 (style.css의 .button 스타일 상속) */
    .result-button-wrap .button {
         width: auto; /* 버튼 너비 내용에 맞게 */
         min-width: 160px; /* 최소 너비 지정 */
         padding: 12px 30px; /* 버튼 내부 패딩 조정 */
         display: inline-block;
         margin: 5px; /* 버튼 간 간격 */
    }
</style>
</head>
<body>

<%-- 2. 기본 레이아웃 구조 적용 --%>
<div class="login-wrap">
    <div class="login-html">
        <%-- 탭은 없으므로 login-form을 내용 컨테이너로 바로 사용 --%>
        <div class="login-form">

            <%-- 3. 결과 표시 영역 스타일링 --%>
            <div class="result-content">
                <c:choose>
                    <c:when test="${empty foundId}">
                        <%-- 결과 없음 또는 오류 메시지 --%>
                        <c:choose>
                            <c:when test="${not empty idSearchError}">
                                <p class="error-message">${idSearchError}</p>
                            </c:when>
                            <c:otherwise>
                                <p class="inquiry">조회결과가 없습니다.</p>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <%-- 아이디 찾기 성공 메시지 --%>
                        <p class="success-message">
                            회원님의 아이디는<br>
                            [ <span class="found-id"><c:out value="${foundId}"/></span> ]<br>
                            입니다.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- 4. 버튼 스타일링 적용 --%>
            <div class="group result-button-wrap">
                 <%-- CSS의 .button 클래스 적용 --%>
                <button type="button" class="button" onclick="location.href='${pageContext.request.contextPath}/memberinput'">로그인 하러 가기</button>
            </div>
			<div class="group result-button-wrap">	
				 <button type="button" class="button" onclick="location.href='${pageContext.request.contextPath}/membersearch'">이전 페이지로</button>
			</div>	 
             <%-- 필요하다면 구분선 추가 --%>
             <div class="hr" style="margin-top: 40px;"></div>
                <%-- (추가!) 로고 영역 --%>
             <div class="logo-area" style="text-align: center; margin-top: 30px; margin-bottom: 20px;">
                <img src="${pageContext.request.contextPath}/image/DateCocklogo.png" alt="DATECOCK 로고"
                     style="max-width: 250px; height: auto;">
                     <%-- ↑↑↑ style 속성 추가: 크기 조절 --%>
                     <%-- max-width 값을 조절하여 원하는 최대 너비(예: 150px, 200px)로 설정하세요. --%>
                     <%-- height: auto; 는 너비에 맞춰 높이를 자동 조절합니다. --%>
            </div>
             
             

        </div> <%-- login-form 끝 --%>
    </div> <%-- login-html 끝 --%>
</div> <%-- login-wrap 끝 --%>

</body>
</html>