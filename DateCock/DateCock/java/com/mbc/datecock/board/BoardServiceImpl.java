package com.mbc.datecock.board; // <<<--- 실제 패키지 경로로 수정!

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
 // <<<--- 이 import 문 확인 및 추가!
import com.mbc.datecock.board.BoardDTO;    // <<<--- BoardDTO import 도 확인!

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContext;

import java.io.File;
import java.nio.file.AccessDeniedException;
import java.util.Date;
import java.util.HashMap;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service // <<<--- @Service 어노테이션 확인!
public class BoardServiceImpl implements BoardService {

	private static final Logger log = LoggerFactory.getLogger(BoardServiceImpl.class);
	
	
	
	// 파일 업로드 경로 등을 위해 ServletContext 주입 (Controller에서 이미 주입받고 있음)
    // Service에서 ServletContext를 직접 사용하는 것이 항상 좋은 구조는 아니지만,
    // 파일 경로를 얻기 위해 Controller에서 경로를 받아오거나 다른 방식을 사용할 수도 있습니다.
    // 여기서는 간단히 Service에서도 주입받는 것으로 가정합니다.
    @Autowired
    private ServletContext servletContext;
	
	
	
    // SqlSession 직접 주입 방식
    @Autowired // <<<--- @Autowired 확인!
    private SqlSession sqlSession;

    // 사용할 namespace (Board.xml의 namespace와 일치시켜야 함)
    // 이 경로는 BoardMapper 인터페이스가 없어도 XML 내 SQL을 찾기 위해 필요합니다.
    private static final String NAMESPACE = "com.mbc.datecock.board.mapper.BoardMapper."; // <<<--- 실제 Board.xml의 namespace 확인!
    
    
    @Override
    public List<BoardDTO> getBoardListPaged(PageDTO pageDTO) throws Exception {
        log.info("getBoardListPaged({}) - 서비스 호출됨", pageDTO);
        List<BoardDTO> list = null;
        try {
            // Mapper의 listPage 쿼리 호출 (파라미터로 PageDTO 전달)
            list = sqlSession.selectList(NAMESPACE + "listPage", pageDTO);

            // --- 목록 데이터 가공 로직 ---
            if (list != null && !list.isEmpty()) {
                for (BoardDTO dto : list) {
                    if (dto != null) {
                        dto.setRelativeTime(formatRelativeTime(dto.getRegdate()));
                        dto.setSnippet(generateSnippet(dto.getContent()));
                        // 썸네일 경로 등 추가 가공...
                         if(dto.getThumbnail() != null && !dto.getThumbnail().isEmpty() && !dto.getThumbnail().startsWith("/")) {
                              dto.setThumbnail("/upload/" + dto.getThumbnail()); // 실제 경로 기준으로 수정 (이 부분은 원래 코드에 있었음)
                         }
                    }
                }
                
            } else {
                log.info("해당 페이지({})에 조회된 게시글 없음.", pageDTO.getNowPage());
            }
            // --- 가공 로직 끝 ---
        } catch (Exception e) {
            log.error("getBoardListPaged() - 게시글 목록 조회 중 오류 발생", e);
            throw e;
        }
        return list;
    }

    /**
     * 전체 게시글 수 조회
     */
    @Override
    public int getTotalBoardCount(PageDTO pageDTO) throws Exception { // ★★★ PageDTO 파라미터 받음 ★★★
        log.info("getTotalBoardCount({}) - 서비스 호출됨", pageDTO);
        int totalCount = 0;
        try {
            // Mapper 호출 시 PageDTO 전달 (검색 조건 포함)
            totalCount = sqlSession.selectOne(NAMESPACE + "getTotalBoardCount", pageDTO);
            log.info("검색 조건 적용된 전체 게시글 수: {}", totalCount);
        } catch (Exception e) {
             log.error("getTotalBoardCount() - 전체 게시글 수 조회 중 오류 발생", e);
             throw e;
        }
        return totalCount;
    }

    // --- Helper 메소드 (getBoardList에서 사용하므로 포함) ---

    /**
     * Date 객체를 상대 시간 문자열("X분 전" 등)로 변환합니다.
     */
    private String formatRelativeTime(Date past) {
        if (past == null) return "";
        long now = System.currentTimeMillis();
        long diff = now - past.getTime();
        long minutes = TimeUnit.MILLISECONDS.toMinutes(diff);
        long hours = TimeUnit.MILLISECONDS.toHours(diff);
        long days = TimeUnit.MILLISECONDS.toDays(diff);

        if (minutes < 1) return "방금 전";
        else if (minutes < 60) return minutes + "분 전";
        else if (hours < 24) return hours + "시간 전";
        else if (days < 7) return days + "일 전";
        else {
             java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy.MM.dd");
             return sdf.format(past);
        }
    }

    /**
     * HTML 태그를 제거하고 최대 길이로 잘라 내용 요약을 생성합니다.
     */
    private String generateSnippet(String content) {
         if (content == null) return "";
         String textOnly = content.replaceAll("<[^>]*>", "");
         int maxLength = 100; // 요약 글자 수
         if (textOnly.length() > maxLength) {
             return textOnly.substring(0, maxLength) + "...";
         } else {
             return textOnly;
         }
    }
    

    // --- ↓↓↓ 글쓰기 메소드 구현 추가 ↓↓↓ ---
    /**
     * 새로운 게시글을 등록합니다.
     * @param dto 등록할 게시글 정보를 담은 DTO
     * @return 등록 성공 시 true, 실패 시 false
     */
    @Override
    public boolean writeBoard(BoardDTO dto) {
        log.info("writeBoard() - 서비스 호출됨 (SqlSession 사용). 작성자: {}", dto.getWriter());
         // 기본 유효성 검사 (Controller에서도 하지만 Service에서도 하는 것이 안전)
         if (dto == null || dto.getTitle() == null || dto.getTitle().trim().isEmpty() ||
            dto.getContent() == null || dto.getContent().trim().isEmpty() ||
            dto.getWriter() == null || dto.getWriter().trim().isEmpty()) {
            log.warn("writeBoard() - 게시글 등록 실패: 필수 정보 누락");
            return false;
         }

         int result = 0;
         try {
             // MyBatis insert 호출 (BoardMapper.xml 에 id="insertBoard" 필요)
             result = sqlSession.insert(NAMESPACE + "insertBoard", dto);
             log.debug("게시글 DB 삽입 결과 (영향 받은 행 수): {}", result);
         } catch (Exception e) {
             log.error("writeBoard() - 게시글 DB 삽입 중 오류 발생", e);
             return false; // 예외 발생 시 실패
         }
         return result == 1; // 삽입된 행이 1개면 성공
    }
    
    // --- ↓↓↓ 상세 보기 메소드 구현 추가 ↓↓↓ ---
    /**
     * 특정 게시글의 상세 정보를 조회하고 조회수를 1 증가시킵니다.
     * @param bno 조회할 게시글 번호
     * @return 조회된 게시글 DTO (없으면 null)
     */
    @Transactional // <<<--- 조회수 증가와 SELECT를 한 트랜잭션으로 묶음
    @Override
    public BoardDTO getBoardDetail(int bno) {
    	log.info("getBoardDetail({}) - 서비스 호출됨",bno);
    	BoardDTO dto = null;
    	
    	try {
    		//1.조회수 증가 update 실행
    		int updatecnt = sqlSession.update(NAMESPACE+"increaseViewCnt",bno);
    		if(updatecnt >0) {
    			log.debug("{}번 게시글 조회수 증가 성공.",bno);
    		}
    		else {
    			log.debug("{}번 게시글 조회수 증가 대상 없음 (updatecnt=0).",bno);
    		}
    		
    		//2.게시글 상세 정보 select 실행
    		dto = sqlSession.selectOne(NAMESPACE+"getDetail",bno);
    		
    		//3.조회 결과 가공(필요시 추가)
    	}
    	 catch (Exception e) {
             log.error("getBoardDetail({}) - 처리 중 오류 발생", bno, e);
             // 필요시 예외를 다시 던지거나 null 반환
             // throw new RuntimeException("게시글 상세 조회 오류", e);
             return null;
         }
    	
    	 return dto; // 조회된 DTO 또는 null 반환
    	
    }
    // --- ↓↓↓ 댓글 수 업데이트 메소드 구현 추가 ↓↓↓ ---
    /**
     * 게시글의 댓글 수를 변경한다. (ReplyService에서 호출됨)
     * @param bno 게시글 번호
     * @param amount 변경량 (댓글 추가: 1, 댓글 삭제: -1)
     * @throws Exception
     */
    @Override 
    public void updateReplyCnt(int bno, int amount) throws Exception {
        log.info("게시글({}) 댓글 수 변경 요청: {}", bno, amount);
        try {
            // sqlSession으로 update 실행 시 파라미터는 하나만 넘길 수 있으므로 Map 사용
            Map<String, Object> params = new HashMap<>();
            params.put("bno", bno);
            params.put("amount", amount);

            // NAMESPACE + id 로 XML의 쿼리 실행
            int updateResult = sqlSession.update(NAMESPACE + "updateReplyCnt", params); 

            if (updateResult > 0) {
                
            } else {
                 log.warn("게시글({}) 댓글 수 변경 대상이 없거나 실패했습니다.", bno);
            }
        } catch (Exception e) {
            log.error("게시글({}) 댓글 수 변경 중 DB 오류 발생", bno, e);
            throw e; // 오류 발생 시 예외 다시 던지기
        }
    }
    // --- ↑↑↑ 댓글 수 업데이트 메소드 구현 추가 끝 ↑↑↑ ---
    
    @Override
    public boolean increaseLikeCount(int bno) throws Exception {
    	 log.info("increaseLikeCount(bno={}) 호출 - SqlSession 직접 사용", bno);
    	if(sqlSession == null) {
    		 log.info("increaseLikeCount(bno={}) 호출 - SqlSession 직접 사용", bno);
    		throw new IllegalStateException("객체가 주입되지않았습니다.");
    	}
    	
    	// sqlSession.update(네임스페이스 + SQL_ID, 파라미터)
    	int updatedRows = sqlSession.update(NAMESPACE+"increaseLikeCnt",bno);
    	log.info("게시글 {} 좋아요 수 업데이트 결과: {} 행 업데이트됨", bno, updatedRows);
    	return updatedRows == 1; //1개 행이 업데이트 되었으면 성공 boolean 형으로 반환 성공
    }
    
    @Override
    public int getLikeCount(int bno) throws Exception { // throws Exception 추가 고려 (selectOne 오류 가능성)
        log.info("getLikeCount(bno={}) 호출 - SqlSession 직접 사용", bno);
        if (sqlSession == null) {
            throw new IllegalStateException("객체가 주입되지 않았습니다.");
        }

        Integer likeCount = null; // 결과를 Integer로 받는 것이 좋습니다 (결과 없을 때 null)
        try {
            // --- !!! 수정된 부분 !!! ---
            // sqlSession.selectOne()을 사용하여 좋아요 수를 조회합니다.
            // XML 매퍼에는 id="getLikeCnt" 인 <select> 쿼리가 있어야 합니다.
            likeCount = sqlSession.selectOne(NAMESPACE + "getLikeCnt", bno); // <--- selectOne() 사용!
            // --- !!! 수정 끝 ---

            log.info("게시글 {} 현재 좋아요 수 조회 결과: {}", bno, likeCount);

        } catch (Exception e) {
            log.error("getLikeCount({}) - 좋아요 수 조회 중 오류 발생", bno, e);
            throw e; // 또는 -1 반환 등 오류 처리 정책에 맞게
        }

        // 조회 결과가 null이면 0 또는 -1 등 기본값 처리
        return (likeCount != null) ? likeCount : 0; // null이면 0으로 반환 (또는 -1)
    }
    
    @Transactional // DB 삭제와 파일 삭제를 묶어서 처리 (하나라도 실패하면 롤백되도록)
    @Override
    public boolean deleteBoard(int bno, String userId) throws Exception {
        log.info("deleteBoard(bno={}, userId={}) - 서비스 호출됨", bno, userId);

        // 1. (선택적이지만 안전) 서비스에서도 작성자 확인 - Controller에서 이미 했더라도 이중 체크
        BoardDTO boardToDelete = sqlSession.selectOne(NAMESPACE + "getDetail", bno);

        if (boardToDelete == null) {
            log.warn("삭제할 게시글 없음 (bno={})", bno);
            return false; // 삭제할 게시글 없음
        }
       

        // 2. DB에서 게시글 삭제 시도
        int deleteDbResult = 0;
        String thumbnailPathToDelete = boardToDelete.getThumbnail(); // 파일 삭제 위해 경로 저장

        try {
            deleteDbResult = sqlSession.delete(NAMESPACE + "deleteBoard", bno);
            log.info("게시글 {} DB 삭제 결과: {} 행 삭제됨", bno, deleteDbResult);
        } catch (Exception e) {
            log.error("게시글 {} DB 삭제 중 오류 발생", bno, e);
            throw e; // DB 오류 시 롤백되도록 예외 다시 던지기
        }

        // 3. DB 삭제 성공 시, 첨부파일(썸네일) 삭제 시도
        if (deleteDbResult == 1) {
            if (thumbnailPathToDelete != null && !thumbnailPathToDelete.isEmpty()) {
                try {
                    // 웹 경로(/image/...) 를 실제 서버 경로로 변환
                    String realPath = servletContext.getRealPath(thumbnailPathToDelete);
                    File fileToDelete = new File(realPath);

                    if (fileToDelete.exists()) {
                        if (fileToDelete.delete()) {
                            log.info("썸네일 파일 삭제 성공: {}", realPath);
                        } else {
                            log.warn("썸네일 파일 삭제 실패 (파일 접근 불가 등): {}", realPath);
                            // 파일 삭제 실패 시 정책 결정 필요 (DB 롤백? 경고만? - 여기선 경고만)
                        }
                    } else {
                        log.warn("삭제할 썸네일 파일이 실제 경로에 없음: {}", realPath);
                    }
                } catch (Exception e) {
                    log.error("썸네일 파일 삭제 중 예외 발생 (path={})", thumbnailPathToDelete, e);
                    // 파일 처리 예외 시 정책 결정 필요
                }
            }
            return true; // DB 삭제 성공
        } else {
            log.warn("게시글 {} DB 삭제 실패 (영향 받은 행 없음)", bno);
            return false; // DB 삭제 실패
        }
    }
    
    /**
     * 게시글 수정 처리 (DB 업데이트 + 필요시 썸네일 파일 교체)
     */
    @Transactional // DB 업데이트, 파일 삭제/저장 등을 묶어서 처리
    @Override
    public boolean updateBoard(BoardDTO dto, String userId) throws Exception {
       

        // 2. ★★★ 썸네일 파일 처리 로직은 writeBoard 와 유사하게 필요 ★★★
        //    (새 파일 저장, 기존 파일 삭제 등 - writeBoard 메소드 참고하여 구현)
        //    만약 새 파일이 업로드 되었다면 dto.setThumbnail(새 웹 경로) 설정
        //    새 파일 없고 기존 파일 유지 시 dto.setThumbnail(null) 또는 기존 값 유지 (update 쿼리의 if문 활용)
        //    --> 파일 처리 로직은 복잡하므로 writeBoard의 로직을 참고하여 별도 구현 필요!
        //    --> 여기서는 DB 업데이트만 우선 구현합니다. (파일 로직은 나중에 추가)

        // 3. DB 업데이트 시도
        int updateResult = 0;
        try {
             // DTO에 writer 필드가 있다면, 여기서 강제로 원본 작성자로 덮어쓰는 것이 안전
             // dto.setWriter(originalBoard.getWriter());

             // 제목, 내용, (처리된)썸네일 경로 업데이트
             updateResult = sqlSession.update(NAMESPACE + "updateBoard", dto); // XML ID 확인!
             log.info("게시글 {} DB 업데이트 결과: {} 행 업데이트됨", dto.getBno(), updateResult);
        } catch (Exception e) {
            log.error("게시글 {} DB 업데이트 중 오류 발생", dto.getBno(), e);
            throw e; // 롤백되도록 예외 던지기
        }

        return updateResult == 1;
    }
    
    
    

}