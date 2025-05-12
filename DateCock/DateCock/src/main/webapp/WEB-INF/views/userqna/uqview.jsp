<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> <%-- JSTL 함수 사용 위해 추가 --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%-- EL을 사용하여 동적으로 페이지 제목 설정 --%>
<title><c:out value="${dto.title != null ? dto.title : '(제목 없음)'}"/> - 고객 문의</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
    /* --- 기존 스타일 유지 --- */
    .container { width: 70%; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h2 { text-align: center; color: #333; margin-bottom: 10px; }
    .board-view-info { font-size: 0.9em; color: #777; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 1px solid #eee; text-align: center; /* 정보 가운데 정렬 */ }
    .board-view-info strong { color: #555; }
    .board-view-info span { margin: 0 8px; } /* 정보 간 간격 */
    .board-content { min-height: 150px; padding: 15px 0; line-height: 1.8; white-space: pre-wrap; /* CSS로 줄바꿈 처리 */ word-wrap: break-word; /* 긴 단어 자동 줄바꿈 */ }
    .secret-message { color: #dc3545; font-weight: bold; padding: 30px; text-align: center; border: 1px dashed #dc3545; border-radius: 5px; margin: 20px 0; }
    .answer-section { margin-top: 30px; border-top: 2px solid #007bff; padding-top: 20px; }
    .answer-section h4 { color: #007bff; margin-bottom: 10px; }
    .answer-content { background-color: #e9f7ff; padding: 15px; border-radius: 5px; margin-bottom: 10px; line-height: 1.7; white-space: pre-wrap; word-wrap: break-word; }
    .answer-info { font-size: 0.85em; color: #666; text-align: right; margin-bottom: 10px; /* 답변 내용과 간격 */ }
    .button-group { margin-top: 20px; text-align: right; }
    .btn { display: inline-block; font-weight: 400; text-align: center; vertical-align: middle; cursor: pointer; user-select: none; background-color: transparent; border: 1px solid transparent; padding: .375rem .75rem; font-size: 1rem; line-height: 1.5; border-radius: .25rem; text-decoration: none; margin-left: 5px; /* 버튼 간 간격 */}
    .btn-secondary { color: #fff; background-color: #6c757d; border-color: #6c757d; }
    .btn-primary { color: #fff; background-color: #007bff; border-color: #007bff; }
    .btn-danger { color: #fff; background-color: #dc3545; border-color: #dc3545; }
    .btn-success { color: #fff; background-color: #28a745; border-color: #28a745; }
    .admin-answer-form textarea { width: calc(100% - 22px); padding: 10px; border: 1px solid #ddd; border-radius: 4px; margin-bottom: 10px; resize: vertical; box-sizing: border-box; }
    .lock-icon { width: 1em; height: 1em; vertical-align: text-bottom; margin-left: 5px; color: #6c757d; /* 아이콘 색상 명시 */}
    .qna-image-view img { display: block; margin: 15px auto; max-width: 100%; max-height: 400px; border: 1px solid #ddd; padding: 5px; } /* 이미지 스타일 수정 */
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<%-- 페이지 스코프 변수 설정 (가독성을 위해) --%>
<c:set var="dto" value="${requestScope.dto}" />
<c:set var="paging" value="${requestScope.paging}" />
<c:set var="isUserAdmin" value="${sessionScope.isAdmin}" /> <%-- 세션에서 가져옴 --%>
<c:set var="currentLoginUserId" value="${sessionScope.id}" /> <%-- 세션에서 가져옴 --%>

<div class="container">
    <h2>
        <c:out value="${not empty dto.title ? dto.title : '(제목 없음)'}"/>
        <%-- 비밀글(secret==1)이면 자물쇠 아이콘 표시 --%>
        <c:if test="${dto.secret == 1}">
            <i class="fa-solid fa-lock lock-icon"></i>
        </c:if>
    </h2>

    <div class="board-view-info">
        <span><strong>번호:</strong> ${dto.bno}</span> |
        <span><strong>작성자:</strong> <c:out value="${dto.writer}"/></span> |
        <span><strong>작성일:</strong> <fmt:formatDate value="${dto.regdate}" pattern="yyyy-MM-dd HH:mm"/></span> |
        <span><strong>조회수:</strong> ${dto.viewcnt}</span> |
        <span>
            <strong>답변상태:</strong>
            <c:choose>
                <c:when test="${dto.answerStatus == '답변완료'}">
                    <span style="color:green; font-weight:bold;">답변완료</span>
                </c:when>
                <c:otherwise>
                    <span style="color:orange; font-weight:bold;">답변대기</span>
                </c:otherwise>
            </c:choose>
        </span>
    </div>

     <div class="board-content">
        <%-- 내용 표시 로직 --%>
        <c:choose>
            <c:when test="${dto.secret == 1 and not isUserAdmin and (empty currentLoginUserId or currentLoginUserId != dto.writer)}">
                <p class="secret-message">
                    <i class="fa-solid fa-lock lock-icon" style="margin-right: 8px;"></i>
                    비밀글입니다. 작성자와 관리자만 내용을 확인할 수 있습니다.
                </p>
            </c:when>
            <c:otherwise>
                <c:out value="${dto.content}" escapeXml="false"/>

                <%-- ====================================================== --%>
                <%-- 이미지 표시 및 디버깅 (이 부분을 집중적으로 확인) --%>
                <%-- ====================================================== --%>
                <c:if test="${not empty dto.imageFile}">
                    <div class="qna-image-view">
                        <h4>첨부 이미지</h4>
                        <div class="debug-info">
                        </div>
                        <%-- 3. 실제 이미지 태그 --%>
                        <c:url var="imageUrl" value="/image/${dto.imageFile}"/>
                        <img src="${imageUrl}" alt="문의 첨부 이미지 (${dto.imageFile})">
                    </div>
                </c:if>
                 <%-- ====================================================== --%>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- 관리자 답변 표시 --%>
    <c:if test="${dto.answerStatus == '답변완료' and not empty dto.answerContent}">
        <div class="answer-section">
            <h4>[답변]</h4>
            <div class="answer-info">
                <strong>답변자:</strong> <c:out value="${dto.answerWriter}"/> |
                <strong>답변일:</strong> <fmt:formatDate value="${dto.answerDate}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
            <div class="answer-content">
                <c:out value="${dto.answerContent}" escapeXml="false"/> <%-- HTML 허용 시 --%>
            </div>
        </div>
    </c:if>

    <%-- 버튼 그룹 --%>
    <div class="button-group">
         <%-- 목록 URL 생성 (c:param 사용) --%>
    <c:url var="listUrl" value="/uqlist"> <%-- 기본 URL 경로만 지정 --%>
        <%-- paging 객체가 있고 파라미터가 필요할 경우 c:param으로 추가 --%>
		        <c:if test="${not empty paging}">
		            <c:param name="nowPage" value="${paging.nowPage}"/>
		            <c:param name="cntPerPage" value="${paging.cntPerPage}"/>
		            <c:if test="${not empty paging.searchType}"><c:param name="searchType" value="${paging.searchType}"/></c:if>
		            <c:if test="${not empty paging.keyword}"><c:param name="keyword" value="${paging.keyword}"/></c:if>
		        </c:if>
    </c:url>
    		<a href="${listUrl}" class="btn btn-secondary">목록</a>


        <%-- 수정/삭제 권한 확인 (관리자 이거나 본인 글) --%>
        <c:if test="${isUserAdmin or (not empty currentLoginUserId and currentLoginUserId == dto.writer)}">
            <%-- 수정 URL 생성 (PageDTO의 makeQuery 사용 가정) --%>
            <c:url var="editUrl" value="/uqedit?bno=${dto.bno}${paging.makeQuery(paging.nowPage)}"/>
            <a href="${editUrl}" class="btn btn-primary">수정</a>

            <%-- 삭제 URL 생성 (c:param 사용) --%>
        <c:url var="deleteBaseUrl" value="/uqdelete">
             <c:param name="bno" value="${dto.bno}"/>
             <c:if test="${not empty paging}">
                 <c:param name="nowPage" value="${paging.nowPage}"/>
                 <c:param name="cntPerPage" value="${paging.cntPerPage}"/>
                 <c:if test="${not empty paging.searchType}"><c:param name="searchType" value="${paging.searchType}"/></c:if>
                 <c:if test="${not empty paging.keyword}"><c:param name="keyword" value="${paging.keyword}"/></c:if>
             </c:if>
        </c:url>
        <a href="javascript:void(0);" onclick="deleteQna('${dto.bno}', '${deleteBaseUrl}');" class="btn btn-danger">삭제</a>
        </c:if>
    </div>

    <%-- 관리자 답변 작성/수정 폼 --%>
    <c:if test="${isUserAdmin}">
        <div class="answer-section admin-answer-form" style="margin-top:30px;">
            <h4>${dto.answerStatus == '답변완료' ? "[답변 수정]" : "[답변 작성]"}</h4>
            <c:url var="saveAnswerUrl" value="/saveAnswer"/>
            <form action="${saveAnswerUrl}" method="post" id="answerForm">
                <input type="hidden" name="bno" value="${dto.bno}">
                <%-- 페이징 정보 hidden 필드 --%>
                <c:if test="${not empty paging}">
                    <input type="hidden" name="nowPage" value="${paging.nowPage}">
                    <input type="hidden" name="searchType" value="${paging.searchType}">
                    <input type="hidden" name="keyword" value="${paging.keyword}">
                    <input type="hidden" name="cntPerPage" value="${paging.cntPerPage}">
                </c:if>

                <div class="form-group">
                    <textarea name="answerContent" class="form-control" rows="5" placeholder="답변 내용을 입력하세요." required><c:out value="${dto.answerContent}"/></textarea>
                </div>
                <button type="submit" class="btn btn-success">답변 저장</button>
            </form>
        </div>
    </c:if>
</div>

<script type="text/javascript">
    function deleteQna(bno, deleteUrl) {
        if (confirm(bno + "번 문의글을 정말 삭제하시겠습니까?\n이 작업은 복구할 수 없습니다.")) {
            location.href = deleteUrl; // JSTL로 생성된 삭제 URL 사용
        }
    }

    $(document).ready(function(){
        // 답변 폼 유효성 검사
        $("#answerForm").submit(function(){
            if($("textarea[name='answerContent']", this).val().trim() === ""){ // 현재 폼 내의 textarea만 선택
                alert("답변 내용을 입력해주세요.");
                $("textarea[name='answerContent']", this).focus();
                return false;
            }
            return true;
        });
    });
</script>

</body>
</html>