<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sign Up</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"> </head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	var isPasswordMatch = false; //비밀번호 매치 변수
	var isbncAndAvailable = false; //사업자 등록 번호 매치 변수 -> 비즈니스 넘버 체크 = bnc
	var isPasswordFormatValid = false;
	
	$("#businessnumbercheck").click(function(){ //사업자 등록번호 중복체크
		var businessnumber = $("#businessnumber").val();
		if(!businessnumber){ 
			alert("사업자 등록 번호를 입력해주세요.");
			$("#businessnumber").focus(); return;	}
		$.ajax({
			type : "post",
			url : "${pageContext.request.contextPath}/businessnumbercheck2",
			data : {"businessnumber":businessnumber},
			async : true,
			success : function(data){
				if (data=="yes"){
					alert("사용 가능한 사업자 등록 번호 입니다.")
					isbncAndAvailable = true; //상태 업데이트
				} else {
					alert("이미 사용 중이거나 사용할 수 없는 사업자 등록번호입니다.");
					isbncAndAvailable = false; //상태 업데이트
					$("#businessnumber").val('').focus();
				}
			},
			error : function(){
				alert("아이디 확인 중 오류 발생")
				isbncAndAvailable = false; //상태 업데이트!
			}
		});
	}); //businessnumbercheck.. end
	
	$("#businessnumber").on('keyup',function(){ //사업자 등록 번호 변경 시 확인 상태 초기화
		if (isbncAndAvailable){
			console.log("사업자 등록번호가 변경되었습니다, 다시 중복 확인해주세요.");
		}
		isbncAndAvailable = false;
	}); //사업자 등록 번호 변경 시 확인 상태 초기화... end
	
	//추가
	$("#password").on('keyup',function(){ //유효성
		var num = $(this).val();
		var messageSpan = $("#pwd_rule_msg2"); // 규칙메세지
		//최소 8자,순사,특수문자(!@#$%^&*) 중 1개 이상 포함 정규식 예시
		//필요에 따라 정규식 수정 가능(이 코드에서는 특수문자 포함여부만 간단히 체크))
		var specialCharRegex = /[!@#$%^&*(),.?":{}|<>]/;

			if(num.length == 0){//입력값이 없으면 메세지 숨김
				messageSpan.hide();
				isPasswordFormatValid = false;
			}
			else if(specialCharRegex.test(num)){ // 특수문자가 포함되어있다면
				messageSpan.text("사용 가능한 비밀번호 형식입니다").css("color","green");
				messageSpan.show();
				isPasswordFormatValid = true; // 형식 유효 상태로 변경
			}
			else{ //특수문자가 없다면
				messageSpan.text("비밀번호에 특수문자(!@#$%^&* 등)을 1개이상 포함해야합니다.").css("color","red");
				messageSpan.show();
				isPasswordFormatValid = false;
			}

			// 비밀번호가 변경되었으므르로, 비민번호 확인 필드도 다시 검사
			$("#password_confirm").trigger('keyup');

		});//유효성..end
	//추가종료
	
	$("#password, #password_confirm").on('keyup', function(){ // 비밀번호 중복,
		var pwd = $("#password").val();
		var pwdConfirm = $("#password_confirm").val();
		var messageSpan = $("#password_confirm_msg");
		
		if(pwd||pwdConfirm){
			if(pwd===pwdConfirm&&pwd !==""){
				messageSpan.text("비밀번호가 일치합니다.").css("color", "green");
				isPasswordMatch = true; //비밀번호 상태 업데이트
			} else {
				messageSpan.text("비밀번호가 일치하지 않습니다.").css("color", "red");
                isPasswordMatch = false; // 비밀번호 상태 업데이트
            }
			messageSpan.show();
		} else {
				messageSpan.hide();
				isPasswordMatch = false;
			}
	}); // 비밀번호 중복.... end
	
	$("#signupForm").on('submit',function(event){ //폼 제출 방지 로직
		if (!isbncAndAvailable){
			alert("사업자 등록 번호 중복확인을 확인해주세요.")
			event.preventDefault();
			$('#businessnumber').focus();
			return false;
		}
		if(!isPasswordMatch){
			alert("비밀번호가 일치하지 않습니다.");
			event.preventDefault();
			return false;
		}
		if (!isPasswordFormatValid) {
            alert("비밀번호 형식에 맞지 않습니다. 확인해주세요.");
            event.preventDefault(); // 폼 제출 중단
            $("#pwd_confirm").focus();
            return false;
        }
		//비밀번호만 일치하면 제출 허용
		//아이디 중복 여부는 서버에서 최종 확인?
		return true;
	}); //폼 제출 방지 로직..... end
	
});

</script>

<style type="text/css">
.recommend-wrapper { /* 배경화면 밑에 코드 css 넣어주고 body 처음 부터 <div class="recommend-wrapper">로 감싸주면 됌*/
      background: url('<c:url value="/image/ivent1.png" />') no-repeat center center fixed;
      background-size: cover;
      min-height: 100vh;
      padding: 60px 0;
    }
.success-message {
	color: #00e600;
	font-size: 12px;
	margin-top: 5px;
}

<style>
  .center-text {
    text-align: center;
  }
  
  .center-link {
    text-align: center; /* 가운데 정렬 */
  }

  .custom-link {
    color: gray; /* 회색 */
    text-decoration: underline; /* 밑줄 */
    font-size: 15px; /* 폰트 작게 */
    display: inline-block;
    margin-top: 10px;
  }

  .custom-link:hover {
    color: #555; /* hover 시 좀 더 진한 회색 */
  }
</style>


</style>

<title>Insert title here</title>
</head>
<body>

<c:if test="${not empty successMessage}">
<script>
    alert("${successMessage}");
</script>
</c:if>
<c:if test="${not empty errorMessage}">
<script>
    alert("${errorMessage}");
</script>
</c:if>

<!-- 로그인 view -->
 <div class="recommend-wrapper">
    <div class="login-wrap">
  <div class="login-html">
    <input id="tab-1" type="radio" name="tab" class="sign-in" checked><label for="tab-1" class="tab">Sign In</label>
    <input id="tab-2" type="radio" name="tab" class="sign-up"><label for="tab-2" class="tab">Sign Up</label>
    <div class="login-form">
    
    <form action="${pageContext.request.contextPath}/bisinessloginprocess" method="post">
      <div class="sign-in-htm">
        <div class="group">
          <label for="businessnumberA" class="label">사업자등록번호</label>
          <input id="businessnumberA" type="text" name="businessnumberA" class="input">
        </div>
        
        <div class="group">
          <label for="businesspwA" class="label">비밀번호</label>
          <input id="businesspwA" type="password" name="businesspwA"  class="input" data-type="password">
        </div>
        
        
        <div class="group">
          <input type="submit" class="button" value="로그인">
        </div>
        
        <div class="group">
          <%-- 변경된 버튼: type="button"으로 바꾸고 onclick 이벤트 추가 --%>
          <button type="button" class="button" onclick="location.href='${pageContext.request.contextPath}/main'">취소</button>
        </div>
        
        <div class="group center-link">
		  <a class="custom-link" href="${pageContext.request.contextPath}/businessresult">사업자 번호, 또는 비밀번호를 잊어버리셨나요?</a>
		</div>
		
		<div class="logo-area" style="text-align: center; margin-top: 30px; margin-bottom: 20px;">
	        <img src="${pageContext.request.contextPath}/image/DateCocklogo.png" alt="DATECOCK 로고"
	         style="max-width: 250px; height: auto;">
        </div>
        
      </div>
      </form>
      
       <form id="signupForm" action ="${pageContext.request.contextPath}/businessmembersave" method="post">
      <div class="sign-up-htm"> 
      
      <!-- 사업자 회원가입 view -->
        <div class="group">
          <label for="businessnumber" class="label">사업자 등록 번호</label>
          <input id="businessnumber" type="text" class="input"
          placeholder="-를 제외한 번호(10자리) 입력해주세요. ex)0123456789 " 
          name="businessnumber" maxlength="20">
          
          <!-- 사업자 등록번호 중복검사 버튼 -->
          <button type="button" id="businessnumbercheck" class="button"  
          style="margin-top: 10px; width: auto; padding: 5px 10px;">중복 확인</button>
          <div class="error-message" id="numberErrorMessage" ></div>
        </div>
        
        <div class="group">
          <label for="password" class="label">비밀번호</label>
          <input id="password" type="password" class="input" data-type="password"
          placeholder="비밀번호" name="password" maxlength="20">
           <span id="pwd_rule_msg2" class="error-message"></span>
        </div>
        
        <div class="group">
          <label for="password_confirm" class="label">비밀번호 확인</label>
          <input id="password_confirm" type="password" class="input" data-type="password" placeholder="비밀번호 확인" maxlength="20" name="password_confirm">
          <span id="password_confirm_msg" class="error-message"></span>
          <div class="error-message" id="passwordErrorMessage"></div>
        </div>
        
        <div class="group">
          <label for="email" class="label">Email 주소</label>
          <input id="email" type="text" class="input" placeholder="이메일 ex)user@datekock.com" name="email">
        </div>
        
        <div class="group">
          <label for="phone" class="label">전화번호</label>
          <input id="phone" type="text" class="input" placeholder="전화번호를 입력해주세요. " name="phone">
        </div>
        
        <div class="group">
          <label for="businessname" class="label">이름</label>
          <input id="businessname" type="text" class="input" name="businessname">
        </div>
        
        <div class="group">
        
        
          <label for="birthyear" class="label">생년월일</label>
          <input id="birthyear" type="date" class="input" name="birthyear">
        </div>
        
        <div class="group">
        	<input type="submit" class="button" value="Sign Up">
        </div>
        
        <div class="hr"></div>
        <div class="foot-lnk">
          <label for="tab-1">Already Member?</label>
        </div>
        
      </div>
      </form>
    </div>
    
</div>
</div>
</div>

</body>
</html>