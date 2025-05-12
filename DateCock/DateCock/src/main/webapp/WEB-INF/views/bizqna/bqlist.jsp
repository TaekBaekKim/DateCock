<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기업 문의 목록</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
    /* --- 기본 스타일 (uqlist.jsp 스타일 기반) --- */
    .container { width: 80%; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }

    /* --- 로고와 제목 영역 스타일 --- */
    .list-title-area {
        display: flex; /* 요소들을 가로로 배치 */
        align-items: center; /* 수직 가운데 정렬 */
        justify-content: center; /* 수평 가운데 정렬 */
        gap: 15px; /* 로고와 제목 사이 간격 */
        margin-bottom: 20px; /* 아래 요소와의 간격 */
    }
    .header-logo {
        height: 80px; /* 로고 높이 조절 */
        width: auto;
    }
    .list-title-area h2 {
        color: #333;
        margin: 0; /* flex 정렬을 위해 기본 마진 제거 */
        font-size: 1.9em; /* 로고 크기에 맞춰 조절 */
    }

    /* --- 검색 영역 스타일 --- */
    .search-area { margin-bottom: 20px; text-align: center; }
    .search-area select, .search-area input[type="text"] { padding: 8px; margin-right: 5px; border: 1px solid #ddd; border-radius: 4px; }
    .search-area button { padding: 8px 15px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
    .search-area button:hover { background-color: #0056b3; }

    /* --- 테이블 스타일 --- */
    .table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    .table th, .table td { padding: 12px; border: 1px solid #eee; text-align: center; } /* 기본 td도 center 정렬 */
    .table th { background-color: #f8f9fa; color: #333; }
    .table td.title-cell { text-align: left; } /* 제목만 좌측 정렬 필요시 */
    .table td a { color: #000000; text-decoration: none; display: inline-block; vertical-align: middle; }
    .table td a:hover { color: #000000; text-decoration: underline; }
    .lock-icon, .image-icon { vertical-align: middle; margin-left: 5px; color: #6c757d; font-size: 0.9em; }
    .table td a > i.lock-icon, .table td a > i.image-icon { color: #6c757d; }


    /* --- 배지 스타일 (uqlist.jsp 스타일 기반) --- */
    .badge { display: inline-block; padding: .35em .65em; font-size: .75em; font-weight: 700; line-height: 1; color: #fff; text-align: center; white-space: nowrap; vertical-align: baseline; border-radius: .25rem; }
    .badge-success { background-color: #28a745; } /* 답변완료 */
    .badge-warning { background-color: #ffc107; color: #212529;} /* 답변대기 */

    /* --- 버튼 스타일 --- */
    .text-right { text-align: right; }
    .btn { display: inline-block; font-weight: 400; color: #212529; text-align: center; vertical-align: middle; cursor: pointer; user-select: none; background-color: transparent; border: 1px solid transparent; padding: .375rem .75rem; font-size: 1rem; line-height: 1.5; border-radius: .25rem; transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out; text-decoration: none !important; }
    .btn-custom-dark { /* 문의하기 버튼 - 핑크색 */
        color: #fff;
        background-color: #FF5597;
        border-color: #FF5597;
        text-decoration: none !important;
    }
    .btn-custom-dark:hover {
        color: #fff;
        background-color: #E64C88;
        border-color: #E64C88;
        text-decoration: none !important;
    }

    /* --- 페이징 스타일 (uqlist.jsp 스타일 기반) --- */
    .pagination-container { display: flex; justify-content: center; margin-top: 20px;}
    .pagination { display: flex; padding-left: 0; list-style: none; border-radius: .25rem; }
    .page-item .page-link { position: relative; display: block; padding: .5rem .75rem; margin-left: 0px; line-height: 1.25; color: #333; background-color: transparent; border: none; text-decoration: none; }
    .page-item .page-link:hover { color: #0056b3; text-decoration: underline; background-color: #f8f9fa; }
    .page-item.active .page-link { z-index: 3; font-weight: bold; text-decoration: underline; color: #0056b3; }

    /* --- Alert 메시지 스타일 (Bootstrap 기본 스타일 활용 또는 커스텀) --- */
    .alert { padding: 15px; margin-bottom: 20px; border: 1px solid transparent; border-radius: 4px; }
    .alert-success { color: #155724; background-color: #d4edda; border-color: #c3e6cb; }
    .alert-danger { color: #721c24; background-color: #f8d7da; border-color: #f5c6cb; }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>


<c:set var="list" value="${requestScope.list}" />
<c:set var="paging" value="${requestScope.paging}" />
<c:set var="isUserAdmin" value="${requestScope.isUserAdmin}" />
<c:set var="currentLoginUserId" value="${requestScope.currentLoginUserId}" />


<div class="container">
    <%-- === 로고 + 제목 영역 === --%>
    <div class="list-title-area">
        <img src="${pageContext.request.contextPath}/image/DateCocklogo.png" alt="DateCock Logo" class="header-logo">
        <h2>기업 문의 목록</h2>
    </div>
    <%-- ======================= --%>

    <%-- 검색 영역 --%>
    <div class="search-area">
        <form method="get" action="<c:url value='/bqlist'/>">
            <select name="searchType">
                <option value="t" ${paging.searchType == 't' ? 'selected' : ''}>제목</option>
                <option value="c" ${paging.searchType == 'c' ? 'selected' : ''}>내용</option>
                <option value="w" ${paging.searchType == 'w' ? 'selected' : ''}>작성자 ID</option> <%-- '작성자 ID'로 변경 --%>
                <%-- *** 추가: 사업자명 검색 옵션 *** --%>
                <option value="bn" ${paging.searchType == 'bn' ? 'selected' : ''}>사업자명</option>
                <option value="tc" ${paging.searchType == 'tc' ? 'selected' : ''}>제목+내용</option>
            </select>
            <input type="text" name="keyword" value="<c:out value='${paging.keyword}'/>" placeholder="검색어를 입력하세요">
            <input type="hidden" name="cntPerPage" value="${paging.cntPerPage}">
            <button type="submit">검색</button>
        </form>
    </div>

    <%-- 에러/성공 메시지 표시 --%>
    <c:if test="${not empty message}">
        <div class="alert alert-success flash-message" role="alert">${message}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger flash-message" role="alert">${errorMessage}</div>
    </c:if>

    <table class="table table-hover">
        <thead>
            <tr>
                <%-- *** 수정: 컬럼 너비 조정 및 헤더 추가 *** --%>
                <th style="width:35%;">제목</th>
                <th style="width:15%;">사업자명</th> <%-- 사업자명 컬럼 추가 --%>
                <th style="width:15%;">작성자 ID</th> <%-- '작성자 ID'로 변경 --%>
                <th style="width:15%;">작성일</th>
                <th style="width:10%;">조회수</th>
                <th style="width:10%;">답변상태</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty list}">
                    <tr>
                        <td colspan="6" style="text-align: center;">등록된 기업 문의가 없습니다.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${list}" var="item">
                        <c:set var="isSecret" value="${item.secret == 1}" />
                        <c:set var="canViewSecret" value="${isUserAdmin or (not empty currentLoginUserId and currentLoginUserId == item.writer)}" />

                        <tr>
                            <%-- *** 수정: 컬럼 순서 및 내용 변경 *** --%>
                            <td style="text-align: center;"> <%-- 제목 --%>
                                <c:choose>
                                    <c:when test="${isSecret and not canViewSecret}">
                                        <span style="color:gray;">비밀글입니다.</span>
                                        <i class="fa-solid fa-lock lock-icon"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="viewUrl" value="/bqview">
                                            <c:param name="bno" value="${item.bno}" />
                                            <c:param name="nowPage" value="${paging.nowPage}" />
                                            <c:param name="cntPerPage" value="${paging.cntPerPage}" />
                                            <c:if test="${not empty paging.searchType && not empty paging.keyword}">
                                                <c:param name="searchType" value="${paging.searchType}" />
                                                <c:param name="keyword" value="${paging.keyword}" />
                                            </c:if>
                                        </c:url>
                                        <a href="${viewUrl}">
                                            <c:out value="${item.title}"/>
                                            <c:if test="${isSecret}"><i class="fa-solid fa-lock lock-icon"></i></c:if>
                                            <c:if test="${not empty item.imageFile}"><i class="fa-solid fa-image image-icon"></i></c:if>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><c:out value="${item.businessName}"/></td> <%-- 사업자명 표시 --%>
                            <td><c:out value="${item.writer}"/></td> <%-- 작성자 ID(사업자 번호 또는 관리자 ID) 표시 --%>
                            <td><fmt:formatDate value="${item.regdate}" pattern="yyyy-MM-dd"/></td>
                            <td>${item.viewcnt}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.answerStatus == '답변완료'}"><span class="badge badge-success">답변완료</span></c:when>
                                    <c:otherwise><span class="badge badge-warning">답변대기</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <%-- 문의하기 버튼 (변경 없음) --%>
    <div class="text-right" style="margin-bottom: 10px;">
        <c:if test="${sessionScope.buisnessloginstate == true and not empty sessionScope.businessnumberA}">
            <a href="<c:url value='/bqwrite'/>" class="btn btn-custom-dark">문의하기</a>
        </c:if>
    </div>

    <%-- 페이징 (변경 없음) --%>
    <c:if test="${not empty paging and paging.total > 0}">
        <div class="pagination-container">
            <ul class="pagination">
                <%-- 이전 페이지 그룹 링크 --%>
                <c:if test="${paging.startPage > 1}">
                    <c:url var="prevPageUrl" value="/bqlist">
                         <c:param name="nowPage" value="${paging.startPage - 1}" />
                         <c:param name="cntPerPage" value="${paging.cntPerPage}" />
                         <c:if test="${not empty paging.searchType && not empty paging.keyword}">
                             <c:param name="searchType" value="${paging.searchType}" />
                             <c:param name="keyword" value="${paging.keyword}" />
                         </c:if>
                    </c:url>
                    <li class="page-item"><a class="page-link" href="${prevPageUrl}">이전</a></li>
                </c:if>
                 <%-- 페이지 번호 링크들 --%>
                 <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="p">
                     <c:url var="pageNumUrl" value="/bqlist">
                         <c:param name="nowPage" value="${p}" />
                         <c:param name="cntPerPage" value="${paging.cntPerPage}" />
                         <c:if test="${not empty paging.searchType && not empty paging.keyword}">
                             <c:param name="searchType" value="${paging.searchType}" />
                             <c:param name="keyword" value="${paging.keyword}" />
                         </c:if>
                     </c:url>
                     <li class="page-item ${p == paging.nowPage ? 'active' : ''}">
                         <a class="page-link" href="${pageNumUrl}">${p}</a>
                     </li>
                 </c:forEach>
                 <%-- 다음 페이지 그룹 링크 --%>
                 <c:if test="${paging.endPage < paging.lastPage}">
                      <c:url var="nextPageUrl" value="/bqlist">
                         <c:param name="nowPage" value="${paging.endPage + 1}" />
                         <c:param name="cntPerPage" value="${paging.cntPerPage}" />
                         <c:if test="${not empty paging.searchType && not empty paging.keyword}">
                             <c:param name="searchType" value="${paging.searchType}" />
                             <c:param name="keyword" value="${paging.keyword}" />
                         </c:if>
                     </c:url>
                     <li class="page-item"><a class="page-link" href="${nextPageUrl}">다음</a></li>
                 </c:if>
            </ul>
        </div>
    </c:if>
</div>

<%-- JavaScript (Flash 메시지 Fade Out - 변경 없음) --%>
<script type="text/javascript">
    $(document).ready(function() {
        var $flashMessages = $(".flash-message, .alert.alert-success, .alert.alert-danger");
        if ($flashMessages.length > 0) {
            setTimeout(function() {
                $flashMessages.fadeOut('slow');
            }, 3000);
        }
    });
</script>

</body>
</html>