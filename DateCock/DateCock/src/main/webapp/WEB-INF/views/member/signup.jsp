<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- 네이버 로그인을 위한 import (추가) --%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<!DOCTYPE html>
<html>
<head>
<title>로그인 / 회원가입</title> <%-- 페이지 제목 수정 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type = "text/javascript">
$(document).ready(function(){
     // --- 상태 변수 (회원가입 폼 용도) ---
     var isPasswordMatch = false;
     var isIdCheckedAndAvailable = false;
     var isPasswordFormatValid = false;

     // --- 아이디 중복 확인 로직 (회원가입 폼) ---
     $("#idcheck").click(function(){
         var id = $("#id").val();
         if(!id){ alert("아이디를 입력해주세요."); $("#id").focus(); return; }
         $.ajax({
             type: "post",
             url: "${pageContext.request.contextPath}/idcheck2", // 컨텍스트 경로 추가
             data: {"id": id},
             async: true,
             success: function(data){
                 if(data == "yes"){
                     alert("사용 가능한 아이디입니다.");
                     isIdCheckedAndAvailable = true; // 상태 업데이트
                 } else {
                     alert("이미 사용 중이거나 사용할 수 없는 아이디입니다.");
                     isIdCheckedAndAvailable = false; // 상태 업데이트
                     $("#id").val('').focus();
                 }
             },
             error: function(){
                 alert("아이디 확인 중 오류 발생");
                 isIdCheckedAndAvailable = false; // 상태 업데이트
             }
         });
     });

    // 아이디 변경 시 확인 상태 초기화 (회원가입 폼)
     $("#id").on('keyup', function() {
         if (isIdCheckedAndAvailable) {
              console.log("아이디 변경됨, 중복 확인 필요");
         }
         isIdCheckedAndAvailable = false;
     });

    // --비밀번호 형식 검사 로직 (회원가입 폼)
    $("#pwd").on('keyup',function(){
        var pwd = $(this).val();
        var messageSpan = $("#pwd_rule_msg"); // 규칙메세지
        var specialCharRegex = /[!@#$%^&*(),.?":{}|<>]/;

        if(pwd.length == 0){
            messageSpan.hide();
            isPasswordFormatValid = false;
        }
        else if(specialCharRegex.test(pwd)){
            messageSpan.text("사용 가능한 비밀번호 형식입니다").css("color","green");
            messageSpan.show();
            isPasswordFormatValid = true;
        }
        else{
            messageSpan.text("비밀번호에 특수문자(!@#$%^&* 등)을 1개이상 포함해야합니다.").css("color","red");
            messageSpan.show();
            isPasswordFormatValid = false;
        }
        $("#pwd_confirm").trigger('keyup'); // 비밀번호 확인 필드도 검사
    });


     // --- 비밀번호 일치 확인 로직 (회원가입 폼) ---
     $("#pwd, #pwd_confirm").on('keyup', function(){
         var pwd = $("#pwd").val();
         var pwdConfirm = $("#pwd_confirm").val();
         var messageSpan = $("#pwd_confirm_msg");

         if (pwd || pwdConfirm) {
             if (pwd === pwdConfirm && pwd !== "") {
                 messageSpan.text("비밀번호가 일치합니다.").css("color", "green");
                 isPasswordMatch = true;
             } else {
                 messageSpan.text("비밀번호가 일치하지 않습니다.").css("color", "red");
                 isPasswordMatch = false;
             }
             messageSpan.show();
         } else {
             messageSpan.hide();
             isPasswordMatch = false;
         }
     });

     // --- 폼 제출 방지 로직 (회원가입 폼) ---
     $("#signupForm").on('submit', function(event){
         if (!isIdCheckedAndAvailable) {
             alert("아이디 중복 확인을 완료해주세요.");
             event.preventDefault();
             $("#id").focus();
             return false;
         }
         if (!isPasswordFormatValid) {
             alert("비밀번호 형식에 맞지 않습니다. 확인해주세요.");
             event.preventDefault();
             $("#pwd").focus(); // 비밀번호 필드로 포커스 변경
             return false;
         }
         if (!isPasswordMatch) {
             alert("비밀번호가 일치하지 않습니다. 확인해주세요.");
             event.preventDefault();
             $("#pwd_confirm").focus();
             return false;
         }
         return true; // 모든 검증 통과 시 제출
     });

}); // End $(document).ready()

// --- SNS 로그인 팝업 함수들 (수정: openPopup4, openPopup5 제거) ---
function openNaverLoginPopup(url) {
    var width = 400;
    var height = 600;
    var left = (screen.width - width) / 2;
    var top = (screen.height - height) / 2;
    var popupWindow = window.open(url, "NaverLoginPopup", "width="
            + width + ", height=" + height + ", left=" + left
            + ", top=" + top);
    if (popupWindow && popupWindow.focus) { // null 체크 추가
        popupWindow.focus();
    }
    return false;
}

function openPopup1() { // 카카오
    var width = 400;
    var height = 600;
    var left = (screen.width - width) / 2;
    var top = (screen.height - height) / 2;
    // 카카오 로그인은 실제 Kakao SDK나 REST API 호출 로직 필요
    // 아래는 단순히 카카오 로그인 페이지 링크 예시 (실제 구현 필요)
    window.open("https://accounts.kakao.com/login?continue=https%3A%2F%2Fkauth.kakao.com%2Foauth%2Fauthorize%3Fresponse_type%3Dcode%26redirect_uri%3DYOUR_REDIRECT_URI%26client_id%3DYOUR_REST_API_KEY", // 실제 Redirect URI와 Client ID 필요
            "KakaoLoginPopup", "width=" + width + ", height=" + height + ", left=" + left + ", top=" + top);
}

function openPopup2() { // 애플
    var width = 400;
    var height = 600;
    var left = (screen.width - width) / 2;
    var top = (screen.height - height) / 2;
    window.open("https://appleid.apple.com/sign-in", // 애플 로그인 페이지
            "AppleLoginPopup", "width=" + width + ", height=" + height + ", left=" + left + ", top=" + top);
}

function openPopup3() { // 페이스북
    var width = 400;
    var height = 600;
    var left = (screen.width - width) / 2;
    var top = (screen.height - height) / 2;
    // 페이스북 SDK 또는 로그인 URL 사용 (실제 구현 필요)
    window.open("https://www.facebook.com/login/", // 페이스북 로그인 페이지
            "FacebookLoginPopup", "width=" + width + ", height=" + height + ", left=" + left + ", top=" + top);
}

// function openPopup4() { ... } // 페이코 로그인 함수 제거됨
// function openPopup5() { ... } // 휴대폰 본인 확인 함수 제거됨

</script>
<%-- CSS 스타일 추가 --%>
<style>
    .error-message {
        display: none; /* 기본적으로 숨김 */
        font-size: 0.8em; /* 글자 크기 작게 */
        margin-top: 5px; /* 위쪽 여백 */
        /* color: red; */ /* 색상은 JS에서 설정 */
    }
    .server-error { /* 서버 에러 메시지 스타일 */
        text-align: center; color: red; margin-bottom: 15px; font-weight: bold;
    }
    /* SNS 로그인 영역 스타일 추가 */
    .sns-login-section {
        margin-top: 25px; /* 로그인 버튼과의 간격 */
        text-align: center;
    }
    .sns-login-section h3 {
        font-size: 1em; /* 제목 크기 */
        color: #6a6f8c; /* 제목 색상 */
        margin-bottom: 15px;
        font-weight: 600;
    }
    .sns-buttons a { /* SNS 버튼(링크) 스타일 */
        display: inline-block;
        margin: 0 5px; /* 버튼 간 간격 */
        text-decoration: none;
    }
    .sns-buttons img { /* SNS 이미지 크기 등 */
        height: 45px; /* 이미지 높이 통일 */
        width: auto;  /* 너비는 비율에 맞게 자동 조절 */
        vertical-align: middle; /* 이미지 세로 정렬 */
    }
</style>
</head>
<body>

<c:if test="${not empty successMessage}">
	<script>alert("${successMessage}");</script>
</c:if>

    <div class="login-wrap">
        <div class="login-html">
            <input id="tab-1" type="radio" name="tab" class="sign-in" checked><label for="tab-1" class="tab">로그인</label>
            <input id="tab-2" type="radio" name="tab" class="sign-up"><label for="tab-2" class="tab">회원가입</label>
            <div class="login-form">
                <%-- ======== 로그인 폼 ======== --%>
                <form action="${pageContext.request.contextPath}/loginprocess" method="post">
                    <div class="sign-in-htm">
                        <div class="group">
                            <label for="loginId" class="label">아이디</label>
                            <input id="loginId" name="loginId" type="text" class="input">
                        </div>
                        <div class="group">
                            <label for="loginPw" class="label">비밀번호</label>
                            <input id="loginPw" name="loginPw" type="password" class="input" data-type="password">
                        </div>
           
                        <div class="group">
                            <input type="submit" class="button" value="로그인">
                        </div>
                        <div class="group">
                            <button type="button" class="button" onclick="location.href='${pageContext.request.contextPath}/main'">취소</button>
                        </div>

                        <%-- ============ SNS 로그인 영역 (수정: 페이코, 휴대폰 버튼 제거) ============ --%>
                        <div class="sns-login-section">
                            <h3 class="snslogin">SNS 아이디로 로그인하기</h3>
                            <div class="sns-buttons">
                                <%
                                // 네이버 로그인 설정
                                String clientId = "MnhBHBLKARB9smrs0fGA"; // 네이버 애플리케이션 클라이언트 아이디값 *** 반드시 본인 ID로 변경 ***
                                // *** 중요: 리다이렉트 URI는 네이버 개발자센터에 등록된 URI와 정확히 일치해야 함 ***
                                // 예시: http://localhost:8080/datecock/naverLoginCallback
                               String redirectURI = URLEncoder.encode("http://localhost:8080/datecock/naverLoginCallback", "UTF-8"); // 확인된 Callback URL 사용
                                SecureRandom random = new SecureRandom();
                                String state = new BigInteger(130, random).toString();
                                String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code" + "&client_id=" + clientId
                                        + "&redirect_uri=" + redirectURI + "&state=" + state;
                                session.setAttribute("state", state); // CSRF 공격 방지용 state 값 세션에 저장
                                %>
                                <a href="#" onclick="openNaverLoginPopup('<%=apiURL%>'); return false;">
                                    <img src="${pageContext.request.contextPath}/image/naver.svg" alt="네이버 로그인" />
                                </a>
                                <a href="#" onclick="openPopup1(); return false;">
                                    <img src="${pageContext.request.contextPath}/image/kakaotalk.png" alt="카카오 로그인" />
                                </a>
                                <a href="#" onclick="openPopup2(); return false;">
                                    <img src="${pageContext.request.contextPath}/image/apple.svg" alt="애플 로그인" />
                                </a>
                                <a href="#" onclick="openPopup3(); return false;">
                                    <img src="${pageContext.request.contextPath}/image/facebook.png" alt="페이스북 로그인" />
                                </a>
                                <%-- 페이코 로그인 버튼 제거됨 --%>
                                <%--
                                <a href="#" onclick="openPopup4(); return false;">
                                    <img src="${pageContext.request.contextPath}/image/payco.svg" alt="페이코 로그인" />
                                </a>
                                --%>
                                <%-- 휴대폰 본인 확인 버튼 제거됨 --%>
                                <%--
                                <a href="#" onclick="openPopup5(); return false;">
                                    <img src="${pageContext.request.contextPath}/image/phone.svg" alt="휴대폰 본인 확인" />
                                </a>
                                --%>
                            </div>
                        </div>
                        <%-- ============ SNS 로그인 영역 끝 ============ --%>

                        <div class="hr"></div>
                        <div class="foot-lnk">
                            <%-- 컨트롤러 매핑 확인: /membersearch --%>
                            <a href="${pageContext.request.contextPath}/membersearch">아이디 또는 비밀번호를 잊어버리셨습니까?</a>
                        </div>
                        <div class="logo-area" style="text-align: center; margin-top: 30px; margin-bottom: 20px;">
                             <img src="${pageContext.request.contextPath}/image/DateCocklogo.png" alt="DATECOCK 로고"
                                  style="max-width: 250px; height: auto;">
                        </div>
                    </div>
                </form>

                <%-- ======== 회원가입 폼 (기존 코드 유지) ======== --%>
                <form id="signupForm" action ="${pageContext.request.contextPath}/membersave" method="post">
                    <div class="sign-up-htm">
                        <c:if test="${not empty errorMessage}">
                             <div class="server-error">${errorMessage}</div>
                        </c:if>
                        <div class="group">
                            <label for="id" class="label">아이디</label>
                            <input id="id" name="id" type="text" class="input" required>
                            <button type="button" id="idcheck" class="button" style="margin-top: 10px; width: auto; padding: 5px 10px;">중복 확인</button>
                        </div>
                        <div class="group">
                            <label for="pwd" class="label">비밀번호</label>
                            <input id="pwd" name="pwd" type="password" class="input" required>
                            <span id="pwd_rule_msg" class="error-message"></span>
                        </div>
                        <div class="group">
                            <label for="pwd_confirm" class="label">비밀번호 확인</label>
                            <input id="pwd_confirm" name="pwd_confirm" type="password" class="input" required>
                            <span id="pwd_confirm_msg" class="error-message"></span>
                        </div>
                        <div class="group">
                            <label for="email" class="label">Email 주소</label>
                            <input id="email" name="email" type="email" class="input" required>
                        </div>
                        <div class="group">
                            <label for="name" class="label">이름</label>
                            <input id="name" name="name" type="text" class="input" required>
                        </div>
                        <div class="group">
                            <label for="birth" class="label">생년월일</label>
                            <input id="birth" name="birth" type="date" class="input" required>
                        </div>
                        <div class="group">
                            <label for="phone" class="label">전화번호</label>
                            <input id="phone" name="phone" type="tel" class="input" required>
                        </div>
                      
                        <div class="group">
                            <input type="submit" class="button" value="회원가입 완료">
                        </div>
                        <div class="hr"></div>
                         
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>