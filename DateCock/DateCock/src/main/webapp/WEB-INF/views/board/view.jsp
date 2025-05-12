<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- 날짜/숫자 포맷팅 --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%-- 페이지 제목 --%>
<title><c:choose><c:when test="${not empty boardDTO}"><c:out value="${boardDTO.title}"/></c:when><c:otherwise>게시글 보기</c:otherwise></c:choose> - 게시판</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"> <%-- 기본 스타일 --%>
<%-- [!] board_style.css 경로 확인 및 404 오류 해결 필요 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board_style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>
    /* view.jsp 특정 스타일 */
    .view-container { max-width: 800px; margin: 30px auto; padding: 30px; background-color: #fff; border: 1px solid #dee2e6; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
    .view-header { border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 25px; }
    .view-header h1 { font-size: 1.8em; margin: 0 0 15px 0; line-height: 1.4; color: #333; word-break: break-all; }
    .view-meta { font-size: 0.9em; color: #777; display: flex; flex-wrap: wrap; gap: 15px; }
    .view-meta .writer strong { color: #333; font-weight: 500; }
    .view-meta span { display: inline-flex; align-items: center; }
    .view-meta i { margin-right: 4px; font-size: 0.9em; }
    .view-thumbnail { margin-bottom: 25px; text-align: center; }
    .view-thumbnail img { max-width: 100%; max-height: 400px; height: auto; border-radius: 4px; }
    .view-content { min-height: 200px; padding: 20px 5px; line-height: 1.7; border-top: 1px solid #eee; border-bottom: 1px solid #eee; margin-bottom: 30px; white-space: pre-wrap; word-wrap: break-word; }
    .view-content img { max-width: 100%; height: auto; }
    .view-buttons { text-align: center; }
    .view-buttons .button { margin: 0 5px; padding: 10px 25px; }
    .not-found-message { text-align:center; padding: 50px; color: #666; }
    /* 댓글 섹션 스타일 */
    .reply-section h4 { font-size: 1.2em; margin-bottom: 15px; border-bottom: 2px solid #eee; padding-bottom: 10px;}
    .reply-input-area { background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
    .reply-input-area label { font-size: 0.9em; margin-bottom: 8px; display: block; }
    .reply-input-area textarea { width: 100%; box-sizing: border-box; border: 1px solid #ced4da; border-radius: 4px; padding: 10px; height: 70px; resize: vertical; margin-bottom: 10px;}
    .reply-input-area .button.small { padding: 5px 15px; font-size: 0.9em;}
    #replyMessage { font-size: 0.9em; margin-bottom: 15px; text-align: center; }
    #replyMessage.success { color: green; }
    #replyMessage.error { color: red; }
    #replyListArea ul { list-style: none; padding: 0; margin: 0; }
    #replyListArea li { padding: 12px 0; border-bottom: 1px dashed #eee; }
    #replyListArea li:last-child { border-bottom: none; }
    #replyListArea strong { color: #333; font-weight: 500; }
    #replyListArea p { margin: 6px 0 8px 5px; line-height: 1.5; color: #444;}
    #replyListArea .reply-meta span { font-size: 0.8em; color: #888; }
    #replyListArea .reply-actions button { float: right; margin-left: 5px; padding: 2px 6px; font-size: 0.8em; cursor: pointer; }
</style>
</head>
<body>

<%-- [!] 중요: 서버 오류(ELException: Function [:escapeHtml] not found)가 해결되었는지 확인 필수! --%>
<%-- [!] layout.jsp, tiles.xml 등을 확인하여 서버 오류를 먼저 해결해야 합니다. --%>

<div class="view-container">
    <c:choose>
        <c:when test="${not empty boardDTO}">
            <%-- 1. 게시글 헤더 --%>
            <div class="view-header">
                <h1><c:out value="${boardDTO.title}"/></h1>
                <div class="view-meta">
                    <span class="writer">
                        작성자: <strong><c:out value="${boardDTO.writer}"/></strong>
                    </span>
                    <span>
                        작성일: <fmt:formatDate value="${boardDTO.regdate}" pattern="yyyy-MM-dd HH:mm"/>
                    </span>
                    <span>
                        조회수: <c:out value="${boardDTO.viewcnt}"/>
                    </span>
                     <span>
                     <i class="fa-regular fa-thumbs-up"></i> <%-- Font Awesome 아이콘 사용 시 --%>
                        좋아요: <c:out value="${boardDTO.likecnt}"/>
                    </span>
                </div>
            </div>

             <%-- 2. 썸네일 이미지 --%>
            <c:if test="${not empty boardDTO.thumbnail}">
                <div class="view-thumbnail">
                    <img src="${pageContext.request.contextPath}${boardDTO.thumbnail}" alt="썸네일 이미지">
                </div>
            </c:if>

            <%-- 3. 게시글 본문 내용 --%>
            <div class="view-content">
                <c:out value="${boardDTO.content}" escapeXml="true"/>
            </div>

            <%-- 4. 버튼 영역 --%>
            <div class="view-buttons">
                <button type="button" class="button list" onclick="location.href='${pageContext.request.contextPath}/listup'">목록</button>
                 <c:if test="${not empty sessionScope.personalloginstate && sessionScope.personalloginstate == true}">
        			<%-- (작성자 본인이거나 또는 관리자 역할이면) 버튼 표시 --%>
        			<c:if test="${sessionScope.id == boardDTO.writer || sessionScope.isAdmin == true}"> <%-- '|| sessionScope.isAdmin == true' 추가 --%>
            		<button type="button" class="button edit" onclick="location.href='${pageContext.request.contextPath}/edit?bno=${boardDTO.bno}'">수정</button> <%-- ★★★ /board 제거 ★★★ --%>
            		<button type="button" class="button delete" onclick="deleteBoard(${boardDTO.bno});">삭제</button>
        			</c:if>
    			</c:if>
                 <%-- 좋아요 버튼 (로그인 상태일 때만) --%>
			    <c:if test="${not empty sessionScope.personalloginstate && sessionScope.personalloginstate == true}">
			        <%--
			           userLikedInSession 값에 따라 버튼 초기 상태 결정
			           - 텍스트 변경
			           - disabled 속성 추가 (세션에 이미 좋아요 눌렀으면)
			        --%>
			        <button type="button" class="button like" id="likeBtnDbSession" data-bno="${boardDTO.bno}"
			                <c:if test="${userLikedInSession}">disabled style="opacity:0.7;"</c:if> >
			            <c:choose>
			                <c:when test="${userLikedInSession}">
			                    👍 좋아요 누름
			                </c:when>
			                <c:otherwise>
			                    👍 좋아요
			                </c:otherwise>
			            </c:choose>
			        </button>
			        <span id="likeMessageDbSession" style="margin-left: 10px;"></span> <%-- 메시지 표시 영역 --%>
			    </c:if>
            </div>
        
            <%-- ===================== 댓글 영역 ===================== --%>
            <div class="reply-section">
                <h4>댓글</h4>
                 <%-- 댓글 입력 폼 --%>
                 <c:if test="${not empty sessionScope.personalloginstate && sessionScope.personalloginstate == true}">
                    <div class="reply-input-area">
                        <div class="form-group">
                            <label for="replyText"><strong><c:out value="${sessionScope.id}"/></strong> 님 댓글 작성</label>
                            <textarea id="replyText" rows="3" placeholder="댓글을 입력하세요..."></textarea> 
                            <div style="text-align: right; margin-top: 10px;">
                                <button type="button" id="btnAddReply" class="button small" data-bno="${boardDTO.bno}">댓글 등록</button>
                            </div>
                        </div>
                         <div id="replyMessage"></div> 
                    </div>
                </c:if>
                <c:if test="${empty sessionScope.personalloginstate || sessionScope.personalloginstate == false}">
                    <p style="color: #888; font-size: 0.9em; text-align: center;">댓글을 작성하려면 <a href="${pageContext.request.contextPath}/memberinput">로그인</a>이 필요합니다.</p>
                </c:if>
                 <%-- 댓글 목록 표시 영역 --%>
                 <div id="replyListArea" style="margin-top: 20px;">
                    <%-- AJAX로 채워짐 --%>
                </div>
            </div>
            <%-- =================== 댓글 영역 끝 =================== --%> 
         </c:when>
         <c:otherwise>
            <%-- 게시글 없을 때 --%>
             <p class="not-found-message">요청하신 게시글을 찾을 수 없습니다.</p>
            <div class="view-buttons">
                 <button type="button" class="button list" onclick="location.href='${pageContext.request.contextPath}/listup'">목록</button>
            </div>
         </c:otherwise>
    </c:choose>
</div> <%-- view-container 끝 --%>

<script type="text/javascript">
    
    
	function deleteBoard(bno) {
	    if (confirm("정말로 이 게시글을 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.")) {
	        // Controller의 /board/delete 경로로 GET 요청 (bno 파라미터 포함)
	        location.href = '${pageContext.request.contextPath}/board/delete?bno=' + bno;
	    }
	}
    
    
    
    // 게시글 삭제 확인 함수
    function deleteBoard(bno) {
        if (confirm("정말로 이 게시글을 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.")) {
            location.href = '${pageContext.request.contextPath}/board/delete?bno=' + bno;
        }
    }

    // === jQuery Document Ready 함수 ===
    $(document).ready(function() {
        console.log("[DEBUG] Document ready 시작"); 

        var isUserLoggedIn = ${not empty sessionScope.personalloginstate && sessionScope.personalloginstate == true};
        var currentUserId = "${not empty sessionScope.id ? sessionScope.id : ''}";
        var isUserAdmin = ${sessionScope.isAdmin == true}; // ★ 관리자 여부 변수 추가 (boolean)

        try {
            console.log("[DEBUG] currentBno 설정 시도...");
            currentBno = Number("${not empty boardDTO and not empty boardDTO.bno ? boardDTO.bno : 0}"); 
            if (isNaN(currentBno) || currentBno <= 0) {
                 currentBno = 0; 
                 console.warn("[DEBUG] 유효하지 않거나 찾을 수 없는 게시글 번호. currentBno를 0으로 설정.");
            }
            console.log("[DEBUG] currentBno 설정 완료:", currentBno);
        } catch (e) {
            console.error("[DEBUG] currentBno 설정 중 오류 발생!", e);
        }

        try {
            console.log("[DEBUG] currentUserId 설정 시도...");
            currentUserId = "${not empty sessionScope.id ? sessionScope.id : ''}"; 
            console.log("[DEBUG] currentUserId 설정 완료:", currentUserId); 
        } catch (e) {
            console.error("[DEBUG] currentUserId 설정 중 오류 발생!", e);
        }
		
        
        
        
        // --- Helper 함수 정의 ---
        // (Helper 함수 정의는 일반적으로 오류 발생 가능성 낮음)
        function formatReplyDate(timestamp) { 
            if (!timestamp) return "";
            var date = new Date(timestamp);
            if (isNaN(date.getTime())) { return "Invalid Date"; }
            function pad(n) { return n < 10 ? "0" + n : n; }
            return date.getFullYear() + "-" + pad(date.getMonth() + 1) + "-" + pad(date.getDate()) + " " +
                   pad(date.getHours()) + ":" + pad(date.getMinutes());
        }

        function escapeHtml(unsafe) {
            if (typeof unsafe !== 'string') {
                return unsafe === null || typeof unsafe === 'undefined' ? '' : unsafe; 
            }
            return unsafe
                 .replace(/&/g, "&amp;")
                 .replace(/</g, "&lt;")
                 .replace(/>/g, "&gt;")
                 .replace(/"/g, "&quot;")
                 .replace(/'/g, "&#039;");
        }
        
     // --- DB 업데이트 + 세션 상태 좋아요 버튼 클릭 이벤트 ---
        $("#likeBtnDbSession").on("click", function() {
            var bno = $(this).data("bno");
            var $likeBtn = $(this);
            var $likeCountSpan = $("#likeCount"); // 좋아요 숫자 표시 span
            var $likeMessageSpan = $("#likeMessageDbSession");

            // 이미 비활성화 상태면 클릭 무시 (선택적이지만 추가하면 좋음)
            if ($likeBtn.prop('disabled')) {
                return;
            }

            $likeBtn.prop("disabled", true).css("opacity", 0.5); // 처리 중 비활성화
            $likeMessageSpan.text("").css("color", ""); // 메시지 초기화

            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/board/like", // Controller 매핑 경로
                data: { bno: bno },
                dataType: "json",
                success: function(response) {
                    console.log("DB+세션 좋아요 응답:", response);

                    // 좋아요 수 업데이트 (성공/실패/오류 시 모두 서버가 보내준 값으로 업데이트 시도)
                    if(response.likeCount !== undefined && response.likeCount >= 0) {
                        $likeCountSpan.text(response.likeCount);
                    }

                    if (response.success) {
                        // 좋아요 처리 성공 시 (처음 눌렀거나 이미 눌렀거나)
                        $likeBtn.html('👍 좋아요 누름'); // 버튼 텍스트 변경
                        $likeBtn.prop("disabled", true).css("opacity", 0.7); // 계속 비활성화 상태 유지
                        $likeMessageSpan.text(response.message).css("color", "green");
                    } else {
                        // 실패 시 (로그인 필요, DB 오류 등)
                        $likeMessageSpan.text(response.message || "처리 실패").css("color", "red");
                        // 실패 시 버튼 다시 활성화 (로그인 오류 등 다시 시도 가능하게)
                        // 단, DB 업데이트 실패 등 복구 어려운 경우는 비활성화 유지 고려
                        if(response.action !== "db_update_failed" && response.action !== "error") {
                           $likeBtn.prop("disabled", false).css("opacity", 1);
                           $likeBtn.html('👍 좋아요'); // 원래 상태로 복구
                        } else {
                           // DB 업데이트 실패 등 심각한 오류 시 버튼 비활성화 유지
                           $likeBtn.prop("disabled", true).css("opacity", 0.7);
                        }
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error("DB+세션 좋아요 AJAX 오류:", textStatus, errorThrown);
                    $likeMessageSpan.text("오류 발생!").css("color", "red");
                     $likeBtn.prop("disabled", false).css("opacity", 1); // 오류 시 일단 활성화
                },
                complete: function() {
                    // 버튼 활성화/비활성화는 success/error 에서 상태별로 처리했으므로 여기선 생략 가능
                    // 메시지 잠시 후 숨김
                    setTimeout(function() { $likeMessageSpan.text(""); }, 3000);
                }
            }); // End $.ajax
        }); // End #likeBtnDbSession click
        
        
        

        // 1. 댓글 목록 로딩 함수 (캐시 방지 추가됨)
        function loadReplies(bno) { 
            console.log("[DEBUG] loadReplies 함수 호출됨 (bno:", bno, ")");
            try {
                if (!bno || bno <= 0) {
                    $("#replyListArea").html("<p>댓글을 로드할 수 없습니다. (유효하지 않은 게시글 번호)</p>");
                    console.error("[DEBUG] loadReplies called with invalid bno:", bno);
                    return;
                }
                console.log("[DEBUG] " + bno + "번 게시글 댓글 로딩 시도 (캐시 방지)...");
                var replyListArea = $("#replyListArea");

                $.ajax({
                    type: "GET",
                    // ★★★ 수정된 부분 1: URL 끝에 현재 시간을 파라미터로 추가 ★★★
                    url: "${pageContext.request.contextPath}/replies/" + bno + "?_M=" + Date.now(), 
                    dataType: "json", 
                    // ★★★ 수정된 부분 2: 캐시 사용 안 함 옵션 추가 ★★★
                    cache: false, 
                    success: function(replyList) { 
                        // success 콜백 함수 내부는 이전과 동일하게 유지됩니다.
                        // 예: console.log("댓글 목록 수신:", replyList); 등...
                        // ... (jQuery DOM 조작 또는 HTML 문자열 생성 로직) ...
                         console.log("댓글 목록 수신:", replyList);
                         replyListArea.empty(); 

                         if (replyList && Array.isArray(replyList) && replyList.length > 0) { 
                             var $ul = $("<ul style='list-style: none; padding: 0; margin: 0;'></ul>"); 
                             $.each(replyList, function(index, reply) { 
                                 if (!reply || typeof reply.rno === 'undefined' || typeof reply.replyer === 'undefined' || typeof reply.replytext === 'undefined') {
                                     console.warn("Skipping invalid reply object:", reply);
                                     return true; 
                                 }
                                 var $li = $("<li data-rno='" + reply.rno + "' style='border-bottom: 1px dashed #eee; padding: 12px 0;'></li>");
                                 var $replyHeader = $("<div class='reply-header'></div>");
                                 $replyHeader.append($("<strong></strong>").text(reply.replyer)); 
                                 var $replyMeta = $("<span class='reply-meta'></span>");
                                 $replyMeta.append($("<span style='margin-left: 10px;'></span>").text(formatReplyDate(reply.replydate)));
                                 if (isUserLoggedIn && ( (currentUserId && currentUserId === reply.replyer) || isUserAdmin )) {
                                     var $replyActions = $("<span class='reply-actions'></span>");
                                     // 수정 버튼 추가
                                     $replyActions.append($("<button type='button' class='button small btnEditReply'>수정</button>")
                                         .attr("data-rno", reply.rno)
                                         .attr("data-replyer", reply.replyer)); // 작성자 정보는 유지 (수정 시 필요)
                                     // 삭제 버튼 추가
                                     $replyActions.append($("<button type='button' class='button small btnDeleteReply'>삭제</button>")
                                         .attr("data-rno", reply.rno)
                                         .attr("data-replyer", reply.replyer)); // 작성자 정보는 유지 (삭제 시 필요)

                                     $replyMeta.append($replyActions); // 버튼들을 메타 정보 영역에 추가
                                 }
                                 // --- ★★★ 수정 끝 ★★★ ---

                                 $replyHeader.append($replyMeta); 
                                 $li.append($replyHeader); 
                                 var $replyContent = $("<div class='reply-content'></div>");
                                 $replyContent.append($("<p style='margin: 6px 0 8px 5px; line-height: 1.5; color: #444; white-space: pre-wrap; word-wrap: break-word;'></p>").text(reply.replytext));
                                 $li.append($replyContent); 
                                 $li.append($("<div class='reply-edit-form' style='display: none; margin-top: 10px;'></div>"));
                                 $ul.append($li); 
                             }); 
                             replyListArea.append($ul); 
                         } else if (replyList && replyList.length === 0) {
                              replyListArea.html("<p style='text-align:center; color: #888; padding: 20px 0;'>등록된 댓글이 없습니다.</p>");
                         } else {
                              console.warn("Received invalid or non-array replyList:", replyList);
                              replyListArea.html("<p>댓글 목록을 표시할 수 없습니다.</p>");
                         }
                    },
                    error: function(jqXHR, textStatus, errorThrown) { 
                        // error 콜백 함수 내부도 이전과 동일하게 유지됩니다.
                        console.error("댓글 목록 로딩 실패:", textStatus, errorThrown, jqXHR.responseText);
                        replyListArea.html("<p>댓글 로딩 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.</p>");
                     }
                });
            } catch (e) {
                console.error("[DEBUG] loadReplies 함수 실행 중 오류:", e);
            }
        } 

        // 페이지 로드 시 댓글 목록 최초 로딩 (이 부분은 변경 없음)
        try {
            console.log("[DEBUG] 초기 댓글 로딩 시도 (currentBno:", currentBno, ")");
            if (currentBno > 0) {
                 loadReplies(currentBno);
            } else {
                 console.log("[DEBUG] currentBno가 유효하지 않아 초기 댓글 로딩 생략.");
            }
        } catch (e) {
            console.error("[DEBUG] 초기 댓글 로딩 중 오류:", e);
        }

        // --- 이벤트 핸들러 연결 ---
        console.log("[DEBUG] 이벤트 핸들러 연결 시도...");
        try {
            // 2. 댓글 등록 버튼 클릭 이벤트
            var $btnAddReply = $("#btnAddReply");
            if ($btnAddReply.length) {
                console.log("[DEBUG] #btnAddReply 버튼 찾음. 클릭 이벤트 연결 시도...");
                $btnAddReply.off('click').on("click", function() { // 기존 핸들러 제거 후 다시 연결 (안전장치)
                    console.log(">>> #btnAddReply 클릭됨!"); 
                    var bno = $(this).data("bno");
                    var replyText = $("#replyText").val().trim();
                    console.log(">>> 데이터 확인: bno=", bno, ", replyText=", replyText, ", currentUserId=", currentUserId); 
                     
                    if (!replyText) { alert("댓글 내용을 입력해주세요."); return; }
                    if (!currentUserId) { alert("로그인이 필요합니다."); return; }
                    if (!bno || bno <= 0) { alert("게시글 번호 오류"); return; }

                    var replyData = { bno: bno, replytext: replyText, replyer: currentUserId }; 
                    console.log(">>> AJAX 전송 데이터:", replyData); 
                    
                    $(this).prop('disabled', true); 

                    $.ajax({
                        type: "POST",
                        url: "${pageContext.request.contextPath}/replies/new",
                        data: JSON.stringify(replyData),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function(response) {
                            console.log(">>> AJAX 성공:", response); 
                            
                            // --- 디버깅 로그 추가 ---
                            console.log(">>> response 객체:", response); // 받은 response 전체 확인
                            if (response) {
                                console.log(">>> response.success 값:", response.success); 
                                console.log(">>> typeof response.success:", typeof response.success); // success 속성의 타입 확인
                                console.log(">>> response.success === true 비교 결과:", response.success === true); // 엄격한 비교(===) 결과 확인
                            } else {
                                console.log(">>> response 객체가 비어있거나 null 입니다.");
                            }
                            // --- 디버깅 로그 끝 ---

                            var $messageDiv = $("#replyMessage"); 

                            // [수정] if 조건을 좀 더 명확하게 (response 객체 존재 확인 및 === 비교)
                            if (response && response.success === true) { 
                                console.log("[DEBUG] response.success가 boolean true 임. 입력창 비우고 새로고침 호출!"); // if문 진입 확인 로그
                                $("#replyText").val("");   
                                console.log("[DEBUG] 댓글 등록 성공, 목록 새로고침 호출 (bno:", bno, ")"); 
                                loadReplies(bno);         
                            } else {
                                console.warn("[DEBUG] response.success가 boolean true가 아님. 목록 새로고침 안 함. success 값:", response ? response.success : 'response 없음'); // if문 실패 시 로그
                                // 성공이 아니더라도 메시지는 표시 시도
                                if (response && typeof response.message !== 'undefined') {
                                   $messageDiv.text(response.message).removeClass("error success").addClass("error"); // 실패 시 항상 error 클래스
                                } else {
                                   $messageDiv.text("알 수 없는 오류 또는 메시지 없음").removeClass("success").addClass("error");
                                }
                            }
                            setTimeout(function(){ $messageDiv.text("").removeClass("success error"); }, 3000); 
                        },
                        error: function(jqXHR, textStatus, errorThrown) { /* ... */ console.error(">>> AJAX 실패:", textStatus, errorThrown, jqXHR.responseText);},
                        complete: function() { /* ... */ console.log(">>> AJAX 완료"); $("#btnAddReply").prop('disabled', false); }
                    });
                }); 
                console.log("[DEBUG] #btnAddReply 클릭 이벤트 연결 완료.");
             } else {
                 console.info("[DEBUG] #btnAddReply 버튼 없음.");
             }

         // 3. 댓글 삭제 버튼 클릭 이벤트 (이벤트 위임) - 디버깅 로그 추가됨
            $("#replyListArea").on("click", ".btnDeleteReply", function() {
                console.log("[DELETE] 삭제 버튼 클릭됨!"); // 1. 핸들러 실행 확인

                var $button = $(this); 
                var rno = $button.data("rno");
                var writer = $button.data("replyer"); // data-replyer 속성값 가져오기

                console.log("[DELETE] 데이터 확인: rno=", rno, ", writer=", writer, ", currentUserId=", currentUserId); // 2. 데이터 확인

                // 3. 작성자 일치 여부 확인
                // --- ↓↓↓ 권한 확인 조건 수정 ↓↓↓ ---
            // 기존: if (!currentUserId || currentUserId !== writer) { ... }
            // 수정: 관리자가 아니고 작성자도 아니면 차단
	            if (!currentUserId || (!isUserAdmin && currentUserId !== writer)) {
	                console.warn("[DELETE] 권한 없음 (작성자 불일치 또는 관리자 아님).");
	                alert("댓글을 삭제할 권한이 없습니다."); // 메시지 변경
	                return;
	            }
	            console.log("[DELETE] 권한 확인됨 (작성자 또는 관리자).");
            // --- ↑↑↑ 권한 확인 조건 수정 끝 ↑↑↑ ---
                 // 4. rno 유효성 확인
                 if (!rno || rno <= 0) {
                    console.error("[DELETE] 삭제할 댓글 번호(rno)가 유효하지 않음:", rno);
                    alert("삭제할 댓글 번호가 유효하지 않습니다.");
                    return;
                 }
                 console.log("[DELETE] rno 유효성 확인됨.");

                // 5. 삭제 확인 대화상자
                console.log("[DELETE] 삭제 확인 대화상자 표시 시도...");
                if (confirm("정말로 이 댓글을 삭제하시겠습니까?")) {
                     console.log("[DELETE] 사용자가 삭제 확인.");
                     $button.prop('disabled', true).text('삭제중...'); 

                    // 6. AJAX DELETE 요청 시도
                    console.log("[DELETE] AJAX 요청 시도: DELETE /replies/" + rno);
                    $.ajax({
                        type: "DELETE",
                        url: "${pageContext.request.contextPath}/replies/" + rno,
                        dataType: "json",
                        success: function(response) {
                            console.log("[DELETE] AJAX 성공:", response); // 7. AJAX 성공 응답 확인
                            if (response && response.message) { 
                                alert(response.message);
                                if (response.success) {
                                    console.log("[DELETE] 목록 새로고침 호출...");
                                    loadReplies(currentBno); // 성공 시 목록 다시 로드
                                } else {
                                     $button.prop('disabled', false).text('삭제'); 
                                }
                            } else {
                                 console.error("[DELETE] 알 수 없는 서버 응답:", response);
                                 alert("알 수 없는 서버 응답입니다.");
                                 $button.prop('disabled', false).text('삭제'); 
                            }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            console.error("[DELETE] AJAX 실패:", textStatus, errorThrown, jqXHR.responseText); // 8. AJAX 실패 오류 확인
                            alert("댓글 삭제 중 오류가 발생했습니다.");
                             $button.prop('disabled', false).text('삭제'); 
                        },
                        complete: function() {
                            console.log("[DELETE] AJAX 완료."); // 9. AJAX 완료 확인 (성공/실패 무관)
                            // 성공 시 loadReplies가 목록을 다시 그리므로 버튼 복구 불필요, 실패 시 위에서 복구됨
                        }
                    });
                } else {
                    console.log("[DELETE] 사용자가 삭제 취소."); // 사용자가 '취소' 눌렀을 때
                }
            }); // End btnDeleteReply click
            
         // 4. 댓글 수정 버튼 클릭 이벤트 (이벤트 위임) - 디버깅 로그 추가됨
            $("#replyListArea").on("click", ".btnEditReply", function() {
                console.log("[EDIT] 수정 버튼 클릭됨!"); // 1. 핸들러 실행 확인

                var $button = $(this);
                var $replyItem = $button.closest('li'); 
                if (!$replyItem.length) {
                     console.error("[EDIT] 부모 li 요소를 찾을 수 없습니다.");
                     return;
                }
                var rno = $button.data("rno");
                var writer = $button.data("replyer");
                
                console.log("[EDIT] 데이터 확인: rno=", rno, ", writer=", writer, ", currentUserId=", currentUserId); // 2. 데이터 확인

                // 3. 이미 수정 중인지 확인 (중복 방지)
                if ($replyItem.find('.reply-edit-textarea').length > 0) {
                    console.log("[EDIT] 이미 수정 모드입니다 (rno:", rno, ")");
                    return; 
                }

                 // 4. 다른 열려있는 수정 폼 닫기 시도
                 try {
                     console.log("[EDIT] 다른 수정 폼 닫기 시도...");
                     $(".reply-edit-form").not($replyItem.find('.reply-edit-form')).empty().hide();
                     $(".reply-content").not($replyItem.find('.reply-content')).show();
                     $(".reply-actions").not($replyItem.find('.reply-actions')).show();
                     console.log("[EDIT] 다른 수정 폼 닫기 완료.");
                 } catch(e) {
                     console.error("[EDIT] 다른 수정 폼 닫는 중 오류:", e);
                 }

                // 5. 현재 댓글 내용 가져오기
                var $contentP = $replyItem.find('.reply-content p');
                if (!$contentP.length) {
                     console.error("[EDIT] 댓글 내용(<p>) 요소를 찾을 수 없습니다.");
                     return;
                }
                var currentText = $contentP.text();
                console.log("[EDIT] 현재 댓글 내용:", currentText);

             // --- ↓↓↓ 권한 확인 조건 수정 ↓↓↓ ---
                // 기존: if (!currentUserId || currentUserId !== writer) { ... }
                // 수정: 관리자가 아니고 작성자도 아니면 차단
                if (!currentUserId || (!isUserAdmin && currentUserId !== writer)) {
                     console.warn("[EDIT] 권한 없음 (작성자 불일치 또는 관리자 아님).");
                     alert("댓글을 수정할 권한이 없습니다."); // 메시지 변경
                     return;
                }
                console.log("[EDIT] 권한 확인됨 (작성자 또는 관리자).");

                 // 7. rno 유효성 확인
                 if (!rno || rno <= 0) {
                     console.error("[EDIT] 수정할 댓글 번호(rno)가 유효하지 않음:", rno);
                     alert("수정할 댓글 번호가 유효하지 않습니다.");
                     return;
                 }
                 console.log("[EDIT] rno 유효성 확인됨.");

                // 8. 수정 폼 HTML 생성 시도
             try {
                console.log("[EDIT] 수정 폼 요소 생성 시도...");
                
                // 1. Textarea 요소 생성 및 값 설정 (.val() 사용)
               	var $textarea = $('<textarea class="reply-edit-textarea" style="width: 98%; height: 60px; margin-top: 5px; box-sizing: border-box; padding: 10px;" rows="3"></textarea>');
                $textarea.val(currentText); // .val() 사용!

                // 2. 버튼들을 담을 div 생성
                var $buttonDiv = $('<div style="text-align: right; margin-top: 5px;"></div>');
                
                // 3. 저장 버튼 생성 및 data-rno 설정 (.attr() 사용)
                var $saveButton = $('<button type="button" class="button small btnSaveReply">저장</button>');
                $saveButton.attr('data-rno', rno); // .attr()로 명시적 설정!
                
                // 4. 취소 버튼 생성 및 data-rno 설정 (.attr() 사용)
                var $cancelButton = $('<button type="button" class="button small btnCancelEdit">취소</button>');
                $cancelButton.attr('data-rno', rno); // .attr()로 명시적 설정!

                // 5. 버튼들을 div에 추가
                $buttonDiv.append($saveButton).append($cancelButton);
                
                console.log("[EDIT] 수정 폼 요소 생성 완료.");

                // 6. 기존 내용 숨기고, 수정 폼 컨테이너에 요소들 추가 및 표시
                console.log("[EDIT] 기존 내용 숨기기/폼 표시 시도...");
                $replyItem.find('.reply-content').hide();
                $replyItem.find('.reply-actions').hide(); 
                var $editFormContainer = $replyItem.find('.reply-edit-form'); 
                if (!$editFormContainer.length) { console.error("[EDIT] .reply-edit-form 컨테이너 없음"); throw new Error("Edit form container not found"); }
                
                // 생성된 요소들을 append
                $editFormContainer.empty().append($textarea).append($buttonDiv).show(); 

                console.log("[EDIT] 수정 폼 표시 완료.");

                $textarea.focus(); 
                console.log("[EDIT] textarea 포커스 완료.");

            } catch(e) {
                console.error("[EDIT] 수정 폼 생성/표시 중 오류:", e);
                alert("수정 폼을 표시하는데 실패했습니다.");
                 // 실패 시 복구 로직
                 try { $replyItem.find('.reply-edit-form').empty().hide(); $replyItem.find('.reply-content, .reply-actions').show(); } catch (re) { console.error("DOM 복구 오류", re); }
            }

            }); // End btnEditReply click


            // 5. 댓글 수정 취소 버튼 클릭 이벤트 (이벤트 위임)
             $("#replyListArea").on("click", ".btnCancelEdit", function() {
                console.log("[CANCEL EDIT] 취소 버튼 클릭됨 (rno:", $(this).data("rno"), ")");
                var $replyItem = $(this).closest('li');
                $replyItem.find('.reply-edit-form').empty().hide(); 
                $replyItem.find('.reply-content').show();          
                $replyItem.find('.reply-actions').show();         
            }); // End btnCancelEdit click


            // 6. 댓글 수정 저장 버튼 클릭 이벤트 (이벤트 위임) - 디버깅 로그 포함됨
            $("#replyListArea").on("click", ".btnSaveReply", function() {
                 console.log("[SAVE] 저장 버튼 클릭됨!"); // 1. 핸들러 실행 확인

                 var $button = $(this);
                var $replyItem = $button.closest('li');
                if (!$replyItem.length) { console.error("[SAVE] 부모 li 없음"); return; }

                var rno = $button.attr("data-rno"); // .data("rno") -> .attr("data-rno")
                var $textarea = $replyItem.find('.reply-edit-textarea');
                if (!$textarea.length) { console.error("[SAVE] textarea 없음"); return; }
                var newText = $textarea.val().trim();

                console.log("[SAVE] 데이터 확인: rno=", rno, ", newText=", newText); // 2. 데이터 확인

                // 3. newText 유효성 검사
                if (!newText) { alert("수정 내용 입력 필요"); return; }
                console.log("[SAVE] newText 유효성 통과.");
                
            	 // ★★★ 누락된 rnoNum 정의 및 숫자 변환 추가 ★★★
                var rnoNum = parseInt(rno, 10); 
                // ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

                // 4. rno 유효성 검사
                if (!rnoNum || rnoNum <= 0) { 
                 alert("댓글 번호 오류 (값: " + rno + ")"); // 오류 메시지에 실제 값 포함
                 console.error("[SAVE] rno 오류:", rno); 
                 return; 
             	}
             	console.log("[SAVE] rno 유효성 통과 (rnoNum:", rnoNum, ")");

                var replyData = { replytext: newText }; 
                console.log("[SAVE] AJAX 전송 데이터:", replyData); // 5. 전송 데이터 확인

                $button.prop('disabled', true).text('저장중...');
                 $replyItem.find('.btnCancelEdit').prop('disabled', true);

                // 6. AJAX PUT 요청 시도
                 console.log("[SAVE] AJAX 요청 시도: PUT /replies/" + rnoNum); // rnoNum 사용
                 $.ajax({
                     type: "PUT", 
                     url: "${pageContext.request.contextPath}/replies/" + rnoNum, // rnoNum 사용
                     data: JSON.stringify(replyData), 
                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     success: function(response) {
                          console.log("[SAVE] AJAX 성공:", response); 
                          alert(response && response.message ? response.message : "처리 완료"); 
                          if (response && response.success) { 
                             console.log("[SAVE] 목록 새로고침 호출..."); 
                             loadReplies(currentBno); 
                          } 
                          else { 
                              $button.prop('disabled', false).text('저장');
                              $replyItem.find('.btnCancelEdit').prop('disabled', false);
                         }
                     },
                     error: function(jqXHR, textStatus, errorThrown) {
                         console.error("[SAVE] AJAX 실패:", textStatus, errorThrown, jqXHR.responseText);
                         alert("수정 중 오류 발생");
                          $button.prop('disabled', false).text('저장');
                          $replyItem.find('.btnCancelEdit').prop('disabled', false);
                     },
                      complete: function() { 
                         console.log("[SAVE] AJAX 완료."); 
                      }
                 }); 
            }); // End btnSaveReply click
            
            

        } catch (e) {
            console.error("[DEBUG] 이벤트 핸들러 연결 중 또는 이후 로직에서 오류 발생!", e);
        }

        console.log("[DEBUG] Document ready 끝"); 
    }); // End document ready
</script>
</body>
</html>
