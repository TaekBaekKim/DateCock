package com.mbc.datecock.board; // 패키지 경로 확인

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class PageDTO {
    // ... (기존 필드 선언: nowPage, cntPerPage, searchType, keyword 등) ...
     private int nowPage = 1;     // 기본값 1로 설정
     private int cntPerPage = 10; // 기본값 10으로 설정
     private int cntPage = 10;    // 한 화면에 표시할 페이지 그룹 수
     private int startPage, endPage, total, lastPage, start, end;
     private String searchType, keyword;
     private String loginUserId;
     private boolean admin;


    // --- Getter/Setter (필요한 것들 확인 및 추가) ---
    public int getNowPage() { return nowPage; }
    public void setNowPage(int nowPage) { this.nowPage = nowPage; }
    public int getCntPerPage() { return cntPerPage; }
    public void setCntPerPage(int cntPerPage) { this.cntPerPage = cntPerPage; }
    public int getCntPage() {return cntPage;}
    public void setCntPage(int cntPage) { this.cntPage = cntPage; }
    public String getSearchType() { return searchType; }
    public void setSearchType(String searchType) { this.searchType = searchType; }
    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }
    public int getTotal() { return total; }
    public void setTotal(int total) { this.total = total; }
    public int getStartPage() {return startPage;   }
	public void setStartPage(int startPage) {this.startPage = startPage;}
	public int getEndPage() {   return endPage;  }
	public void setEndPage(int endPage) { this.endPage = endPage;    }
	public int getLastPage() { return lastPage;   }
	public void setLastPage(int lastPage) { this.lastPage = lastPage; }
	public int getStart() {  return start; }
	public void setStart(int start) {  this.start = start;    }
	public int getEnd() {    return end;    }
	public void setEnd(int end) { this.end = end;    }
	public String getLoginUserId() { return loginUserId; }
    public void setLoginUserId(String loginUserId) { this.loginUserId = loginUserId; }
    public boolean isAdmin() { return admin; }
    public void setAdmin(boolean admin) { this.admin = admin; }



    // --- 페이징 계산 메소드들 ---
    public void calcLastPage(int total, int cntPerPage) {
        if (cntPerPage <= 0) cntPerPage = 10; // 0으로 나누는 것 방지
        setLastPage((int) Math.ceil((double)total / (double)cntPerPage));
    }
    public void calcStartEndPage(int nowPage, int cntPage) {
        if (cntPage <= 0) cntPage = 10; // 0으로 나누는 것 방지
        setEndPage(((int)Math.ceil((double)nowPage / (double)cntPage)) * cntPage);
        if (getLastPage() < getEndPage()) {
            setEndPage(getLastPage());
        }
        setStartPage(getEndPage() - cntPage + 1);
        if (getStartPage() < 1) {
            setStartPage(1);
        }
    }
    public void calcStartEnd(int nowPage, int cntPerPage) {
        if (cntPerPage <= 0) cntPerPage = 10;
        setEnd(nowPage * cntPerPage);
        setStart(getEnd() - cntPerPage + 1);
    }
    public void calculatePaging() {
         if (this.total <= 0) {
            this.nowPage = 1; this.startPage = 1; this.endPage = 0; this.lastPage = 0;
            this.start = 0; this.end = 0;
            return;
         }
         // nowPage나 cntPerPage가 0 이하일 경우 기본값 사용하도록 방어 코드 추가
         if (this.nowPage <= 0) this.nowPage = 1;
         if (this.cntPerPage <= 0) this.cntPerPage = 10;
         if (this.cntPage <= 0) this.cntPage = 10;

         calcLastPage(getTotal(), getCntPerPage());
         calcStartEndPage(getNowPage(), cntPage);
         calcStartEnd(getNowPage(), getCntPerPage());
     }


    // --- URL 쿼리 파라미터 생성 메소드 ---
    // ✅ 수정된 부분: '?' 대신 '&'로 시작하도록 변경
    public String makeQuery(int page) {
        StringBuilder query = new StringBuilder();

        // 첫 번째 파라미터는 '&'로 시작
        query.append("&nowPage=").append(page);
        query.append("&cntPerPage=").append(this.cntPerPage);

        // 검색 조건이 있으면 추가 (항상 '&'로 시작)
        if (this.searchType != null && !this.searchType.isEmpty() &&
            this.keyword != null && !this.keyword.isEmpty()) {
            try {
                query.append("&searchType=").append(this.searchType);
                // 키워드는 URL 인코딩 필수
                query.append("&keyword=").append(URLEncoder.encode(this.keyword, "UTF-8"));
            } catch (UnsupportedEncodingException e) {
                // UTF-8은 거의 모든 환경에서 지원되므로 실제 발생 가능성은 낮음
                e.printStackTrace(); // 또는 로깅 처리
                // 인코딩 실패 시 해당 파라미터는 제외될 수 있음
            }
        }
        // 필요하다면 다른 파라미터도 '&'로 시작하여 추가
        // 예: query.append("&sort=").append(this.sortOrder);

        return query.toString();
    }

    // (선택적) getQueryString 메소드도 makeQuery를 사용하도록 수정 가능
    public String getQueryString() {
        // ?로 시작해야 하므로, makeQuery 결과의 첫번째 &를 ?로 바꾸거나,
        // 아래처럼 직접 ?를 붙이고 makeQuery 결과 추가
        String params = makeQuery(this.nowPage);
        // makeQuery 결과가 비어있지 않다면 첫 '&'를 '?'로 변경
        if (params != null && params.startsWith("&")) {
            return "?" + params.substring(1);
        } else {
            // 파라미터가 아예 없거나 &로 시작하지 않는 예외적인 경우 (기본 페이지 정보만)
             return "?nowPage=" + this.nowPage + "&cntPerPage=" + this.cntPerPage;
        }
        // 또는 그냥 return makeQuery(this.nowPage); // 이렇게 하면 JSP에서 ?와 결합해야 함
    }
    @Override
    public String toString() {
        return "PageDTO [nowPage=" + nowPage + ", startPage=" + startPage + ", endPage=" + endPage + ", total=" + total
                + ", cntPerPage=" + cntPerPage + ", lastPage=" + lastPage + ", start=" + start + ", end=" + end
                + ", cntPage=" + cntPage + ", searchType=" + searchType + ", keyword=" + keyword
                + ", loginUserId=" + loginUserId + ", admin=" + admin + "]";
    }

}