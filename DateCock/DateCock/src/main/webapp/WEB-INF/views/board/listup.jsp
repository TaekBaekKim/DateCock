<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%-- 실제 데이터 사용 시 필요 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- 날짜 포맷팅 위해 필요 --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록 레이아웃</title>
<%-- Font Awesome 아이콘 사용 예시 (선택 사항) --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
/* ★★★ 웹 폰트 import (스타일 규칙 맨 위에!) ★★★ */
@import url('https://cdn.jsdelivr.net/gh/spoqa/spoqa-han-sans@latest/css/SpoqaHanSansNeo/SpoqaHanSansNeo-Regular.css');

   body {
    /* ★★★ 적용할 폰트 이름 지정 ★★★ */
    font-family: 'Spoqa Han Sans Neo', 'sans-serif'; /* '폰트이름', 대체폰트 */
    margin: 0;
    padding: 20px;
    background-color: #f8f9fa;
}
.board-list-container {
    max-width: 800px; /* 필요시 너비 조절 */
    margin: 0 auto;
    background-color: #ffffff;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    justify-content: center; /* 가운데 정렬로 변경 */
}

/* 로고 + 제목 묶는 영역 */
.title-with-logo {
    display: flex;
    align-items: center;
    gap: 12px; /* 로고와 제목 사이 간격 약간 조정 */
    /* 가운데 정렬 효과를 위해 필요시 왼쪽/오른쪽 마진 auto 사용 고려 */
    /* 예: margin: 0 auto; (하지만 space-between과 함께 쓰면 복잡해짐) */
    /* 일단 space-between으로 왼쪽 정렬된 상태 유지 */
}

/* ★★★ 헤더 로고 이미지 크기 키우기 ★★★ */
.header-logo {
    height: 80px;  /* <<<--- 이미지 높이 값을 더 크게 조절 (예: 50px) */
    width: auto;
    display: block;
}

/* 헤더 제목 스타일 */
.list-page-header h1 {
    margin: 0;
    font-size: 1.9em; /* 로고 커짐에 맞춰 약간 크게 (조절 가능) */
    color: #333;
}


h1 {
    text-align: center;
    margin-bottom: 30px;
}
.post-item {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    padding: 18px 20px;
    border-bottom: 1px solid #eee;
    gap: 20px;
}
.post-item:last-child { border-bottom: none; }
.post-item:hover { background-color: #f8f9fa; }
.post-content-area { flex-grow: 1; min-width: 0; }
.post-title { margin: 0 0 6px 0; font-size: 1.1em; font-weight: 500; line-height: 1.4; }
.post-title a { text-decoration: none; color: #212529; }
.post-title a:hover { text-decoration: underline; }
.post-snippet { font-size: 0.9em; color: #495057; margin: 6px 0; line-height: 1.5; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
.post-metadata { font-size: 0.8em; color: #6c757d; margin-top: 10px; display: flex; flex-wrap: wrap; gap: 5px 12px; align-items: center; }
.post-metadata .writer { font-weight: 500; color: #495057; }

.post-metadata .timestamp {}
.post-metadata .stats { margin-left: auto; display: flex; gap: 8px; align-items: center; color: #6c757d; }
.post-metadata .stats i { margin-right: 2px; font-size: 0.9em; }
.post-thumbnail-area { flex-shrink: 0; width: 80px; height: 80px; overflow: hidden; border-radius: 6px; margin-top: 2px; background-color: #eee; }
.post-thumbnail-area img { display: block; width: 100%; height: 100%; object-fit: cover; }


/* ★★★ 목록 상단 헤더 영역 스타일 추가 ★★★ */
.list-page-header {
    max-width: 800px; /* 목록 컨테이너 너비와 맞춤 */
    margin: 0 auto 25px auto; /* 위쪽 여백 및 목록과의 간격 */
    display: flex;
    justify-content: space-between; /* 제목(왼쪽), 버튼(오른쪽) 배치 */
    align-items: center; /* 세로 중앙 정렬 */
    padding-bottom: 15px;
    border-bottom: 2px solid #333; /* 하단 구분선 */
}
.list-page-header h1 {
    text-align: left; /* 제목 왼쪽 정렬 */
    margin-bottom: 0; /* 제목 하단 마진 제거 */
    font-size: 1.8em; /* 제목 크기 */
}
/* 헤더 내 글쓰기 버튼 영역 */
.list-page-header .write-button-area {
   /* 별도 스타일 불필요 (flex item 이므로) */
   /* 이전 .write-button-container 스타일 제거 */
}
/* 글쓰기 버튼 스타일 */
.button.write {
    background-color: #FF5597; color: white; border: 1px solid #343a40 ;
    padding: 8px 14px; /* 크기 조정 */
    font-size: 1em; border-radius: 4px; cursor: pointer;
    transition: background-color 0.2s;
    flex-shrink: 0;
}







/* === 하단 컨트롤 영역 스타일 === */
/* 게시글 목록과 하단 컨트롤 사이 간격 */
.board-list-container {
    margin-bottom: 10px;
}


/* 검색 폼 스타일 (변경 없음) */
.search-form-container { max-width: 800px; margin: 20px auto; padding: 15px 0; border-top: 1px solid #eee; border-bottom: 1px solid #eee; }
/* ... 검색 폼 내부 스타일 (변경 없음) ... */
.search-form { display: flex; justify-content: center; align-items: center; gap: 8px; }
.search-select { padding: 8px 10px; border: 1px solid #ced4da; border-radius: 4px; font-size: 0.9em; height: 38px; flex-shrink: 0;}
.search-input { padding: 8px 12px; border: 1px solid #ced4da; border-radius: 4px; font-size: 0.9em; height: 38px; flex-grow: 1; max-width: 300px;}
.button.search { background-color: #28a745; color: white; border: none; padding: 0 15px; font-size: 1em; height: 38px; border-radius: 4px; cursor: pointer; display: flex; align-items: center; justify-content: center; flex-shrink: 0;}
.button.search i { font-size: 1.1em; }
.button.search:hover { background-color: #218838; }



/* 페이징 영역 (버튼 아래, 중앙 정렬) */
.pagination-container {
    max-width: 800px; /* 목록 컨테이너(.board-list-container)의 max-width와 동일하게 설정 */
    margin: 0 auto;   /* 컨테이너 자체를 가운데 정렬 */
    padding: 15px 0;  /* 위아래 여백 */
    text-align: center; /* 내부 페이지 번호들 가운데 정렬 */
    background-color: transparent; /* 배경 투명 */
    /* border-top: 1px solid #eee; */ /* 구분선은 버튼 영역으로 이동됨 */

    /* ★★★ 푸터와의 간격을 위한 하단 마진 추가 ★★★ */
    /* 이 값을 더 늘려보세요! 예: 80px, 100px, 120px 등 */
    margin-bottom: 100px; /* <<<--- 값을 더 크게 수정해보세요 */
}

/* 페이징 내부 요소들 스타일 (이전 요청 스타일 유지) */
.pagination {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 0;
    border: none;
    background-color: transparent;
}
.pagination a, .pagination span {
    color: #6c757d;
    text-decoration: none;
    padding: 5px 8px;
    font-size: 0.95em;
    border: none;
    background-color: transparent;
}
.pagination a:hover {
    text-decoration: underline;
    color: #0056b3;
}
.pagination span.page-current { /* 현재 페이지만 테두리 */
    color: #007bff;
    font-weight: bold;
    border-radius: 3px;
}
.pagination span.page-disabled {
    color: #ccc;
    cursor: default;
}
.post-metadata .writer strong {
    font-weight: bold; /* 기본값이지만 명시 */
    color: #212529; /* 기본 텍스트 색상 또는 원하는 색상 */
}

</style>
</head>
<body>



<%-- listup.jsp 내부 --%>
<%-- listup.jsp 또는 layout.jsp 등의 상단에 추가 --%>
<c:if test="${not empty message}">
<%-- ★★★ id="flashSuccessMessage" 추가 ★★★ --%>
    <div class="alert alert-success" id="flashSuccessMessage" style="background-color: #dff0d8; color: #3c763d; padding: 10px; border: 1px solid #d6e9c6; margin-bottom: 15px;">
        <c:out value="${message}"/>
    </div>
</c:if>
<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger" id="flashErrorMessage" style="background-color: #f2dede; color: #a94442; padding: 10px; border: 1px solid #ebccd1; margin-bottom: 15px;">
        <c:out value="${errorMessage}"/>
    </div>
</c:if>

<%-- Top 영역 가정 --%>
<div class="page-wrap" style="max-width: 800px; margin: 40px auto;"> <%-- 전체 너비 제어용 랩퍼 (선택적) --%>
	
    <%-- ★★★ 목록 상단 헤더 (제목 + 글쓰기 버튼) ★★★ --%>
    <div class="list-page-header">
          <%-- 로고 + 제목을 묶는 div 추가 --%>
        <div class="title-with-logo">
            <%-- 1. 로고 이미지 추가 --%>
            <img src="${pageContext.request.contextPath}/image/DateCocklogo.png" alt="DateCock Logo" class="header-logo">
            <%-- 2. 기존 제목 --%>
            <h1>자유게시판</h1>
        </div>
        <%-- 글쓰기 버튼 영역 (Flex item 2) --%>
        <div class="write-button-area">
            <c:if test="${not empty sessionScope.personalloginstate && sessionScope.personalloginstate == true}">
                 <button type="button" class="button write" onclick="location.href='${pageContext.request.contextPath}/write'">
                <%-- ★★★ Font Awesome 아이콘 추가 ★★★ --%>
            	<i class="fa-solid fa-pencil"></i>&nbsp;글쓰기 <%-- 아이콘과 텍스트 사이에 공백(&nbsp;) 추가 --%>
            	</button>
            </c:if>
        </div>
    </div>




<div class="board-list-container">

    <%-- 컨트롤러에서 모델에 담아 보낸 "boardList" 사용 --%>
    <c:choose>
        <%-- 1. boardList에 내용이 있을 때: 목록 출력 --%>
        <c:when test="${not empty boardList}">
            <c:forEach items="${boardList}" var="post">
                <div class="post-item">
                    <div class="post-content-area">
                        <h3 class="post-title">
                            <a href="${pageContext.request.contextPath}/view?bno=${post.bno}">
                                <c:out value="${post.title}"/>
                                <c:if test="${post.replycnt > 0}">
                                   <span style="font-size:0.9em; color: #007bff;">[${post.replycnt}]</span>
                                </c:if>
                            </a>
                        </h3>
                        <c:if test="${not empty post.snippet}">
                            <p class="post-snippet"><c:out value="${post.snippet}"/></p>
                        </c:if>
                        <div class="post-metadata">
                             <%-- ★★★ 작성자 출력 부분 수정 ★★★ --%>
                            <span class="writer">
                                <c:choose>
                                    <%-- Controller에서 넘겨준 adminUserId와 게시글 작성자 비교 --%>
                                    <c:when test="${post.writer == adminUserId}">
                                        <%-- 관리자일 경우 strong 태그로 감싸기 --%>
                                        <strong><c:out value="${post.writer}"/></strong>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- 일반 사용자는 그대로 출력 --%>
                                        <c:out value="${post.writer}"/>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                            <%-- ★★★ --- ★★★ --%>
                            
                            <span class="timestamp">${post.relativeTime}</span>
                            <span class="stats">
                            	 <%-- 조회수 아이콘 및 값 추가 --%>
                                <i class="fa-regular fa-eye"></i> ${post.viewcnt}
                                <i class="fa-regular fa-thumbs-up"></i> ${post.likecnt}
                                <i class="fa-regular fa-comment-dots"></i> ${post.replycnt}
                            </span>
                        </div>
                    </div>
                    <c:if test="${not empty post.thumbnail}">
                        <div class="post-thumbnail-area">
                            <a href="${pageContext.request.contextPath}/view?bno=${post.bno}">
                                <img src="${pageContext.request.contextPath}${post.thumbnail}" alt="썸네일">
                            </a>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </c:when>
        <%-- 2. boardList가 비어 있을 때: 아무 내용도 출력하지 않음 --%>
        <c:otherwise>
             <%-- "등록된 게시글이 없습니다." 메시지 출력 부분 삭제 --%>
             <%-- 이 영역을 비워두면 목록 부분이 그냥 비어 있게 됩니다. --%>
             <%-- 필요하다면 최소 높이 등을 CSS로 조절하여 형태는 유지할 수 있습니다. --%>
             <%-- 예: <div style="min-height: 100px;"></div> --%>
        </c:otherwise>
    </c:choose>

</div> <%-- board-list-container 끝 --%>

<div class="search-form-container">
    <%-- 검색 실행 시 목록 페이지(listup)로 GET 요청 --%>
    <form action="${pageContext.request.contextPath}/listup" method="get" class="search-form">

        <%-- 검색 유형 선택 드롭다운 --%>
        <select name="searchType" class="search-select">
            <%-- Controller에서 전달된 paging 객체의 searchType 값과 비교하여 현재 선택된 옵션 표시 --%>
            <%-- 옵션 값(value)은 Service/Mapper에서 사용할 값과 일치해야 합니다 (예: tc, t, c, w) --%>
            <option value="tc" ${paging.searchType == 'tc' ? 'selected' : ''}>제목+내용</option>
            <option value="t"  ${paging.searchType == 't'  ? 'selected' : ''}>제목</option>
            <option value="c"  ${paging.searchType == 'c'  ? 'selected' : ''}>내용</option>
            <option value="w"  ${paging.searchType == 'w'  ? 'selected' : ''}>작성자</option>
            <%-- 필요하다면 다른 검색 옵션 추가 --%>
        </select>

        <%-- 검색어 입력 필드 --%>
        <%-- Controller에서 전달된 paging 객체의 keyword 값을 value로 설정하여 현재 검색어 유지 --%>
        <input type="text" name="keyword" class="search-input" placeholder="검색어를 입력해주세요" value="<c:out value='${paging.keyword}'/>">

        <%-- 검색 버튼 --%>
        <button type="submit" class="button search" aria-label="검색"> <%-- 웹 접근성 위한 라벨 추가 --%>
            <i class="fa-solid fa-magnifying-glass"></i>&nbsp;검색 <%-- Font Awesome 아이콘 (v6 기준) --%>
        </button>

        <%-- 검색 시 페이징 정보 처리:
             - nowPage는 검색 시 1로 초기화되므로 보통 전달 안 함.
             - cntPerPage(페이지당 글 개수)는 현재 설정을 유지하고 싶다면 hidden으로 전달.
               만약 페이지당 글 개수 변경 기능이 없다면 생략 가능.
        --%>
        <c:if test="${paging.cntPerPage != 10}"> <%-- 기본값(10)이 아닐 경우에만 전달 (선택적) --%>
            <input type="hidden" name="cntPerPage" value="${paging.cntPerPage}">
        </c:if>
    </form>
</div>





 

    <%-- ★★★ 페이징 영역 (글쓰기 버튼 아래, 중앙 정렬) ★★★ --%>
    <div class="pagination-container">
        <div class="pagination">
            <%-- 이전/페이지번호/다음 링크 생성 로직 (이전과 동일) --%>
            <c:if test="${paging.startPage > 1}"><a class="page-arrow" href="${pageContext.request.contextPath}/listup?nowPage=${paging.startPage - 1}&cntPerPage=${paging.cntPerPage}" aria-label="Previous">&lt;</a></c:if>
            <c:if test="${paging.startPage <= 1}"><span class="page-arrow page-disabled">&lt;</span></c:if>
            <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="p">
                <c:choose>
                    <c:when test="${paging.nowPage == p}"><span class="page-current">${p}</span></c:when>
                    <c:otherwise><a class="page-link" href="${pageContext.request.contextPath}/listup?nowPage=${p}&cntPerPage=${paging.cntPerPage}">${p}</a></c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${paging.endPage < paging.lastPage}"><a class="page-arrow" href="${pageContext.request.contextPath}/listup?nowPage=${paging.endPage + 1}&cntPerPage=${paging.cntPerPage}" aria-label="Next">&gt;</a></c:if>
            <c:if test="${paging.endPage >= paging.lastPage}"><span class="page-arrow page-disabled">&gt;</span></c:if>
        </div>
    </div>
 </div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	

    // --- ★★★ 플래시 메시지 1초 후 자동 숨김 처리 ★★★ ---
    // 성공 메시지 처리
    var $successMsg = $("#flashSuccessMessage");
    if ($successMsg.length > 0) { // 해당 ID를 가진 요소가 존재하면
        console.log("성공 메시지 발견, 1초 후 숨김 처리 시작.");
        setTimeout(function() {
            $successMsg.fadeOut(500); // 0.5초 동안 스르륵 사라짐 (fadeOut 속도 조절 가능)
            // $successMsg.slideUp(500); // 위로 스르륵 사라지게 하려면
            // $successMsg.hide(); // 즉시 숨기려면
        }, 1000); // 1000 밀리초 = 1초
    }

    // 오류 메시지 처리
    var $errorMsg = $("#flashErrorMessage");
    if ($errorMsg.length > 0) { // 해당 ID를 가진 요소가 존재하면
        console.log("오류 메시지 발견, 1초 후 숨김 처리 시작.");
        setTimeout(function() {
            $errorMsg.fadeOut(500);
            // $errorMsg.slideUp(500);
            // $errorMsg.hide();
        }, 1000); // 1000 밀리초 = 1초
    }
    // --- ★★★ 자동 숨김 처리 끝 ★★★ ---

}); // End document ready
</script>
        

   




</body>
</html>