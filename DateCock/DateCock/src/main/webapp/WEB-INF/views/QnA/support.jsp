<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객센터</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"> </head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style type="text/css">
.container {
  max-width: 900px;
  margin: auto;
  background-color: #fff;
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  position: relative;
}

.header {
  text-align: center;
  margin-bottom: 30px;
}

.contact {
  margin-top: 10px;
}

.kakao-btn {
  background: #FEE500;
  padding: 10px 20px;
  border-radius: 30px;
  font-weight: bold;
  text-decoration: none;
  color: #000;
  margin-left: 10px;
}

.category-tabs {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin: 20px 0;
  list-style: none;
  padding: 0;
}

.category-tabs li {
  padding: 10px 15px;
  border: 1px solid #ccc;
  border-radius: 20px;
  cursor: pointer;
}

.category-tabs .active {
  background: black;
  color: white;
  border: none;
}

.faq-list {
  list-style: none;
  padding: 0;
}

.faq-list li {
  margin-bottom: 10px;
  border-bottom: 1px solid #ddd;
}

.faq-list .question {
  padding: 15px;
  font-weight: bold;
  cursor: pointer;
}

.faq-list .answer {
  display: none;
  padding: 10px 15px;
  background: #f9f9f9;
}

.faq-list .answer-qna {
  display: none;
  padding: 10px 15px;
  background: #f9f9f9;
  cursor: pointer;
}
</style>

</head>
<body>

<div class="container">
  <div class="header">
    <h2>고객센터</h2>
    <p>어려움이나 궁금한 점이 있으신가요?</p>
    <div class="contact">
      <span>📞 1688-8885</span>
      <a href="https://pf.kakao.com/_XXXXXX/chat" target="_blank" class="kakao-btn">카카오 문의</a>
    </div>
  </div>
  
  <ul class="category-tabs">
    <li class="tab active" data-tab="supportfaq">자주 묻는 질문</li>
    <li class="tab" id="userQnaTab" data-url="${pageContext.request.contextPath}/uqlist">사용자 QnA</li>
    <li class="tab" id="bizQnaTab" data-url="${pageContext.request.contextPath}/bqlist">사업자 QnA</li>
  </ul>

  	<div id="tab-content">
  		<!-- 여기 안에 위에서 말한 JSP들이 AJAX로 붙음 -->
	</div>
  
    
  </div>


</body>

<script>
$(document).ready(function() {
    // AJAX로 탭 내용을 로드하는 함수 (기존 함수 유지)
    function loadTab(tabName) {
        $('#tab-content').html('<p style="text-align:center; padding:20px;"><em>콘텐츠를 불러오는 중입니다...</em></p>'); // 로딩 메시지
        $.ajax({
            url: '${pageContext.request.contextPath}/support/ajax/' + tabName,
            type: 'GET',
            success: function(response) {
                $('#tab-content').html(response);
            },
            error: function(xhr, status, error) {
                $('#tab-content').html('<p style="text-align:center; color:red; padding:20px;">콘텐츠를 불러오는 데 실패했습니다.</p>');
                console.error("AJAX Error for " + tabName + ": ", status, error, xhr.responseText);
            }
        });
    }

    // 탭 클릭 이벤트 처리
    $('.tab').click(function() {
        var $clickedTab = $(this);

        // --- 사용자 QnA 탭 특별 처리 시작 ---
        if ($clickedTab.is('#userQnaTab')) { // 클릭된 탭이 "사용자 QnA" 탭인지 확인
            // 세션 값 확인 (JSP 로드 시점의 값)
            var isLoggedInAsPersonalUser = Boolean(${sessionScope.personalloginstate == true && sessionScope.userType == 'personal' && sessionScope.id != null});
            var isLoggedInAsAdmin = Boolean(${sessionScope.isAdmin == true}); // 관리자도 접근 가능

            if (isLoggedInAsPersonalUser || isLoggedInAsAdmin) {
                var pageUrl = $clickedTab.data('url');
                if (pageUrl) {
                    // 페이지 이동 전에 현재 active 상태를 업데이트 할 수 있음 (선택적)
                    $('.tab').removeClass('active');
                    $clickedTab.addClass('active');
                    // $('#tab-content').html('<p style="text-align:center; padding:20px;"><em>페이지로 이동합니다...</em></p>');
                    window.location.href = pageUrl;
                } else {
                    console.error("'사용자 QnA' 탭에 data-url 속성이 정의되지 않았습니다.");
                    $('#tab-content').html('<p style="color:red;">오류: 사용자 QnA 페이지 경로가 설정되지 않았습니다.</p>');
                }
                return; // "사용자 QnA" 탭 처리는 여기서 종료 (아래 AJAX 로직 실행 안 함)
            } else {
                alert("일반 사용자 로그인 후 이용 가능합니다.");
                window.location.href = "${pageContext.request.contextPath}/DateCocklog"; // 로그인 페이지 경로
                return; // "사용자 QnA" 탭 처리는 여기서 종료
            }
        }
        // --- 사용자 QnA 탭 특별 처리 끝 ---
	         if ($clickedTab.is('#bizQnaTab')) { // 클릭된 탭이 "사업자 QnA" 탭인지 확인 (ID 부여 필요)
	        // 세션 값 확인 (예시: 기업회원 로그인 상태 확인)
	        var isLoggedInAsBusinessUser = Boolean(${sessionScope.buisnessloginstate == true && sessionScope.businessnumberA != null});
	        var isLoggedInAsAdmin = Boolean(${sessionScope.isAdmin == true}); // 관리자도 접근 가능
	
	        if (isLoggedInAsBusinessUser || isLoggedInAsAdmin) { // 기업회원 또는 관리자일 경우
	            var pageUrl = $clickedTab.data('url');
	            if (pageUrl) {
	                $('.tab').removeClass('active');
	                $clickedTab.addClass('active');
	                window.location.href = pageUrl;
	            } else {
	                console.error("'사업자 QnA' 탭에 data-url 속성이 정의되지 않았습니다.");
	                $('#tab-content').html('<p style="color:red;">오류: 사업자 QnA 페이지 경로가 설정되지 않았습니다.</p>');
	            }
	            return; // "사업자 QnA" 탭 처리는 여기서 종료
	        } else {
	            alert("기업회원 또는 관리자 로그인 후 이용 가능합니다."); // 접근 제한 알림
	            window.location.href = "${pageContext.request.contextPath}/DateCocklog"; // 로그인 페이지 경로 (예시)
	            return; // "사업자 QnA" 탭 처리는 여기서 종료
	        }
	    }

        // --- 나머지 탭들은 기존 AJAX 로직 수행 ---
        $('.tab').removeClass('active');
        $clickedTab.addClass('active');
        const tabName = $clickedTab.data('tab'); // data-tab 속성 값 가져오기
        loadTab(tabName); // AJAX 로드 함수 호출
    });

    // 페이지 로드 시 기본으로 '자주 묻는 질문' 탭의 내용을 AJAX로 로드
    // HTML에서 class="active"로 지정된 탭을 기준으로 함
    var $initialActiveTab = $('.tab.active');
    if ($initialActiveTab.length > 0) {
        var initialTabName = $initialActiveTab.data('tab');
        // 기본 active 탭이 "사용자 QnA"가 아니라면 AJAX 로드
        // (만약 HTML에서 userQnaTab에 active가 있다면, 초기 로드 시 바로 페이지 이동을 원치 않을 경우 이 조건 필요)
        if (initialTabName !== "userqnalist") {
            loadTab(initialTabName);
        } else {
            // 초기 active 탭이 userqnalist인 경우, 여기서는 아무것도 하지 않거나
            // 다른 기본 AJAX 탭(예: supportfaq)을 강제로 로드할 수 있습니다.
            // 현재는 HTML에서 supportfaq에 active가 있으므로 이 else 블록은 거의 실행되지 않음.
             $('#tab-content').html('<p style="text-align:center; padding:20px;">탭을 선택해주세요.</p>');
        }
    } else {
        // HTML에 active 탭이 지정되지 않은 경우, "자주 묻는 질문"을 기본으로 로드
        $('.tab[data-tab="supportfaq"]').addClass('active');
        loadTab('supportfaq');
    }
});
</script>

</html>
