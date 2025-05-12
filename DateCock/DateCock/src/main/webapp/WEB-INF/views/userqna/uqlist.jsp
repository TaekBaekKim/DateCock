<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객 문의 목록</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
    /* --- 기본 스타일 --- */
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
        height: 80px; /* 로고 높이 조절 (기존 80px은 너무 클 수 있음) */
        width: auto;
    }
    .list-title-area h2 {
        /* h2 기본 스타일 */
        color: #333;
        margin: 0; /* flex 정렬을 위해 기본 마진 제거 */
        font-size: 1.9em; /* 로고 크기에 맞춰 조절 */
        /* text-align: center; 는 flex의 justify-content로 대체 */
    }

    /* --- 나머지 스타일 유지 --- */
    .search-area { margin-bottom: 20px; text-align: center; }
    .search-area select, .search-area input[type="text"] { padding: 8px; margin-right: 5px; border: 1px solid #ddd; border-radius: 4px; }
    .search-area button { padding: 8px 15px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
    .search-area button:hover { background-color: #0056b3; }
    .table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    .table th, .table td { padding: 12px; border: 1px solid #eee; text-align: center; }
    .table th { background-color: #f8f9fa; color: #333; }
    .badge { display: inline-block; padding: .35em .65em; font-size: .75em; font-weight: 700; line-height: 1; color: #fff; text-align: center; white-space: nowrap; vertical-align: baseline; border-radius: .25rem; }
    .badge-success { background-color: #28a745; }
    .badge-warning { background-color: #ffc107; color: #212529;}
    .text-right { text-align: right; }
    .btn { display: inline-block; font-weight: 400; color: #212529; text-align: center; vertical-align: middle; cursor: pointer; user-select: none; background-color: transparent; border: 1px solid transparent; padding: .375rem .75rem; font-size: 1rem; line-height: 1.5; border-radius: .25rem; transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out; text-decoration: none !important; } /* 모든 버튼 밑줄 제거 */
     .btn-custom-dark { /* 클래스 이름은 그대로 두되, 스타일은 핑크색으로 */
        color: #fff;
        background-color: #FF5597; /* 원래 핑크색 배경 */
        border-color: #FF5597;   /* 테두리도 핑크색으로 맞춤 (기존 #23272b 대신) */
        text-decoration: none !important; /* 밑줄 제거 */
    }
    .btn-custom-dark:hover {
        color: #fff;
        background-color: #E64C88; /* 호버 시 약간 진한 핑크 */
        border-color: #E64C88;   /* 호버 시 테두리색 */
        text-decoration: none !important; /* 호버 시에도 밑줄 제거 */
    }
    .pagination-container { display: flex; justify-content: center; margin-top: 20px;}
    .pagination { display: flex; padding-left: 0; list-style: none; border-radius: .25rem; }
    .page-item .page-link { position: relative; display: block; padding: .5rem .75rem; margin-left: 0px; line-height: 1.25; color: #333; background-color: transparent; border: none; text-decoration: none; }
    .page-item .page-link:hover { color: #0056b3; text-decoration: underline; background-color: #f8f9fa; }
    .page-item.active .page-link { z-index: 3; font-weight: bold; text-decoration: underline; color: #0056b3; }
    .table td a { color: #000000; text-decoration: none; display: inline-block; vertical-align: middle; }
    .table td a:hover { color: #000000; text-decoration: underline; }
    .lock-icon { vertical-align: middle; margin-left: 5px; color: #6c757d; font-size: 0.9em; }
    .table td a > i.lock-icon { color: #6c757d; }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<c:set var="list" value="${requestScope.list}" />
<c:set var="paging" value="${requestScope.paging}" />
<c:set var="isUserAdmin" value="${sessionScope.isAdmin}" />
<c:set var="currentLoginUserId" value="${sessionScope.id}" />

<div class="container">
    <%-- === 로고 + 제목 영역 === --%>
    <div class="list-title-area">
        <img src="${pageContext.request.contextPath}/image/DateCocklogo.png" alt="DateCock Logo" class="header-logo">
        <h2>고객 문의</h2>
    </div>
    <%-- ======================= --%>

    <%-- 검색 영역 --%>
    <div class="search-area">
        <form action="<c:url value='/uqlist'/>" method="get">
            <select name="searchType">
                <option value="t" ${paging.searchType == 't' ? 'selected' : ''}>제목</option>
                <option value="c" ${paging.searchType == 'c' ? 'selected' : ''}>내용</option>
                <option value="w" ${paging.searchType == 'w' ? 'selected' : ''}>작성자</option>
                <option value="tc" ${paging.searchType == 'tc' ? 'selected' : ''}>제목+내용</option>
            </select>
            <input type="text" name="keyword" value="<c:out value='${paging.keyword}'/>" placeholder="검색어를 입력하세요">
            <c:if test="${not empty paging}">
                <input type="hidden" name="cntPerPage" value="${paging.cntPerPage}">
            </c:if>
            <button type="submit">검색</button>
        </form>
    </div>

    <table class="table">
        <thead>
            <tr>
                <%-- <th style="width:10%;">번호</th> --%>
                <th style="width:40%; text-align: center;">제목</th>
                <th style="width:15%;">작성자</th>
                <th style="width:15%;">작성일</th>
                <th style="width:10%;">조회수</th>
                <th style="width:10%;">답변상태</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty list}">
                    <tr>
                        <td colspan="5">등록된 문의글이 없습니다.</td> <%-- colspan 값 조정 (번호 열 제외 시 5) --%>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${list}" var="item">
                        <c:set var="isSecret" value="${item.secret == 1}" />
                        <c:set var="canViewSecret" value="${isUserAdmin or (not empty currentLoginUserId and currentLoginUserId == item.writer)}" />
                        <tr>
                            <%-- <td>${item.bno}</td> --%>
                            <td> <%-- 제목 열 (가운데 정렬) --%>
                                <c:choose>
                                    <c:when test="${isSecret and not canViewSecret}">
                                        <span style="color:gray;">비밀글입니다.</span>
                                        <i class="fa-solid fa-lock lock-icon"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="viewUrl" value="/uqview"> <c:param name="bno" value="${item.bno}" /> <c:if test="${not empty paging}"><c:param name="nowPage" value="${paging.nowPage}" /><c:param name="cntPerPage" value="${paging.cntPerPage}" /><c:param name="searchType" value="${paging.searchType}" /><c:param name="keyword" value="${paging.keyword}" /></c:if> </c:url>
                                        <a href="${viewUrl}">
                                            <c:out value="${item.title}"/>
                                            <c:if test="${isSecret}">
                                                <i class="fa-solid fa-lock lock-icon"></i>
                                            </c:if>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><c:out value="${item.writer}" /></td>
                            <td><fmt:formatDate value="${item.regdate}" pattern="yyyy-MM-dd" /></td>
                            <td>${item.viewcnt}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.answerStatus == '답변완료'}">
                                        <span class="badge badge-success">답변완료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-warning">답변대기</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <%-- 문의하기 버튼 --%>
    <c:if test="${not isUserAdmin and not empty currentLoginUserId and sessionScope.userType == 'personal'}">
        <div class="text-right" style="margin-bottom: 10px;">
             <a href="<c:url value='/uqwrite'/>" class="btn btn-custom-dark">문의하기</a>
        </div>
    </c:if>

    <%-- 페이징 --%>
    <c:if test="${not empty paging and paging.total > 0}">
        <div class="pagination-container">
            <ul class="pagination">
                <c:if test="${paging.startPage > 1}">
                    <c:url var="prevUrl" value="/uqlist"> <c:if test="${not empty paging}"><c:param name="nowPage" value="${paging.startPage - 1}"/><c:param name="cntPerPage" value="${paging.cntPerPage}"/><c:param name="searchType" value="${paging.searchType}"/><c:param name="keyword" value="${paging.keyword}"/></c:if> </c:url>
                    <li class="page-item"><a class="page-link" href="${prevUrl}">이전</a></li>
                </c:if>
                <c:forEach var="num" begin="${paging.startPage}" end="${paging.endPage}">
                    <c:url var="pageNumUrl" value="/uqlist"> <c:if test="${not empty paging}"><c:param name="nowPage" value="${num}"/><c:param name="cntPerPage" value="${paging.cntPerPage}"/><c:param name="searchType" value="${paging.searchType}"/><c:param name="keyword" value="${paging.keyword}"/></c:if> </c:url>
                    <li class="page-item ${paging.nowPage == num ? 'active' : ''}">
                        <a class="page-link" href="${pageNumUrl}">${num}</a>
                    </li>
                </c:forEach>
                <c:if test="${paging.endPage < paging.lastPage}">
                    <c:url var="nextUrl" value="/uqlist"> <c:if test="${not empty paging}"><c:param name="nowPage" value="${paging.endPage + 1}"/><c:param name="cntPerPage" value="${paging.cntPerPage}"/><c:param name="searchType" value="${paging.searchType}"/><c:param name="keyword" value="${paging.keyword}"/></c:if> </c:url>
                    <li class="page-item"><a class="page-link" href="${nextUrl}">다음</a></li>
                </c:if>
            </ul>
        </div>
    </c:if>
</div>

</body>
</html>