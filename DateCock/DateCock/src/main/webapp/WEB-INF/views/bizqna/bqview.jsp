<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:out value="${not empty dto.title ? dto.title : '(제목 없음)'}"/> - 기업 문의</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
    /* --- "고객 문의 상세 보기" 페이지의 스타일 유지 --- */
    .container { width: 70%; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h2 { text-align: center; color: #333; margin-bottom: 10px; }
    .board-view-info { font-size: 0.9em; color: #777; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 1px solid #eee; text-align: center; }
    .board-view-info strong { color: #555; }
    .board-view-info span { margin: 0 8px; }
    .board-content { min-height: 150px; padding: 15px 0; line-height: 1.8; white-space: pre-wrap; word-wrap: break-word; }
    .secret-message { color: #dc3545; font-weight: bold; padding: 30px; text-align: center; border: 1px dashed #dc3545; border-radius: 5px; margin: 20px 0; }
    .qna-image-view { text-align: center; margin: 15px 0; } /* 이미지 컨테이너 스타일 */
    .qna-image-view img { display: block; margin: 0 auto; max-width: 100%; max-height: 400px; border: 1px solid #ddd; padding: 5px; }
    .answer-section { margin-top: 30px; border-top: 2px solid #007bff; padding-top: 20px; }
    .answer-section h4 { color: #007bff; margin-bottom: 10px; }
    .answer-content { background-color: #e9f7ff; padding: 15px; border-radius: 5px; margin-bottom: 10px; line-height: 1.7; white-space: pre-wrap; word-wrap: break-word; }
    .answer-info { font-size: 0.85em; color: #666; text-align: right; margin-bottom: 10px; }
    .button-group { margin-top: 20px; text-align: right; }
    .btn { display: inline-block; font-weight: 400; text-align: center; vertical-align: middle; cursor: pointer; user-select: none; background-color: transparent; border: 1px solid transparent; padding: .375rem .75rem; font-size: 1rem; line-height: 1.5; border-radius: .25rem; text-decoration: none; margin-left: 5px; }
    .btn-secondary { color: #fff; background-color: #6c757d; border-color: #6c757d; }
    .btn-primary { color: #fff; background-color: #007bff; border-color: #007bff; }
    .btn-danger { color: #fff; background-color: #dc3545; border-color: #dc3545; }
    .btn-success { color: #fff; background-color: #28a745; border-color: #28a745; }
    .admin-answer-form textarea.form-control { width: calc(100% - 22px); padding: 10px; border: 1px solid #ddd; border-radius: 4px; margin-bottom: 10px; resize: vertical; box-sizing: border-box; } /* form-control 클래스 추가시 */
    .lock-icon { width: 1em; height: 1em; vertical-align: text-bottom; margin-left: 5px; color: #6c757d; }
    .alert { padding: 10px; border: 1px solid transparent; margin-bottom: 15px; border-radius: 4px; }
    .alert-warning { color: #856404; background-color: #fff3cd; border-color: #ffeeba; }
    .alert-success { color: #155724; background-color: #d4edda; border-color: #c3e6cb; }
    .alert-danger { color: #721c24; background-color: #f8d7da; border-color: #f5c6cb; }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<c:set var="dto" value="${requestScope.dto}" />
<c:set var="paging" value="${requestScope.paging}" />
<c:set var="isUserAdmin" value="${sessionScope.isAdmin}" />
<c:set var="currentLoginBusinessNumber" value="${sessionScope.businessnumberA}" /> <%-- 기업회원 사업자번호 --%>


<div class="container">
    <c:choose>
        <c:when test="${not empty dto}">
            <h2>
                <c:out value="${not empty dto.title ? dto.title : '(제목 없음)'}"/>
                <c:if test="${dto.secret == 1}">
                    <i class="fa-solid fa-lock lock-icon"></i>
                </c:if>
            </h2>

            <div class="board-view-info">
                <span><strong>작성자 (사업자번호):</strong> <c:out value="${dto.writer}"/></span> |
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
                <c:choose>
                    <c:when test="${dto.secret == 1 and not isUserAdmin and (empty currentLoginBusinessNumber or currentLoginBusinessNumber != dto.writer)}">
                        <p class="secret-message">
                            <i class="fa-solid fa-lock lock-icon" style="margin-right: 8px;"></i>
                            비밀글입니다. 작성자와 관리자만 내용을 확인할 수 있습니다.
                        </p>
                    </c:when>
                    <c:otherwise>
                        <c:out value="${dto.content}" escapeXml="false"/>
                        <c:if test="${not empty dto.imageFile}">
						    <div class="qna-image-view">
						        <h4>첨부 이미지</h4>
						        <img src="<c:url value='/image/${dto.imageFile}'/>" alt="첨부 이미지 (${dto.imageFile})">
						    </div>
						</c:if>
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
                        <c:out value="${dto.answerContent}" escapeXml="false"/>
                    </div>
                </div>
            </c:if>

            <%-- 버튼 그룹 --%>
            <div class="button-group">
                <c:url var="listUrl" value="/bqlist">
                    <c:if test="${not empty paging}">
                        <c:param name="nowPage" value="${paging.nowPage}"/>
                        <c:param name="cntPerPage" value="${paging.cntPerPage}"/>
                        <c:if test="${not empty paging.searchType}"><c:param name="searchType" value="${paging.searchType}"/></c:if>
                        <c:if test="${not empty paging.keyword}"><c:param name="keyword" value="${paging.keyword}"/></c:if>
                    </c:if>
                </c:url>
                <a href="${listUrl}" class="btn btn-secondary">목록</a>

                <c:if test="${(sessionScope.buisnessloginstate == true and currentLoginBusinessNumber == dto.writer) or isUserAdmin == true}">
                    <c:url var="editUrl" value="/bqedit">
                        <c:param name="bno" value="${dto.bno}"/>
                        <c:if test="${not empty paging}"><c:param name="nowPage" value="${paging.nowPage}"/><c:param name="cntPerPage" value="${paging.cntPerPage}"/><c:param name="searchType" value="${paging.searchType}"/><c:param name="keyword" value="${paging.keyword}"/></c:if>
                    </c:url>
                    <a href="${editUrl}" class="btn btn-primary">수정</a>

                    <c:url var="deleteBaseUrl" value="/bqdelete">
                        <c:param name="bno" value="${dto.bno}"/>
                         <c:if test="${not empty paging}"><c:param name="nowPage" value="${paging.nowPage}"/><c:param name="cntPerPage" value="${paging.cntPerPage}"/><c:param name="searchType" value="${paging.searchType}"/><c:param name="keyword" value="${paging.keyword}"/></c:if>
                    </c:url>
                    <a href="javascript:void(0);" onclick="deleteBizQna('${dto.bno}', '${deleteBaseUrl}');" class="btn btn-danger">삭제</a>
                </c:if>
            </div>

            <%-- 관리자 답변 작성/수정 폼 --%>
            <c:if test="${isUserAdmin == true}">
                <div class="answer-section admin-answer-form" style="margin-top:30px;">
                    <h4>${dto.answerStatus == '답변완료' ? "[답변 수정]" : "[답변 작성]"}</h4>
                    <form action="<c:url value='/bqSaveAnswer'/>" method="post" id="answerForm">
                        <input type="hidden" name="bno" value="${dto.bno}">
                        <c:if test="${not empty paging}">
                            <input type="hidden" name="nowPage" value="${paging.nowPage}">
                            <input type="hidden" name="cntPerPage" value="${paging.cntPerPage}">
                            <input type="hidden" name="searchType" value="${paging.searchType}">
                            <input type="hidden" name="keyword" value="${paging.keyword}">
                        </c:if>
                        <div class="form-group"> <%-- form-group 추가 --%>
                            <textarea name="answerContent" class="form-control" rows="5" placeholder="답변 내용을 입력하세요." required><c:out value="${dto.answerContent}"/></textarea>
                        </div>
                        <button type="submit" class="btn btn-success">답변 저장</button>
                    </form>
                </div>
            </c:if>

        </c:when>
        <c:otherwise>
            <div class="alert alert-warning">해당 문의글을 찾을 수 없거나 접근 권한이 없습니다.</div>
            <c:url var="listUrlDefault" value="/bqlist">
                 <c:if test="${not empty paging}"><c:param name="nowPage" value="${paging.nowPage}"/><c:param name="cntPerPage" value="${paging.cntPerPage}"/><c:param name="searchType" value="${paging.searchType}"/><c:param name="keyword" value="${paging.keyword}"/></c:if>
            </c:url>
            <a href="${listUrlDefault}" class="btn btn-secondary">목록으로</a>
        </c:otherwise>
    </c:choose>

    <%-- 에러/성공 메시지 표시 --%>
    <c:if test="${not empty message}">
        <div id="rttrMessage" class="alert alert-success" role="alert" style="margin-top: 20px;">${message}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div id="rttrErrorMessage" class="alert alert-danger" role="alert" style="margin-top: 20px;">${errorMessage}</div>
    </c:if>
</div>

<script type="text/javascript">
    function deleteBizQna(bno, deleteUrl) { // 함수명은 bqview.jsp의 것을 따름
        if (confirm(" 기업 문의글을 정말 삭제하시겠습니까?\n이 작업은 복구할 수 없습니다.")) {
            location.href = deleteUrl;
        }
    }

    $(document).ready(function(){
        $("#answerForm").submit(function(event){ // event 파라미터 추가
            if($("textarea[name='answerContent']", this).val().trim() === ""){
                alert("답변 내용을 입력해주세요.");
                $("textarea[name='answerContent']", this).focus();
                event.preventDefault(); // 폼 제출 중단
                return false;
            }
            return true;
        });
     // --- 추가된 코드 시작 ---
        // 성공 메시지가 있다면 3초 후에 서서히 사라지도록 처리
        if ($("#rttrMessage").length) { // id="rttrMessage" 인 요소가 있다면
            setTimeout(function() {
                $("#rttrMessage").fadeOut("slow", function() {
                    $(this).remove(); // DOM에서 완전히 제거 (선택사항)
                });
            }, 3000); // 3000 밀리초 = 3초
        }

        // 에러 메시지가 있다면 3초 후에 서서히 사라지도록 처리
        if ($("#rttrErrorMessage").length) { // id="rttrErrorMessage" 인 요소가 있다면
            setTimeout(function() {
                $("#rttrErrorMessage").fadeOut("slow", function() {
                    $(this).remove(); // DOM에서 완전히 제거 (선택사항)
                });
            }, 3000); // 3000 밀리초 = 3초
        }
        // --- 추가된 코드 끝 ---
        
        
        
    });
</script>

</body>
</html>