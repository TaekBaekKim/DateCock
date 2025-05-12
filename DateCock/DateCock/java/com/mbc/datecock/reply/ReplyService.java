package com.mbc.datecock.reply; // <<<--- 실제 패키지 경로로 수정!

import java.util.List;

public interface ReplyService {

    /** 특정 게시글의 댓글 목록 조회 */
    public List<ReplyDTO> getCommentList(int bno) throws Exception;

    /** 새 댓글 등록 */
    public boolean addComment(ReplyDTO dto) throws Exception;

    /** 댓글 수정 (작성자 확인 로직은 Impl에서) */
    public boolean modifyComment(ReplyDTO dto) throws Exception;

    /** 댓글 삭제 (작성자 확인 로직은 Impl에서) */
    public boolean removeComment(int rno, String userId) throws Exception;

    /** (선택) 댓글 1개 정보 조회 */
    public ReplyDTO getComment(int rno) throws Exception;
    // ★★★ 댓글 단건 조회 메소드 추가 ★★★
    ReplyDTO getReply(int rno) throws Exception;
}