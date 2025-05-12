package com.mbc.datecock.reply; // <<<--- 실제 패키지 경로로 수정!

import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // 트랜잭션 사용

import com.mbc.datecock.board.BoardService;

import org.apache.ibatis.session.SqlSession; // SqlSession 사용

// import com.mbc.datecock.board.BoardMapper; // 게시판 댓글 수 업데이트 시 필요

@Service // <<<--- 서비스 빈 등록!
public class ReplyServiceImpl implements ReplyService {
	@Autowired
	private BoardService boardService; 
    private static final Logger log = LoggerFactory.getLogger(ReplyServiceImpl.class);

    @Autowired
    private SqlSession sqlSession; // <<<--- SqlSession 주입!

    // ReplyMapper.xml의 namespace와 일치하는 고유한 값 (끝에 '.' 포함)
    private static final String NAMESPACE = "com.mbc.datecock.reply.mapper.ReplyMapper."; // <<<--- 실제 namespace 확인!

    // @Autowired
    // private BoardMapper boardMapper; // 게시판 댓글 수 업데이트 시 필요

    @Override
    public List<ReplyDTO> getCommentList(int bno) throws Exception {
        log.info("getCommentList({}) - 댓글 목록 조회", bno);
        // NAMESPACE + "listByBno" 로 XML의 select 호출
        return sqlSession.selectList(NAMESPACE + "listByBno", bno);
    }
    
    
    @Transactional // 댓글 등록 + (선택적) 게시글 댓글 수 업데이트를 묶음
    @Override
    public boolean addComment(ReplyDTO dto) throws Exception {
        log.info("addComment({}) - 새 댓글 등록", dto);
        // TODO: 필요시 XSS 방지 처리 로직 추가 (예: Lucy XSS Filter 등 사용)

        // NAMESPACE + "insert" 로 XML의 insert 호출
        

        // TODO: 게시판 테이블 댓글 수 업데이트 로직 (BoardMapper 필요)
        // if (insertCount == 1) {
        //     boardMapper.updateReplyCnt(dto.getBno(), 1); // 댓글 수 1 증가
        // }
        int insertCount = sqlSession.insert(NAMESPACE + "insert", dto);
        if (insertCount == 1) {
            try {
                // ★★★ boardService 호출 ★★★
                boardService.updateReplyCnt(dto.getBno(), 1); 
                log.info("{}번 게시글 댓글 수 1 증가 (via BoardService)", dto.getBno());
            } catch (Exception e) { /* 오류 처리 */ throw e; }
        }
        return insertCount == 1; 
        
        
        
        // 1개 행 삽입 시 성공
    }

    @Transactional // 댓글 내용 조회(작성자 확인) + 수정 필요시 트랜잭션
    @Override
    public boolean modifyComment(ReplyDTO dto) throws Exception {
        log.info("modifyComment({}) - 댓글 수정", dto);
        // TODO: XSS 방지 처리

        // TODO: 작성자 본인 확인 로직 구현 (필수!)
        // ReplyDTO originalReply = getComment(dto.getRno()); // 아래 getComment 메소드 사용
        // if (originalReply == null || !originalReply.getReplyer().equals(dto.getReplyer())) {
        //     log.warn("댓글 수정 권한 없음: rno={}, 요청자={}", dto.getRno(), dto.getReplyer());
        //     return false; // 권한 없거나 원본 글 없음
        // }

        // NAMESPACE + "update" 로 XML의 update 호출
        int updateCount = sqlSession.update(NAMESPACE + "update", dto);
        return updateCount == 1;
    }

    @Transactional // 댓글 내용 조회(작성자 확인) + 삭제 필요시 트랜잭션
    @Override
    public boolean removeComment(int rno, String userId) throws Exception {
        log.info("removeComment({}) - 댓글 삭제, 요청자: {}", rno, userId);

        // TODO: 작성자 본인 확인 로직 구현 (필수!)
        // ReplyDTO originalReply = getComment(rno);
        // if (originalReply == null || !originalReply.getReplyer().equals(userId)) {
        //     log.warn("댓글 삭제 권한 없음: rno={}, 요청자={}", rno, userId);
        //     return false; // 권한 없거나 원본 글 없음
        // }

        // NAMESPACE + "delete" 로 XML의 delete 호출
        
        // TODO: 게시판 테이블 댓글 수 업데이트 로직 (BoardMapper 필요)
        // if (deleteCount == 1) {
        //     boardMapper.updateReplyCnt(originalReply.getBno(), -1); // 댓글 수 1 감소
        // }
        ReplyDTO originalReply = getComment(rno); 
        if (originalReply == null) { return false; }
        // ... (작성자 확인) ...
        int deleteCount = sqlSession.delete(NAMESPACE + "delete", rno);
        if (deleteCount == 1) {
            try {
                // ★★★ boardService 호출 ★★★
                boardService.updateReplyCnt(originalReply.getBno(), -1);
                log.info("{}번 게시글 댓글 수 1 감소 (via BoardService, 댓글 {} 삭제)", originalReply.getBno(), rno);
            } catch (Exception e) { /* 오류 처리 */ throw e; }
        }
        
     
        return deleteCount == 1;
    }

    // (선택) 댓글 1개 조회 (수정/삭제 시 작성자 확인용)
    @Override
    public ReplyDTO getComment(int rno) throws Exception {
        log.info("getComment({}) - 댓글 단건 조회", rno);
        return sqlSession.selectOne(NAMESPACE + "read", rno); // XML에 id="read" 추가 필요
    }
    
    @Override
    public ReplyDTO getReply(int rno) throws Exception {
        log.info("getReply(rno={}) 호출", rno);
        return sqlSession.selectOne(NAMESPACE + "getReply", rno); // Mapper ID 예시
    }
    
    
}