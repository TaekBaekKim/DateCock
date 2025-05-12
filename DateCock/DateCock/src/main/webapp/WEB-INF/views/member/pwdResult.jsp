<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기 결과</title>
<%-- 1. CSS 파일 링크 추가 (idResult.jsp와 동일) --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
<style>
    /* 결과 내용 컨테이너 (idResult.jsp 스타일 재사용) */
    .result-content {
        padding: 50px 0;
        text-align: center;
        color: #333;
        font-size: 18px;
        line-height: 1.7;
        font-family: 'Noto Sans KR', 'Open Sans', sans-serif;
        font-weight: 500;
    }
    /* 오류 메시지 (idResult.jsp 스타일 재사용) */
    .result-content .error-message {
        color: #dc3545;
        font-weight: bold;
        font-size: 17px;
    }
    /* 성공 메시지 텍스트 (아이디/비밀번호 제외) */
    .result-content .success-message {
        color: #333;
        display: inline;
    }
    /* 임시 비밀번호 강조 스타일 (새로 정의 또는 .found-id 와 유사하게) */
    .result-content .temporary-pwd {
        color: #df4759; /* 비밀번호는 좀 더 강조되는 색상 사용 (예: 빨간색 계열) */
        font-weight: bold;
        font-size: 24px;
        display: inline-block;
        margin: 0 5px;
        padding: 2px 5px;
        background-color: #ffebee; /* 연한 핑크/빨강 배경 (선택) */
        border-radius: 4px;
    }
    /* 사용자 아이디 강조 (선택적) */
    .result-content .user-id {
        color: #007bff; /* 파란색 계열 */
        font-weight: bold;
    }
    /* 추가 안내 문구 */
    .result-content .info-message {
        font-size: 15px; /* 약간 작은 글씨 */
        color: #555;
        margin-top: 15px; /* 위쪽 여백 */
    }
    /* 버튼 영역 (idResult.jsp 스타일 재사용) */
    .result-button-wrap {
        margin-top: 35px;
        text-align: center;
    }
    /* 버튼 자체 스타일 (idResult.jsp 스타일 재사용) */
    .result-button-wrap .button {
         width: auto;
         min-width: 160px;
         padding: 12px 30px;
         display: inline-block;
         margin: 5px;
    }
</style>
</head>
<body>

<%-- 2. 기본 레이아웃 구조 적용 (idResult.jsp와 동일) --%>
<div class="login-wrap">
    <div class="login-html">
        <%-- 탭은 없으므로 login-form을 내용 컨테이너로 바로 사용 --%>
        <div class="login-form">

            <%-- 3. 결과 표시 영역 --%>
            <div class="result-content">
                <c:choose>
                    <%-- 3a. 컨트롤러에서 설정한 명시적 오류 메시지 확인 --%>
                    <c:when test="${not empty pwdSearchErrorOnResult}">
                        <p class="error-message">${pwdSearchErrorOnResult}</p>
                    </c:when>
                    <c:when test="${not empty msg}"> <%-- 일반적인 예외 메시지 --%>
                        <p class="error-message">${msg}</p>
                    </c:when>

                    <%-- 3b. 임시 비밀번호 발급 성공 메시지 확인 --%>
                    <c:when test="${tempPasswordGenerated == true}">
                        <p class="success-message">
                            <span class="user-id"><c:out value="${targetUserId}"/></span>님의 임시 비밀번호가 발급되었습니다.<br>
                            임시 비밀번호는 [ <span class="temporary-pwd"><c:out value="${temporaryPassword}"/></span> ] 입니다.<br>
                        </p>
                        <p class="info-message">
                            로그인 후 반드시 비밀번호를 변경해주세요.
                        </p>
                    </c:when>

                    <%-- 3c. 위 조건에 모두 해당하지 않는 경우 (예: 알 수 없는 실패) --%>
                    <c:otherwise>
                        <p class="error-message">비밀번호 재설정에 실패했습니다. 다시 시도해주세요.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- 4. 버튼 영역 (idResult.jsp와 동일) --%>
            <div class="group result-button-wrap">
                <button type="button" class="button" onclick="location.href='${pageContext.request.contextPath}/memberinput'">로그인 하러 가기</button>
            </div>
            <%-- 이전 페이지로 가는 버튼은 비밀번호 찾기 결과에서는 불필요할 수 있어 제외 (필요 시 추가) --%>
            <%--
            <div class="group result-button-wrap">
                 <button type="button" class="button" onclick="location.href='${pageContext.request.contextPath}/membersearch'">이전 페이지로</button>
            </div>
            --%>

            <%-- 구분선 및 로고 (idResult.jsp와 동일) --%>
            <div class="hr" style="margin-top: 40px;"></div>
             <div class="logo-area" style="text-align: center; margin-top: 30px; margin-bottom: 20px;">
                <img src="${pageContext.request.contextPath}/image/DateCocklogo.png" alt="DATECOCK 로고"
                     style="max-width: 250px; height: auto;">
            </div>

        </div> <%-- login-form 끝 --%>
    </div> <%-- login-html 끝 --%>
</div> <%-- login-wrap 끝 --%>

</body>
</html>