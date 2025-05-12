package com.mbc.datecock.reply; // <<<--- 실제 댓글 관련 패키지 경로로 수정!

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller; // <<<--- @Controller 사용
import org.springframework.web.bind.annotation.PathVariable; // <<<--- @PathVariable import
import org.springframework.web.bind.annotation.RequestBody; // <<<--- @RequestBody import
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody; // <<<--- @ResponseBody import

@Controller // <<<--- @RestController 대신 @Controller 사용
@RequestMapping("/replies") // 댓글 관련 요청 기본 경로
public class ReplyController {

    private static final Logger log = LoggerFactory.getLogger(ReplyController.class);

    @Autowired
    private ReplyService replyService; // <<<--- ReplyService 구현체 주입 필요

    /**
     * 댓글 목록 조회 (GET /replies/{bno})
     * @param bno 게시글 번호
     * @return 댓글 목록 또는 오류 응답
     */
    @RequestMapping(value = "/{bno}", method = RequestMethod.GET) // <<<--- @GetMapping 대신 사용
    @ResponseBody // <<<--- JSON/데이터 직접 응답 위해 추가
    public ResponseEntity<List<ReplyDTO>> list(@PathVariable("bno") int bno) {
        log.info("댓글 목록 조회 요청: /replies/{}", bno);
        ResponseEntity<List<ReplyDTO>> entity = null;
        try {
            List<ReplyDTO> list = replyService.getCommentList(bno); // 서비스 호출
            entity = new ResponseEntity<>(list, HttpStatus.OK); // 성공 (200)
        } catch (Exception e) {
            log.error("댓글 목록 조회 오류: bno={}", bno, e);
            entity = new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // 실패 (500)
        }
        return entity;
    }

    /**
     * 새 댓글 등록 (POST /replies/new)
     * @param dto 댓글 내용 (JSON)
     * @param session 작성자 확인용
     * @return 처리 결과 (JSON)
     */
    @RequestMapping(value = "/new", method = RequestMethod.POST) // <<<--- @PostMapping 대신 사용
    @ResponseBody // <<<--- JSON/데이터 직접 응답 위해 추가
    public ResponseEntity<Map<String, Object>> create(@RequestBody ReplyDTO dto, HttpSession session) {
        log.info("새 댓글 등록 요청: {}", dto);
        Map<String, Object> response = new HashMap<>();
        ResponseEntity<Map<String, Object>> entity = null;
        try {
            String replyerId = (String) session.getAttribute("id");
            Boolean loginState = (Boolean) session.getAttribute("personalloginstate"); // 세션 키 확인!
            if (loginState == null || !loginState || replyerId == null) {
                response.put("success", false); response.put("message", "로그인 필요");
                return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED); // 401
            }
            dto.setReplyer(replyerId);

            if (dto.getReplytext() == null || dto.getReplytext().trim().isEmpty()) {
                 response.put("success", false); response.put("message", "댓글 내용 없음");
                 return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400
             }
             if (dto.getBno() <= 0) {
                  response.put("success", false); response.put("message", "게시글 번호 오류");
                  return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400
             }

            boolean success = replyService.addComment(dto); // 서비스 호출
            if (success) {
                response.put("success", true); response.put("message", "댓글 등록 성공");
                entity = new ResponseEntity<>(response, HttpStatus.OK); // 200
            } else {
                response.put("success", false); response.put("message", "댓글 등록 실패");
                entity = new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
            }
        } catch (Exception e) {
            log.error("댓글 등록 중 오류 발생: {}", dto, e);
            response.put("success", false); response.put("message", "댓글 등록 중 서버 오류");
            entity = new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
        return entity;
    }

    /**
     * 댓글 수정 (PUT /replies/{rno})
     * @param rno 댓글 번호
     * @param dto 수정 내용 (replytext)
     * @param session 사용자 확인용
     * @return 처리 결과 (JSON)
     */
    @RequestMapping(value = "/{rno}", method = RequestMethod.PUT) // <<<--- @PutMapping 대신 사용
    @ResponseBody // <<<--- JSON/데이터 직접 응답 위해 추가
    public ResponseEntity<Map<String, Object>> modify(
            @PathVariable("rno") int rno,
            @RequestBody ReplyDTO dto, // JSON으로 수정 내용 받음
            HttpSession session) {
    	
        log.info("{}번 댓글 수정 요청: {}", rno, dto.getReplytext());
        Map<String, Object> response = new HashMap<>();
        ResponseEntity<Map<String, Object>> entity = null;
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin"); // 관리자 여부 확인
        try {
             String currentUserId = (String) session.getAttribute("id");
             Boolean loginState = (Boolean) session.getAttribute("personalloginstate");
             if (loginState == null || !loginState || currentUserId == null) {
                 response.put("success", false); response.put("message", "로그인 필요");
                 return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED); // 401
             }
             
          // --- ★★★ 권한 확인 로직 추가 ★★★ ---
             boolean hasPermission = false;
             try {
                 ReplyDTO originalReply = replyService.getReply(rno); // 댓글 정보 가져오기
                 if (originalReply != null) {
                     if (currentUserId.equals(originalReply.getReplyer())) { // 작성자 확인
                         hasPermission = true;
                     } else if (isAdmin != null && isAdmin == true) { // 관리자 확인
                         hasPermission = true;
                         
                     }
                 } else {
                      response.put("success", false); response.put("message", "수정할 댓글이 존재하지 않습니다.");
                      return new ResponseEntity<>(response, HttpStatus.NOT_FOUND); // 404 Not Found
                 }
             } catch (Exception e) {
                  log.error("댓글 수정 권한 확인 중 오류 발생 (rno={})", rno, e);
                  response.put("success", false); response.put("message", "댓글 정보 확인 중 오류 발생");
                  return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
             }

             if (!hasPermission) {
                
                 response.put("success", false); response.put("message", "댓글 수정 권한이 없습니다.");
                 return new ResponseEntity<>(response, HttpStatus.FORBIDDEN); // 403 Forbidden
             }
             // --- ★★★ 권한 확인 로직 끝 ★★★ ---
             
             

             dto.setRno(rno); // 경로의 rno를 DTO에 설정
             // TODO: 서비스 계층에서 현재 사용자가 댓글 작성자인지 확인하는 로직 필요!
             boolean success = replyService.modifyComment(dto); // 예시: 서비스 메소드 (구현 필요)

             if (success) {
                 response.put("success", true); response.put("message", "댓글 수정 성공");
                 entity = new ResponseEntity<>(response, HttpStatus.OK); // 200
             } else {
                 response.put("success", false); response.put("message", "댓글 수정 실패 또는 권한 없음");
                 entity = new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400 또는 403
             }
        } catch (Exception e) {
            log.error("{}번 댓글 수정 중 오류", rno, e);
            response.put("success", false); response.put("message", "댓글 수정 중 서버 오류");
            entity = new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
        return entity;
    }

    /**
     * 댓글 삭제 (DELETE /replies/{rno})
     * @param rno 댓글 번호
     * @param session 사용자 확인용
     * @return 처리 결과 (JSON)
     */
    @RequestMapping(value = "/{rno}", method = RequestMethod.DELETE) // <<<--- @DeleteMapping 대신 사용
    @ResponseBody // <<<--- JSON/데이터 직접 응답 위해 추가
    public ResponseEntity<Map<String, Object>> remove(
            @PathVariable("rno") int rno,
            HttpSession session) {

        log.info("{}번 댓글 삭제 요청", rno);
        Map<String, Object> response = new HashMap<>();
        ResponseEntity<Map<String, Object>> entity = null;
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
         try {
            String currentUserId = (String) session.getAttribute("id");
            Boolean loginState = (Boolean) session.getAttribute("personalloginstate");
             if (loginState == null || !loginState || currentUserId == null) {
                 response.put("success", false); response.put("message", "로그인 필요");
                 return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED); // 401
             }
             
          // --- ★★★ 권한 확인 로직 추가 ★★★ ---
         boolean hasPermission = false;
         try {
             ReplyDTO originalReply = replyService.getReply(rno); // 댓글 정보 가져오기
             if (originalReply != null) {
                 if (currentUserId.equals(originalReply.getReplyer())) { // 작성자 확인
                     hasPermission = true;
                 } else if (isAdmin != null && isAdmin == true) { // 관리자 확인
                     hasPermission = true;
                     
                 }
             } else {
                  response.put("success", false); response.put("message", "삭제할 댓글이 존재하지 않습니다.");
                  return new ResponseEntity<>(response, HttpStatus.NOT_FOUND); // 404 Not Found
             }
         } catch (Exception e) {
              log.error("댓글 삭제 권한 확인 중 오류 발생 (rno={})", rno, e);
              response.put("success", false); response.put("message", "댓글 정보 확인 중 오류 발생");
              return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
         }

         if (!hasPermission) {
            
             response.put("success", false); response.put("message", "댓글 삭제 권한이 없습니다.");
             return new ResponseEntity<>(response, HttpStatus.FORBIDDEN); // 403 Forbidden
         }
        // --- ★★★ 권한 확인 로직 끝 ★★★ ---
             
             
            // TODO: 서비스 계층에서 현재 사용자가 댓글 작성자인지 확인 후 삭제 처리
            boolean success = replyService.removeComment(rno, currentUserId); // 예시: 서비스 메소드 (구현 필요)

            if (success) {
                response.put("success", true); response.put("message", "댓글 삭제 성공");
                return new ResponseEntity<>(response, HttpStatus.OK); // 200
            } else {
                 response.put("success", false); response.put("message", "댓글 삭제 실패 또는 권한 없음");
                 return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400 또는 403
            }
        } catch (Exception e) {
             log.error("{}번 댓글 삭제 중 오류", rno, e);
             response.put("success", false); response.put("message", "댓글 삭제 중 오류 발생");
             return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR); // 500
        }
    }

} // End of ReplyController class