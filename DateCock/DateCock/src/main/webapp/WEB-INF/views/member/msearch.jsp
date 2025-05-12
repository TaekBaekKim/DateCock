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
<script type = "text/javascript">
$(document).ready(function(){
    var isEmailVerifiedForPwd = false; // 이메일 인증 완료 여부
    var pwdTimerInterval = null; // <<<--- *** 이 라인 추가! *** (타이머 ID 저장용 변수 선언 및 초기화)
    // var isPasswordFormatValid = false; // 회원가입용 변수 (msearch.jsp에는 불필요하면 삭제)
    // var isPasswordMatch = false; // 회원가입용 변수 (msearch.jsp에는 불필요하면 삭제)
    // var isIdCheckedAndAvailable = false; // 회원가입용 변수 (msearch.jsp에는 불필요하면 삭제)

    // --- 회원 확인 버튼 클릭 ---
    $("#checkMemberBtn").click(function(){
        var id = $("#findid").val(); // id="findid"
        var email = $("#searchemail1").val(); // id="searchemail1"

        // 입력값 검증
        var emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        if(!id){ alert("아이디를 입력해주세요."); $("#findid").focus(); return; }
        if(!email || !emailRegex.test(email)){ alert("올바른 이메일 주소를 입력해주세요."); $("#searchemail1").focus(); return; }

        var $checkBtn = $(this);
        var $checkResult = $("#memberCheckResult");
        var $verificationSection = $(".verification-section");

        $checkBtn.prop('disabled', true).text('확인 중...'); // 버튼 비활성화
        $checkResult.empty().removeClass('success fail').hide(); // 결과 메시지 초기화 및 숨김
        $verificationSection.slideUp(); // 인증 영역 숨기기

        // AJAX 요청: 회원 존재 여부 확인
        $.ajax({
            type: "POST",
            url: "${pageContext.request.contextPath}/checkMemberExists", // Controller 경로
            data: { findid: id, loginPw: email }, // name 속성 기준: findid, loginPw
            dataType: "json", // 서버 응답 타입
            success: function(response) {
                // response = { exists: true/false, message: "..." }
                if (response.exists) {
                    $checkResult.text(response.message || "회원 정보가 확인되었습니다.").addClass('success').show();
                    // 회원 확인 성공 -> 인증 영역 보여주기
                    $verificationSection.slideDown();
                    $checkBtn.hide(); // 회원 확인 버튼 숨기기
                    $("#findid, #searchemail1").prop('readonly', true); // 정보 수정 방지 (선택적)

                    // 인증번호 관련 초기화 (만약 재시도 가능하게 하려면 필요)
                     $("#sendCodeMsgPwd").empty();
                     $("#verifyCodePwd").val('').prop('disabled', true);
                     $("#verifyTimerMsgPwd").hide();
                     if (window.pwdTimerInterval) clearInterval(window.pwdTimerInterval);
                     $("#verifyCodeBtnPwd").prop('disabled', true).css('opacity', 0.5);
                     $("#verifyResultMsg").empty().removeClass('success fail');
                     isEmailVerifiedForPwd = false;
                     $("#findPwdSubmitBtn").prop('disabled', true);
                     $("#sendCodeBtnPwd").prop('disabled', false).css('opacity', 1).text('인증번호 발송'); // 발송 버튼 활성화

                } else {
                    $checkResult.text(response.message || "입력하신 정보와 일치하는 회원이 없습니다.").addClass('fail').show();
                    $checkBtn.prop('disabled', false).text('회원 확인'); // 버튼 다시 활성화
                }
            },
            error: function() {
                alert("회원 확인 중 오류가 발생했습니다.");
                $checkResult.text("오류 발생. 잠시 후 다시 시도해주세요.").addClass('fail').show();
                 $checkBtn.prop('disabled', false).text('회원 확인');
            }
        });
    }); // End of checkMemberBtn click

    // --- 인증번호 발송 버튼(#sendCodeBtnPwd) 클릭 이벤트 ---
    // --- 인증번호 확인 버튼(#verifyCodeBtnPwd) 클릭 이벤트 ---
    // --- 최종 폼 제출(#findPwdForm submit) 이벤트 ---
    // (이전 답변의 JavaScript 코드 참고하여 이어서 구현)
     // --- (구현) 인증번호 발송 버튼(#sendCodeBtnPwd) 클릭 이벤트 ---
    $("#sendCodeBtnPwd").click(function(){
         console.log("msearch.jsp: #sendCodeBtnPwd clicked.");
         var email = $("#searchemail1").val(); // 이미 검증된 상태 또는 읽기 전용
         var id = $("#findid").val();      // 이미 검증된 상태 또는 읽기 전용

         if(!id || !email){ alert("아이디와 이메일 정보가 필요합니다."); return; }

         var $sendBtn = $(this);
         var $sendMsg = $("#sendCodeMsgPwd");
         var $verifyInput = $("#verifyCodePwd");
         var $verifyBtn = $("#verifyCodeBtnPwd");
         var $timerMsg = $("#verifyTimerMsgPwd");

         // 이전 타이머 중지 및 UI 초기화
         if (pwdTimerInterval) 
         {
        	 clearInterval(pwdTimerInterval);
        	 console.log("msearch.jsp: Cleared previous timer.");
         }
         $sendBtn.prop('disabled', true).css('opacity', 0.5).text('발송 중..');
         $sendMsg.text("").removeClass('success fail'); // 메시지 스타일 초기화
         $timerMsg.hide();
         $verifyInput.val('').prop('disabled', true);
         $verifyBtn.prop('disabled', true).css('opacity', 0.5);
         isEmailVerifiedForPwd = false;
         $("#findPwdSubmitBtn").prop('disabled', true);
         $("#verifyResultMsg").empty().removeClass('success fail');

         console.log("msearch.jsp: Sending AJAX request to /sendVerificationCode...");
         // AJAX 요청 (인증번호 발송)
         $.ajax({
             type: "POST",
             url: "${pageContext.request.contextPath}/sendVerificationCode", // Controller 경로 확인
             data: { findid: id, loginPw: email }, // Controller @RequestParam과 일치
             dataType: "json",
             success: function(response){
                 console.log("msearch.jsp: /sendVerificationCode Response:", response);
                 if(response && response.success) {
                     $sendMsg.text(response.message || "인증번호가 발송되었습니다.").addClass('success').show();
                     $verifyInput.prop('disabled', false).focus(); // 입력 필드 활성화
                     $verifyBtn.prop('disabled', false).css('opacity', 1); // 확인 버튼 활성화
                     $sendBtn.text('인증번호 재발송'); // 재발송 버튼 텍스트 변경

                     // 타이머 시작 (예: 3분)
                     var timer = 180;
                     $timerMsg.show();
                     pwdTimerInterval = setInterval(function() { // 전역 또는 상위 스코프 변수에 할당
                          var minutes = Math.floor(timer / 60);
                          var seconds = timer % 60;
                          // 남은 시간이 0 이상일 때만 표시
                          if (timer >= 0) {
                             $timerMsg.text("남은 시간: " + minutes + "분 " + seconds + "초").css('color', '#FF5597');
                          }

                          if (--timer < 0) { // 타이머 종료
                              clearInterval(pwdTimerInterval);// 저장된 ID로 타이머 중지
                              $timerMsg.text("인증 시간이 만료되었습니다.").css('color', 'red');
                              $sendBtn.prop('disabled', false).css('opacity', 1).text('인증번호 발송'); // 재발송 가능
                              $verifyInput.prop('disabled', true);
                              $verifyBtn.prop('disabled', true).css('opacity', 0.5);
                              isEmailVerifiedForPwd = false;
                              $finalSubmitBtn.prop('disabled', true);
                          }
                      }, 1000);
                 } else {
                     $sendMsg.text(response.message || "인증번호 발송 실패").addClass('fail').show();
                     $sendBtn.prop('disabled', false).css('opacity', 1).text('인증번호 발송'); // 재시도 가능
                 }
             },
             error: function(jqXHR, textStatus, errorThrown){
                 console.error("msearch.jsp: /sendVerificationCode AJAX Error!");
                 console.error(">> textStatus:", textStatus);
                 console.error(">> errorThrown:", errorThrown);
                 console.error(">> HTTP Status Code:", jqXHR.status);
                 console.error(">> Response Text:", jqXHR.responseText);
                 alert("인증번호 발송 요청 오류 (콘솔 로그 확인)");
                 $sendMsg.text("요청 오류").addClass('fail').show();
                 $sendBtn.prop('disabled', false).css('opacity', 1).text('인증번호 발송');
             },
             complete: function() {
                 // 발송 중.. 상태가 아니라면 버튼 활성화 (성공/실패 시 이미 처리됨)
                 // if ($sendBtn.text() === '발송 중..') {
                 //     $sendBtn.prop('disabled', false).css('opacity', 1).text('인증번호 발송');
                 // }
             }
         });
    }); // End #sendCodeBtnPwd click


    // --- (구현) 인증번호 확인 버튼(#verifyCodeBtnPwd) 클릭 이벤트 ---
    $("#verifyCodeBtnPwd").click(function() {
        console.log("msearch.jsp: #verifyCodeBtnPwd clicked.");
        var code = $("#verifyCodePwd").val().trim();
        var email = $("#searchemail1").val(); // 사용 중인 이메일

        if(!code) { alert("인증번호를 입력해주세요."); $("#verifyCodePwd").focus(); return; }

        var $verifyBtn = $(this);
        var $verifyResult = $("#verifyResultMsg");
        var $finalSubmitBtn = $("#findPwdSubmitBtn");
        var $verifyInput = $("#verifyCodePwd");
        var $sendBtn = $("#sendCodeBtnPwd");
        var $timerMsg = $("#verifyTimerMsgPwd");

        $verifyBtn.prop('disabled', true).css('opacity', 0.5).text('확인 중..');
        $verifyResult.empty().removeClass('success fail');

        console.log("msearch.jsp: Sending AJAX request to /checkVerificationCode...");
        $.ajax({
            type: "POST",
            url: "${pageContext.request.contextPath}/checkVerificationCode", // Controller 경로 확인
            data: { code: code, loginPw: email }, // email은 loginPw로 전달
            dataType: "json",
            success: function(response){
                 console.log("msearch.jsp: /checkVerificationCode Response:", response);
                 if (response && response.verified) {
                    $verifyResult.text(response.message || "인증되었습니다.").addClass('success').show();
                    isEmailVerifiedForPwd = true; // 인증 성공 상태
                    $finalSubmitBtn.prop('disabled', false); // 최종 버튼 활성화

                    // 성공 시 관련 요소 비활성화
                    if (pwdTimerInterval) clearInterval(pwdTimerInterval); // 타이머 중지
                    $timerMsg.hide(); // 타이머 메시지 숨김
                    $verifyInput.prop('disabled', true); // 인증번호 입력칸 비활성화
                    $verifyBtn.prop('disabled', true).css('opacity', 0.5).text('인증 완료'); // 확인 버튼 비활성화 및 텍스트 변경
                    $sendBtn.prop('disabled', true).css('opacity', 0.5).text('인증 완료'); // 발송 버튼 비활성화
                 } else {
                    $verifyResult.text(response.message || "인증번호가 올바르지 않습니다.").addClass('fail').show();
                    isEmailVerifiedForPwd = false;
                    $verifyBtn.prop('disabled', false).css('opacity', 1).text('인증 확인'); // 확인 버튼 재활성화
                    $finalSubmitBtn.prop('disabled', true); // 최종 버튼 비활성화 유지
                 }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                 console.error("msearch.jsp: /checkVerificationCode AJAX Error!");
                 console.error(">> textStatus:", textStatus);
                 console.error(">> errorThrown:", errorThrown);
                 console.error(">> HTTP Status Code:", jqXHR.status);
                 console.error(">> Response Text:", jqXHR.responseText);
                 alert("인증번호 확인 중 오류 발생 (콘솔 로그 확인)");
                 $verifyResult.text("확인 오류").addClass('fail').show();
                 isEmailVerifiedForPwd = false;
                 $verifyBtn.prop('disabled', false).css('opacity', 1).text('인증 확인');
                 $finalSubmitBtn.prop('disabled', true);
            },
            complete: function() {
                 // 확인 중.. 상태가 아니라면 버튼 활성화 (성공/실패 시 이미 처리됨)
                 // if ($verifyBtn.text() === '확인 중..') {
                 //    $verifyBtn.prop('disabled', false).css('opacity', 1).text('인증 확인');
                 // }
            }
        });
    }); // End #verifyCodeBtnPwd click


    // --- (구현!) 최종 폼 제출(#findPwdForm submit) 이벤트 ---
    $("#findPwdForm").on('submit', function(event){
        console.log("msearch.jsp: #findPwdForm submit triggered.");
        if (!isEmailVerifiedForPwd) {
            alert("이메일 인증을 완료해주세요.");
            event.preventDefault(); // 폼 제출 중단
            console.log("msearch.jsp: Form submission prevented (email not verified).");
            // $("#verifyCodePwd").focus(); // 필요시 포커스
            return false; // 제출 중단
        }
        // isEmailVerifiedForPwd가 true이면 기본 submit 동작 허용
        console.log("msearch.jsp: Email verified, allowing form submission to /searchpwd.");
        // 여기서 form 태그의 action인 /searchpwd 로 제출됨
        return true; // 제출 진행
    });
    
    
    
    

    // --- 페이지 로드 시 초기 상태 ---
    $(".verification-section").hide(); // 인증 영역 숨기기

}); // end document.ready

</script>
<style>
    /* 서버 결과/오류 메시지 스타일 */
    .server-message {
        text-align: center;
        color: white; /* 성공 메시지 또는 일반 메시지 */
        margin: 10px 0;
        font-weight: bold;
    }
    .server-error { /* 서버 에러 메시지 스타일 */
        text-align: center;
        color: #ff6b6b; /* 빨간색 계열 */
        margin: 10px 0;
        font-weight: bold;
    }
</style>
</head>
<body>
    <div class="login-wrap">
        <div class="login-html">
            <%-- 탭 라디오 버튼 및 라벨 --%>
            <input id="tab-1" type="radio" name="tab" class="sign-in" checked><label for="tab-1" class="tab">아이디 찾기</label>
            <input id="tab-2" type="radio" name="tab" class="sign-up"><label for="tab-2" class="tab">비밀번호 찾기</label>

            <div class="login-form"> <%-- 폼 컨테이너 --%>

                <%-- ======== 아이디 찾기 폼 ======== --%>
                <%-- (수정!) 아이디 찾기 내용은 sign-in-htm 안에 위치 --%>
                <div class="sign-in-htm">
                   <form action="${pageContext.request.contextPath}/searchid" method="post">
                        <%-- 아이디 찾기 결과 또는 에러 메시지 표시 --%>
                        <c:if test="${not empty idSearchError}">
                            <div class="server-error">${idSearchError}</div>
                        </c:if>
                        <c:if test="${not empty foundId}">
                             <div class="server-message">찾으시는 아이디는 [ <c:out value="${foundId}"/> ] 입니다.</div>
                             <div class="group" style="text-align:center;"> <%-- 로그인 버튼 추가 --%>
                                 <button type="button" class="button" onclick="location.href='${pageContext.request.contextPath}/memberinput'">로그인 하러 가기</button>
                             </div>
                         </c:if>

                        <%-- 아이디 찾기 입력 필드 (결과 없을 때만 보이도록 처리 가능) --%>
                        <c:if test="${empty foundId}">
                            <div class="group">
                                <label for="searchname" class="label">이름</label>
                                <%-- DTO 필드명과 맞춤: name="searchname" --%>
                                <input id="searchname" name="searchname" type="text" class="input" required value="${param.searchname}"> <%-- 입력값 유지 --%>
                            </div>
                            <div class="group">
                                <label for="searchemail" class="label">메일 주소</label>
                                <%-- DTO 필드명과 맞춤: name="searchemail", type="email" --%>
                                <input id="searchemail" name="searchemail" type="email" class="input" required value="${param.searchemail}"> <%-- 입력값 유지 --%>
                            </div>
                            <div class="group">
                                <button type="submit" class="button">아이디 찾기</button>
                            </div>
                            <div class="hr"></div>
                            <div class="logo-area" style="text-align: center; margin-top: 30px; margin-bottom: 20px;">
                			<img src="${pageContext.request.contextPath}/image/DateCocklogo.png" alt="DATECOCK 로고"
                     			style="max-width: 250px; height: auto;">
                     <%-- ↑↑↑ style 속성 추가: 크기 조절 --%>
                     <%-- max-width 값을 조절하여 원하는 최대 너비(예: 150px, 200px)로 설정하세요. --%>
                     <%-- height: auto; 는 너비에 맞춰 높이를 자동 조절합니다. --%>
            					</div>
                            
                            
                            
                        </c:if>
                    </form>
                </div>

                <%-- ======== 비밀번호 찾기 폼 ======== --%>
                 <%-- (수정!) 비밀번호 찾기 내용은 sign-up-htm 안에 위치 --%>
				<div class="sign-up-htm">
                    <form id="findPwdForm" action="${pageContext.request.contextPath}/searchpwd" method="post">
                        <c:if test="${not empty pwdSearchError}"><div class="server-error">${pwdSearchError}</div></c:if>

                        <%-- 1단계: 사용자 정보 입력 --%>
                        <div class="group">
                            <label for="findid" class="label">아이디</label>
                            <input id="findid" name="findid" type="text" class="input" required value="${param.findid}">
                        </div>
                        <%-- 이름 입력 필드 제거됨 --%>
                        <div class="group">
                            <label for="searchemail1" class="label">메일 주소</label>
                            <input id="searchemail1" name="loginPw" type="email" class="input" required value="${param.loginPw}">
                             <%-- !!! 서버에서는 'loginPw' 파라미터로 이메일 값을 받습니다 !!! --%>
                        </div>

                        <%-- 회원 확인 결과 메시지 --%>
                        <div id="memberCheckResult"></div>

                        <%-- 회원 확인 버튼 --%>
                        <div class="group">
                            <button type="button" id="checkMemberBtn" class="button">회원 확인</button>
                        </div>

                        <%-- 2단계: 이메일 인증 (회원 확인 후 표시될 영역) --%>
                        <div class="verification-section">
                            <hr class="hr" style="margin: 20px 0;"> <%-- 구분선 --%>
                            <div class="group" style="margin-bottom: 5px; display: flex; align-items: center; flex-wrap: wrap;">
                                <button type="button" id="sendCodeBtnPwd" class="button" style="width:auto; padding: 8px 15px; font-size: 0.8em; margin-right: 10px; flex-shrink: 0; background-color:#888;">인증번호 발송</button>
                                <span id="sendCodeMsgPwd" style="font-size:0.8em; color: #555; flex-grow: 1; min-width: 100px;"></span>
                            </div>
                            <div class="group" style="display: flex; align-items: flex-start; gap: 10px;">
                                 <div style="flex-grow: 1;">
                                     <label for="verifyCodePwd" class="label">인증번호</label>
                                     <input id="verifyCodePwd" name="verifyCode" type="text" class="input" required placeholder="인증번호 입력">
                                     <span id="verifyTimerMsgPwd" class="error-message"></span>
                                 </div>
                                 <div style="flex-shrink: 0; margin-top: 27px;">
                                    <button type="button" id="verifyCodeBtnPwd" class="button" style="width:auto; padding: 8px 15px; font-size: 0.8em; background-color:#888;">인증 확인</button>
                                 </div>
                            </div>
                            <%-- 인증 결과 메시지 --%>
                            <div id="verifyResultMsg"></div>

                            <%-- 로고 영역 --%>
                            <div class="logo-area">
                                 <img src="${pageContext.request.contextPath}/image/DateCocklogo.png" alt="DATECOCK 로고" style="max-width: 180px; height: auto;">
                            </div>

                            <%-- 최종 제출 버튼 (초기 비활성화) --%>
                            <div class="group">
                                <button type="submit" id="findPwdSubmitBtn" class="button" onclick="location.href='${pageContext.request.contextPath}/searchpwd'" disabled>비밀번호 찾기</button>
                            </div>
                        </div> <%-- verification-section 끝 --%>

                        
                    </form>
                </div> <%-- sign-up-htm 끝 --%>

            </div> <%-- login-form 끝 --%>
        </div> <%-- login-html 끝 --%>
    </div> <%-- login-wrap 끝 --%>
</body>
</html>