package com.mbc.datecock.board;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface BoardService {

	boolean deleteBoard(int bno, String userId) throws Exception;

	boolean writeBoard(BoardDTO dto);

	BoardDTO getBoardDetail(int bno);

	void updateReplyCnt(int bno, int amount) throws Exception; 
	
	/**
     * 특정 게시글의 좋아요 수를 1 증가시킵니다.
     * @param bno 게시글 번호
     * @return 업데이트된 행의 수 (보통 1)
     */
    boolean increaseLikeCount(int bno) throws Exception ;
    
    /**
     * 특정 게시글의 현재 좋아요 수를 조회합니다.
     * @param bno 게시글 번호
     * @return 현재 좋아요 수 (Integer 타입 권장 - 결과 없을 때 null 반환 가능)
     */
    int getLikeCount(int bno) throws Exception;

	int getTotalBoardCount(PageDTO countCriteria) throws Exception;

	List<BoardDTO> getBoardListPaged(PageDTO pageDTO) throws Exception;
	
	/**
     * 게시글 수정
     * @param dto 수정할 내용이 담긴 DTO (bno 포함)
     * @param userId 수정 요청 사용자 ID (작성자 확인용)
     * @return 수정 성공 여부
     * @throws Exception
     */
	boolean updateBoard(BoardDTO dto, String userId) throws Exception;
}
