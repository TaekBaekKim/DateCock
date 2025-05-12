<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 비밀번호 찾기</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
    .server-message { color: #00e600; text-align: center; font-weight: bold; margin-top: 10px; }
    .server-error { color: #ff4d4d; text-align: center; font-weight: bold; margin-top: 10px; }
    .input { padding: 10px; width: 100%; margin: 5px 0; }
    .button { padding: 10px 20px; margin-top: 10px; cursor: pointer; }
    .step-1, .step-2, .step-3 { display: none; }
    #emailResultMsg { margin-top: 10px; font-size: 0.9em; font-weight: bold; }
    .result-box {
        background: rgba(255,255,255,0.9);
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        text-align: center;
        margin-top: 20px;
    }
    .result-box p { font-size: 18px; margin: 20px 0; }
    .result-box strong { font-size: 24px; color: #FF5597; }
    .result-box .button {
        margin-top: 30px;
        background: #FF5597;
        color: white;
        padding: 12px 24px;
        border: none;
        border-radius: 30px;
        font-size: 16px;
        cursor: pointer;
        transition: background 0.3s ease;
    }
    .result-box .button:hover { background: #e34281; }
    .signature {
        margin-top: 20px;
        font-style: italic;
        color: #777;
        font-size: 14px;
    }
    .recommend-wrapper { /* 배경화면 밑에 코드 css 넣어주고 body 처음 부터 <div class="recommend-wrapper">로 감싸주면 됌*/
      background: url('<c:url value="/image/ivent1.png" />') no-repeat center center fixed;
      background-size: cover;
      min-height: 100vh;
      padding: 60px 0;
    }
</style>
</head>
<body>
 <div class="recommend-wrapper">
<div class="login-wrap">
    <div class="login-html">
        <input id="tab-1" type="radio" name="tab" class="sign-in" checked>
        <label for="tab-1" class="tab">아이디 찾기</label>
        <input id="tab-2" type="radio" name="tab" class="sign-up">
        <label for="tab-2" class="tab">비밀번호 찾기</label>
        
        <div class="login-form">
        
            <div class="sign-in-htm">
                <form action="${pageContext.request.contextPath}/businessfindA" method="get">
                    <div class="group">
                        <label class="label">대표자명</label>
                        <input type="text" name="businessname" class="input" required>
                    </div>
                    <div class="group">
                        <label class="label">이메일</label>
                        <input type="email" name="email" class="input" required>
                    </div>
                    <div class="group">
                        <button type="submit" class="button">사업자등록번호 찾기</button>
                    </div>
                    <div class="group">
                        <button onclick="location.href='${pageContext.request.contextPath}/main'" class="button">돌아가기</button>
                    </div>
                    <c:if test="${not empty idSearchError}">
                        <div class="server-error">${idSearchError}</div>
                    </c:if>
                    <c:if test="${not empty findId}">
                        <div class="server-message">찾은 사업자등록번호: <strong>${findId.businessnumber}</strong></div>
                    </c:if>
                </form>
            </div>

            <div class="sign-up-htm">
                <div class="step-1">
                    <div class="group">
                        <label class="label">사업자등록번호</label>
                        <input type="text" id="businessnumber" class="input" placeholder="사업자등록번호 입력">
                    </div>
                    <div class="group">
                        <button id="step1Btn" class="button" type="button">다음</button>
                    </div>
                    <div class="group">
                        <button onclick="location.href='${pageContext.request.contextPath}/main'" class="button">돌아가기</button>
                    </div>
                </div>
                <div class="step-2">
                    <div class="group">
                        <label class="label">이메일</label>
                        <input type="email" id="email" name="email" class="input" placeholder="이메일 입력">
                    </div>
                    <div class="group">
                        <button id="sendCodeBtn" class="button" type="button">인증번호 요청</button>
                    </div>
                    <div id="emailResultMsg" class="server-message"></div>
                    <div class="group">
                        <label class="label">인증번호</label>
                        <input type="text" id="inputCode" class="input" placeholder="인증번호 입력">
                    </div>
                    <div class="group">
                        <button id="verifyCodeBtn" class="button" type="button">확인</button>
                    </div>
                    <div class="group">
                        <button onclick="location.href='${pageContext.request.contextPath}/main'" class="button">돌아가기</button>
                    </div>
                </div>
                <div class="step-3">
                    <div class="result-box">
                        <p>임시 비밀번호는 다음과 같습니다:</p>
                        <p><strong id="tempPw"></strong></p>
                        <p>로그인 후 반드시 비밀번호를 변경해주세요.</p>
                        <p class="signature">비밀번호는 운명이다.</p>
                        <button class="button" onclick="location.href='${pageContext.request.contextPath}/main'">메인으로</button>
                    </div>
                </div>
                <div class="hr"></div>
                <div class="foot-lnk">
                    <label for="tab-1">아이디 찾으러 가기</label>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
<script>
$(document).ready(function () {
    $(".step-1").show();

    const url = new URL(window.location.href);
    const tabParam = url.searchParams.get("tab");
    const modelTab = "${tab}";

    if (tabParam === "pw" || modelTab === "pw") {
        $("#tab-2").prop("checked", true);
        localStorage.setItem("activeTab", "tab-2");
    } else {
        $("#tab-1").prop("checked", true);
        localStorage.setItem("activeTab", "tab-1");
    }

    $("#tab-1").click(() => localStorage.setItem("activeTab", "tab-1"));
    $("#tab-2").click(() => localStorage.setItem("activeTab", "tab-2"));

    $("#step1Btn").click(function () {
        const num = $("#businessnumber").val();
        if (!num) return alert("사업자등록번호를 입력해주세요.");
        $.post("${pageContext.request.contextPath}/businessfindpwA", { businessnumber: num }, function (res) {
            if (res === "success") {
                $(".step-1").hide();
                $(".step-2").show();
            } else {
                alert("등록되지 않은 사업자번호입니다.");
            }
        });
    });

    $("#sendCodeBtn").click(function () {
        const email = $("#email").val();
        if (!email) {
            $("#emailResultMsg").text("이메일을 입력해주세요.").removeClass("server-message").addClass("server-error");
            return;
        }
        $.post("${pageContext.request.contextPath}/businessfindpwB", { email: email }, function (res) {
            if (res === "success") {
                $("#emailResultMsg").text("인증번호가 이메일로 전송되었습니다.").removeClass("server-error").addClass("server-message");
            } else if (res === "nomatch") {
                $("#emailResultMsg").text("이메일과 사업자번호가 일치하지 않습니다.").removeClass("server-message").addClass("server-error");
            } else {
                $("#emailResultMsg").text("이메일 전송 중 오류가 발생했습니다.").removeClass("server-message").addClass("server-error");
            }
        });
    });

    $("#verifyCodeBtn").click(function () {
        const code = $("#inputCode").val();
        if (!code) return alert("인증번호를 입력해주세요.");
        $.post("${pageContext.request.contextPath}/businessfindpwC", { inputCode: code }, function (res) {
            if (res.startsWith("tempPw:")) {
                $(".step-2").hide();
                $("#tempPw").text(res.split(":")[1]);
                $(".step-3").show();
            } else {
                alert("인증번호가 올바르지 않습니다.");
            }
        });
    });
});
</script>
</body>
</html>
