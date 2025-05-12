package com.mbc.datecock.bizqna; // 패키지명 변경

import java.util.List;

import com.mbc.datecock.board.PageDTO; // 기존 PageDTO 사용
// import com.mbc.datecock.bizqna.BizQnaBoardDTO; // DTO 임포트

public interface BizQnaBoardService { // 인터페이스명 변경

    // 글 목록 (페이징)
    List<BizQnaBoardDTO> getBizQnaListPaged(PageDTO pageDTO) throws Exception; // 메소드명, 반환타입 변경

    // 전체 글 개수
    int getTotalBizQnaCount(PageDTO pageDTO) throws Exception; // 메소드명 변경

    // 글쓰기 (사업자만)
    boolean writeBizQna(BizQnaBoardDTO dto) throws Exception; // 메소드명, 파라미터 타입 변경

    // 상세보기 (조회수 증가 포함, 접근 권한 처리)
    // currentUserId는 여기서는 사업자번호 또는 관리자 ID가 될 수 있음
    BizQnaBoardDTO getBizQnaDetail(int bno, String currentUserId, boolean isAdmin) throws Exception; // 메소드명, 반환타입 변경

    // 글 수정 (작성자 사업자 또는 관리자만)
    boolean updateBizQna(BizQnaBoardDTO dto, String currentUserId, boolean isAdmin) throws Exception; // 메소드명, 파라미터 타입 변경

    // 글 삭제 (작성자 사업자 또는 관리자만)
    boolean deleteBizQna(int bno, String currentUserId, boolean isAdmin) throws Exception; // 메소드명 변경

    // 관리자 답변 등록/수정
    boolean saveAnswer(BizQnaBoardDTO dto, String adminId) throws Exception; // 파라미터 타입 변경

    // (내부용) 글 정보 가져오기 (수정/삭제 전 권한 확인용 - 조회수 증가 없음)
    BizQnaBoardDTO getBizQnaForAuth(int bno) throws Exception; // 메소드명, 반환타입 변경
}