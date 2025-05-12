package com.mbc.datecock.userqna;

import java.util.List;
import com.mbc.datecock.board.PageDTO; // 기존 PageDTO 사용

public interface UserQnaBoardService {

    // 글 목록 (페이징)
    List<UserQnaBoardDTO> getUserQnaListPaged(PageDTO pageDTO) throws Exception;

    // 전체 글 개수
    int getTotalUserQnaCount(PageDTO pageDTO) throws Exception;

    // 글쓰기
    boolean writeUserQna(UserQnaBoardDTO dto) throws Exception;

    // 상세보기 (조회수 증가 포함, 접근 권한 처리)
    UserQnaBoardDTO getUserQnaDetail(int bno, String currentUserId, boolean isAdmin) throws Exception;

    // 글 수정 (작성자 또는 관리자만)
    boolean updateUserQna(UserQnaBoardDTO dto, String currentUserId, boolean isAdmin) throws Exception;

    // 글 삭제 (작성자 또는 관리자만)
    boolean deleteUserQna(int bno, String currentUserId, boolean isAdmin) throws Exception;

    // 관리자 답변 등록/수정
    boolean saveAnswer(UserQnaBoardDTO dto, String adminId) throws Exception;

    // (내부용) 글 정보 가져오기 (수정/삭제 전 권한 확인용 - 조회수 증가 없음)
    UserQnaBoardDTO getUserQnaForAuth(int bno) throws Exception;
}