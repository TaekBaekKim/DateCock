package com.mbc.datecock.board;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.servlet.ServletContext;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

;

@Controller
public class BoardController {
	
	private static final Logger log = LoggerFactory.getLogger(BoardController.class);
	//이 어노테이션이 없으면 boardService 객체가 null 상태가 되어, boardList 나 boardView 메소드 안에서
	//boardService.getBoardList() 등을 호출할 때 NullPointerException이 발생합니다. 
	//(아마 목록 페이지 접근 시 이 오류를 보셨을 수도 있습니다.)
    @Autowired // <<<--- @Autowired 확인!
    private BoardService boardService;
    @Autowired
    private ServletContext servletContext;
    
    
 // LoginController 또는 다른 컨트롤러에 추가:
    @RequestMapping(value = "/loginmain", method = RequestMethod.GET)
    public String showMainPageAfterLogin() {
        return "main"; // 예: main.jsp 를 보여줌
    }
    /**
     * 게시글 목록 페이지 요청 처리
     */
    @RequestMapping(value = "/listup", method = RequestMethod.GET)
    public String boardList(
            // 1. @RequestParam으로 파라미터 명시적 수신 + 기본값 설정
            @RequestParam(value = "nowPage", required = false, defaultValue = "1") int nowPage,
            @RequestParam(value = "cntPerPage", required = false, defaultValue = "10") int cntPerPage,
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model) {

       

        // 2. (선택적이지만 안전) 추가 유효성 검사 및 기본값 강제
        if (nowPage <= 0) { nowPage = 1; }
        if (cntPerPage <= 0 || cntPerPage > 100) { cntPerPage = 10; } // 예: 최대 100개

        // 3. 검색 조건만 담은 임시 DTO 생성 (Count용)
        PageDTO countCriteria = new PageDTO();
        countCriteria.setSearchType(searchType);
        countCriteria.setKeyword(keyword);

        try {
            // 4. 검색 조건 적용된 전체 게시글 수 조회
            int totalCount = boardService.getTotalBoardCount(countCriteria);
            log.info("Total count with search criteria: {}", totalCount);

            // 5. ★★★ 유효한 값들로 최종 PageDTO 생성 및 페이징 계산 ★★★
            PageDTO paging = new PageDTO(); // View와 listPage 쿼리에 전달할 최종 객체
            paging.setSearchType(searchType); // 검색 조건 설정
            paging.setKeyword(keyword);    // 검색 조건 설정
            paging.setNowPage(nowPage);       // 검증된 현재 페이지 설정
            paging.setCntPerPage(cntPerPage); // 검증된 페이지당 글 수 설정
            paging.setTotal(totalCount);     // 전체 글 수 설정
            paging.calculatePaging();        // ★ 모든 값 설정 후 페이징 계산 명시적 호출 ★
            log.info("Final PageDTO for query and view: {}", paging);

            // 6. 페이징 및 검색 조건 적용하여 게시글 목록 조회
            List<BoardDTO> boardList = boardService.getBoardListPaged(paging);
            log.info("Fetched board list size: {}", (boardList != null ? boardList.size() : "null"));

            // 7. Model에 데이터 추가
            model.addAttribute("boardList", boardList);
            model.addAttribute("paging", paging); // 계산 완료된 PageDTO 전달
          // ★★★ 관리자 ID를 Model에 추가 ★★★
            model.addAttribute("adminUserId", "admin"); // 실제 관리자 ID로 변경!

        } catch (Exception e) {
            log.error("게시글 목록 조회(페이징+검색) 중 예외 발생", e);
            model.addAttribute("errorMessage", "목록 조회 중 오류 발생");
        }
        return "listup";
    }

    
 // --- ↓↓↓ 글쓰기 폼 보여주기 메소드 추가 ↓↓↓ ---
    /**
     * 게시글 작성 폼 페이지 요청을 처리합니다. (로그인 확인)
     * @param session 로그인 상태 확인 등을 위해 HttpSession 사용
     * @return 보여줄 View의 이름 ("write") 또는 로그인 페이지로 리다이렉트
     */
    @RequestMapping(value = "/write", method = RequestMethod.GET) // URL 경로 확인 (/board/write 등)
    public String boardWriteForm(HttpSession session) {
        log.info("'/write' (GET) 요청 수신 - 글쓰기 폼 페이지");

        // 로그인 상태 확인 ("personalloginstate" 키 사용)
        Boolean loginState = (Boolean) session.getAttribute("personalloginstate");
        if (loginState == null || !loginState) {
            log.warn("비로그인 사용자의 글쓰기 페이지 접근 시도. 로그인 페이지로 리다이렉트.");
            return "redirect:/memberinput"; // 로그인 페이지 경로
        }

        log.info("글쓰기 폼 페이지(write.jsp)로 이동합니다.");
        return "write"; // -> /WEB-INF/views/write.jsp (ViewResolver 설정 확인)
    }
    // --- ↑↑↑ 글쓰기 폼 보여주기 메소드 끝 ↑↑↑ ---


    // --- ↓↓↓ 글쓰기 처리 메소드 (AJAX 방식) 추가 ↓↓↓ ---
    /**
     * 게시글 작성 처리 (AJAX 방식)
     * @param dto 폼에서 전송된 데이터를 담은 BoardDTO 객체
     * @param session 작성자 정보 확인 등을 위해 HttpSession 사용
     * @return 처리 결과(성공 여부, 메시지)를 담은 Map 객체 (JSON으로 변환됨)
     */
    @RequestMapping(value = "/writeAction", method = RequestMethod.POST) // URL 경로 확인 (/board/writeAction 등)
    @ResponseBody // AJAX 응답용 어노테이션
    public Map<String, Object> boardWriteAction(BoardDTO dto, @RequestParam(value = "thumbnailFile", required = false) MultipartFile thumbnailFile,
    		HttpSession session){
        log.info("'/writeAction' (POST AJAX) 요청 수신 - 게시글 등록 처리");
        log.debug("전달받은 BoardDTO (작성자 설정 전): {}", dto);

        Map<String,Object> response = new HashMap<>(); // 응답용 Map

        // 로그인 확인 및 작성자 정보 설정 ("personalloginstate", "id" 키 사용)
        Boolean loginState = (Boolean) session.getAttribute("personalloginstate");
        String writerId = (String) session.getAttribute("id");

        if (loginState == null || !loginState || writerId == null || writerId.trim().isEmpty()) {
            log.warn("비로그인 또는 세션 ID 정보 없음. AJAX 실패 응답 반환.");
            response.put("success", false);
            response.put("message", "로그인이 필요하거나 세션 정보가 올바르지 않습니다.");
            return response;
        }

        // DTO에 작성자 ID 설정
        dto.setWriter(writerId);
        log.debug("작성자 정보 설정 완료: {}", dto.getWriter());
        
        // --- ↓↓↓ 파일 업로드 처리 로직 추가 ↓↓↓ ---
        String dbThumbnailPath = null; // DB 저장 경로 변수 초기화
        if (thumbnailFile != null && !thumbnailFile.isEmpty()) {
            log.debug("첨부된 썸네일 파일 처리 시작: {}", thumbnailFile.getOriginalFilename());
            try {
                // 1. 파일 저장 경로 설정 -> webapp 폴더 바로 아래 'image' 폴더의 실제 서버 경로
                String uploadDir = servletContext.getRealPath("/image/"); // <<<--- 저장 경로 변경 (/image/)
                log.info("파일 저장 절대 경로: {}", uploadDir);

                // 2. 업로드 폴더 생성 (없으면)
                // webapp 아래 폴더는 보통 미리 만들어두는 것이 좋습니다.
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    if(dir.mkdirs()) {
                        log.info("업로드 폴더 생성: {}", uploadDir);
                    } else {
                        log.error("업로드 폴더 생성 실패: {}", uploadDir);
                        // 폴더 생성 실패 시 오류 처리 필요
                        response.put("success", false);
                        response.put("message", "파일 저장 폴더 생성에 실패했습니다.");
                        return response;
                    }
                }

                // 3. 고유 파일명 생성 (UUID + 확장자)
                String originalFilename = thumbnailFile.getOriginalFilename();
                String extension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String savedFileName = UUID.randomUUID().toString() + extension;
                log.info("저장될 파일명: {}", savedFileName);

                // 4. 파일 저장 처리 (실제 서버 경로 사용)
                File saveFile = new File(uploadDir, savedFileName);
                thumbnailFile.transferTo(saveFile); // 서버 디스크에 파일 쓰기

                // 5. DB에 저장할 경로 설정 (웹 접근 가능 경로 - /image/ 로 시작)
                dbThumbnailPath = "/image/" + savedFileName; // <<<--- DB 저장 경로 변경 (/image/...)
                log.info("썸네일 파일 저장 성공. DB 저장 경로: {}", dbThumbnailPath);

            } catch (Exception e) {
                log.error("썸네일 파일 저장/처리 중 오류 발생", e);
                response.put("success", false);
                response.put("message", "파일 업로드 중 오류가 발생했습니다.");
                return response; // 오류 시 중단
            }
        } else {
             log.info("첨부된 썸네일 파일 없음.");
        }

        // 6. DTO에 최종 썸네일 경로 설정 (파일 없거나 오류 시 null)
        dto.setThumbnail(dbThumbnailPath);
        log.debug("DTO에 thumbnail 경로 설정: {}", dto.getThumbnail());
        // --- ↑↑↑ 파일 업로드 처리 로직 끝 ↑↑↑ ---
        try {
             if (boardService == null) {
                  log.error("boardService is null! Dependency Injection Check Needed.");
                  throw new IllegalStateException("서비스 오류 발생");
             }
            boolean success = boardService.writeBoard(dto); // BoardService에 writeBoard 메소드 필요

            if (success) {
                response.put("success", true);
                response.put("message", "게시글이 성공적으로 등록되었습니다.");
                log.info("게시글 등록 성공.");
            } else {
                response.put("success", false);
                response.put("message", "게시글 등록에 실패했습니다. 다시 시도해주세요.");
                log.warn("게시글 등록 실패 (Service 결과 false).");
            }
        } catch (Exception e) {
            log.error("게시글 등록 중 예외 발생", e);
            response.put("success", false);
            response.put("message", "게시글 등록 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
        return response; // 결과 Map 반환 (JSON으로 변환됨)
    }

    // --- 다른 메소드(글쓰기 폼/처리, 상세보기 등)는 나중에 추가 ---
 // --- ↓↓↓ 상세 보기 처리 메소드 ↓↓↓ ---
    /**
     * 특정 번호의 게시글 상세 보기 페이지 요청을 처리합니다.
     * @param bno URL의 쿼리 파라미터(?bno=값)로 전달된 게시글 번호
     * @param model View(JSP)에 데이터를 전달하기 위한 객체
     * @return 보여줄 View의 이름 ("board/view")
     */
    
    @RequestMapping(value="/view",method= RequestMethod.GET) // GET방식으로 board/view 요청
    public String boardView(@RequestParam("bno") int bno,Model mo,HttpSession session ) { //@RequestParam으로 bno 파라미터 받기
    
    	log.info("'/borad/view'(GET)요청 수신 - 게시글 번호:{}",bno);
    	
    	try {
    		//서비스 객체 null 체크(혹시 모를 주입 대비)
    		if(boardService == null) {
    			log.error("boardService is null! Dependency Injection Check Needed.");
    			mo.addAttribute("errorMessage", "게시판 서비스 로딩 오류");
    			//적절한 오류 페이지나 목록으로 리다이렉트 필요
    			return "redirect:/listup";
    		}
    		
    		// 1. 서비스 계층 호출 -> 상세 정보 가져오기
            //    BoardServiceImpl의 getBoardDetail 메소드에서 조회수 증가 및 정보 조회를 모두 처리한다고 가정
    		// ★★★ 중요: getBoardDetail은 이제 userId를 받지 않거나, 받아도 좋아요 상태 확인 로직 제외 ★★★
    		BoardDTO boardDTO = boardService.getBoardDetail(bno);
    		// 2. 조회 결과(BoardDTO 객체)를 Model에 추가 -> JSP에서 사용 가능
    		mo.addAttribute("boardDTO", boardDTO);
    		 if (boardDTO != null) {
    			 @SuppressWarnings("unchecked")
                 Set<Integer> likedPostsInSession = (Set<Integer>) session.getAttribute("likedPostsMap");
                 boolean userLikedInSession = (likedPostsInSession != null && likedPostsInSession.contains(bno));
                 mo.addAttribute("userLikedInSession", userLikedInSession); // 모델에 추가
                 // ★★★ 관리자 ID를 Model에 추가 ★★★
                 mo.addAttribute("adminUserId", "admin"); // 실제 관리자 ID로 변경!
                 log.info("{}번 게시글 조회 성공. 세션 좋아요 상태: {}", bno, userLikedInSession);
            } else {
                 // 조회된 게시글이 없는 경우 (잘못된 bno 등)
                 log.warn("{}번 게시글 정보가 존재하지 않습니다.", bno);
                 // JSP에서 ${empty boardDTO} 로 체크하여 메시지 표시
            }

        } catch (Exception e) {
            // 데이터 조회 중 예외 발생 시
            log.error("게시글 상세 조회 중 예외 발생 (bno: {})", bno, e);
            mo.addAttribute("errorMessage", "게시글을 불러오는 중 오류가 발생했습니다.");
            // 필요하다면 별도의 오류 페이지를 보여주거나 목록으로 리다이렉트
            // return "error";
        	}

	        // 3. 보여줄 JSP 파일의 논리적 이름 반환
	        // ViewResolver 설정에 따라 /WEB-INF/views/board/view.jsp 파일을 찾게 됨
	        return "view";
    	}
    // --- ↑↑↑ 상세 보기 처리 메소드 끝 ↑↑↑ ---
    	
    /**
     * 게시글 삭제 처리
     * @param bno 삭제할 게시글 번호
     * @param session 로그인 사용자 확인
     * @param rttr 리다이렉트 시 메시지 전달용
     * @return
     */
    // JavaScript에서 GET 방식으로 호출하므로 일단 GET으로 받음 (POST/DELETE 권장)
    @RequestMapping(value="/board/delete", method = RequestMethod.GET)
    public String deleteBoard(@RequestParam("bno") int bno, HttpSession session, RedirectAttributes rttr) {
        log.info("'/board/delete'(GET) 요청 수신 - 삭제할 게시글 번호: {}", bno);

        // 1. 로그인 상태 확인
        Boolean loginState = (Boolean) session.getAttribute("personalloginstate");
        String userId = (String) session.getAttribute("id");

        if (loginState == null || !loginState || userId == null) {
            log.warn("게시글 삭제 실패: 로그인이 필요합니다. (bno={})", bno);
            // 로그인 페이지로 보내거나 에러 메시지와 함께 목록으로 리다이렉트
            rttr.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/memberinput"; // 로그인 페이지 경로
        }
        
     // ★★★ 추가 코드 시작 (관리자 확인 및 권한 체크) ★★★
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        boolean hasPermission = false;
        BoardDTO boardToDelete = null; // 작성자 확인 위해 필요
        try {
             boardToDelete = boardService.getBoardDetail(bno); // 조회수 증가 없는 메소드 사용 권장
             if (boardToDelete != null) {
                 if (userId.equals(boardToDelete.getWriter()) || (isAdmin != null && isAdmin == true)) {
                     hasPermission = true;
                 }
             }
        } catch (Exception e) {
             log.error("삭제 권한 확인 중 게시글 조회 오류(bno={})", bno, e);
             rttr.addFlashAttribute("errorMessage", "게시글 정보 확인 중 오류 발생");
             return "redirect:/listup"; // 오류 시 목록으로
        }

        if (!hasPermission) {
            
             rttr.addFlashAttribute("errorMessage", "삭제 권한이 없습니다.");
             // 권한 없으면 상세 보기 페이지로 리다이렉트
             return "redirect:/view?bno=" + bno;
        }
        // ★★★ 추가 코드 끝 ★★★
        

        // 2. 서비스 호출하여 삭제 처리
        boolean deleteSuccess = false;
        try {
            // ★★★ Service의 deleteBoard 호출 ★★★
            deleteSuccess = boardService.deleteBoard(bno, userId);

            if (deleteSuccess) {
                log.info("게시글 {} 삭제 성공 (by {})", bno, userId);
                // 성공 메시지를 리다이렉트 후 페이지에 전달
                rttr.addFlashAttribute("message", "게시글이 성공적으로 삭제되었습니다.");
            } else {
                // 서비스에서 false를 반환한 경우 (권한 없거나 대상 없음 등)
                log.warn("게시글 {} 삭제 실패 (서비스 처리 결과 false)", bno);
                rttr.addFlashAttribute("errorMessage", "게시글을 삭제할 수 없거나 권한이 없습니다.");
                // 실패 시 상세 페이지로 다시 보내거나 목록으로 보낼 수 있음
                // return "redirect:/view?bno=" + bno;
            }
        } catch (Exception e) {
            log.error("게시글 {} 삭제 처리 중 예외 발생", bno, e);
            rttr.addFlashAttribute("errorMessage", "게시글 삭제 중 오류가 발생했습니다.");
            // 예외 발생 시에도 목록으로 이동
        }

        // 3. 처리 후 목록 페이지로 리다이렉트
        return "redirect:/listup"; // 삭제 후에는 목록 페이지로 이동
    }
    
    /**
     * 게시글 수정 폼 페이지 요청 처리
     * @param bno 수정할 게시글 번호
     * @param session 로그인 및 작성자 확인용
     * @param model View(JSP)에 게시글 데이터 전달용
     * @param rttr 권한 없을 시 메시지 전달용
     * @return 수정 폼 View 또는 리다이렉트 경로
     */
    @RequestMapping(value ="/edit",method = RequestMethod.GET) // GET 방식 /board/edit 요청 처리
    public String showEditForm(@RequestParam("bno") int bno, HttpSession session, Model model, RedirectAttributes rttr) {
        log.info("'/board/edit'(GET) 요청 수신 - 수정할 게시글 번호: {}", bno);

        // 1. 로그인 상태 확인
        Boolean loginState = (Boolean) session.getAttribute("personalloginstate");
        String userId = (String) session.getAttribute("id");

        if (loginState == null || !loginState || userId == null) {
            rttr.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/memberinput"; // 로그인 페이지로
        }
        
     // ★★★ 추가 코드 시작 (관리자 확인) ★★★
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        // ★★★ 추가 코드 끝 ★★★
        
        
        // 2. 게시글 정보 가져오기
        BoardDTO boardDTO = null;
        try {
            // ★★★ getBoardDetail은 조회수 증가 로직이 포함될 수 있으니,
            // ★★★ 수정 폼 로딩용으로 조회수 증가 없는 별도 메소드(예: getBoardForEdit)를 Service에 만드는 것이 더 좋습니다.
            // ★★★ 여기서는 일단 getBoardDetail을 사용한다고 가정합니다.
            boardDTO = boardService.getBoardDetail(bno); // userId 불필요

            if (boardDTO == null) {
                rttr.addFlashAttribute("errorMessage", "존재하지 않는 게시글입니다.");
                return "redirect:/listup"; // 목록으로
            }
         // ★★★ 추가 코드 시작 (권한 확인) ★★★ 작성자 본인과 관리자 권한을 한꺼번에 확인 userId.equals는 작성자 확인임
            boolean hasPermission = userId.equals(boardDTO.getWriter()) || (isAdmin != null && isAdmin == true);
            if (!hasPermission) {
                
                rttr.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
                return "redirect:/view?bno=" + bno;
            }
            
            
            
            

            // 4. Model에 게시글 정보 추가 -> JSP 폼에 값 채우기 위함
            model.addAttribute("boardDTO", boardDTO);
            log.info("게시글 {} 수정 폼으로 이동", bno);

            return "edit"; // -> /WEB-INF/views/board/edit.jsp 파일 필요

        } catch (Exception e) {
            log.error("게시글 수정 폼 로딩 중 오류 발생 (bno={})", bno, e);
            rttr.addFlashAttribute("errorMessage", "게시글 정보를 불러오는 중 오류 발생");
            return "redirect:/listup"; // 오류 시 목록으로
        }
    }
    
    
    /**
     * 게시글 수정 처리 (파일 처리 포함)
     * @param dto 수정된 내용이 담긴 DTO (bno, title, content 등)
     * @param thumbnailFile 새로 첨부된 썸네일 파일 (선택적)
     * @param existingThumbnail 기존 썸네일 파일 웹 경로 (파일 삭제 시 참고용, edit.jsp의 hidden input)
     * @param session 로그인 사용자 확인
     * @param rttr 리다이렉트 시 메시지 전달용
     * @return 리다이렉트 경로 (성공: 상세보기, 실패: 수정폼)
     */
    @RequestMapping(value="/board/editAction", method=RequestMethod.POST) // edit.jsp의 form action과 일치
    public String processEditForm(
            BoardDTO dto, // 폼 필드 자동 바인딩 (bno, title, content 등)
            @RequestParam(value = "thumbnailFile", required = false) MultipartFile thumbnailFile, // name="thumbnailFile"
            @RequestParam(value = "existingThumbnail", required = false) String existingThumbnail, // name="existingThumbnail"
            HttpSession session,
            RedirectAttributes rttr) {

        int bno = dto.getBno(); // dto에 bno가 바인딩되었는지 확인 필요
        log.info("'/board/editAction'(POST) 요청 수신 - 수정 대상 bno: {}", bno);

        // 1. 로그인 확인
        String userId = (String) session.getAttribute("id");
        if (userId == null || !(Boolean)session.getAttribute("personalloginstate")) {
            rttr.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/memberinput"; // 로그인 페이지 경로
        }

        // 2. 필수 값 확인
        if (dto.getTitle() == null || dto.getTitle().trim().isEmpty() ||
            dto.getContent() == null || dto.getContent().trim().isEmpty()) {
             rttr.addFlashAttribute("errorMessage", "제목과 내용은 필수 입력 항목입니다.");
             return "redirect:/edit?bno=" + bno; // 다시 수정 폼으로
        }
        // ★★★ 추가 코드 시작 (관리자 확인 및 권한 체크) ★★★
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        boolean hasPermission = false;
        BoardDTO originalBoard = null; // 원본 게시글 정보 저장용
        try {
            originalBoard = boardService.getBoardDetail(bno); // 원본 조회
            if (originalBoard == null) { /* 게시글 없음 */ return "redirect:/listup"; }
            if (userId.equals(originalBoard.getWriter()) || (isAdmin != null && isAdmin == true)) {
                hasPermission = true;
            }
        } catch (Exception e) {
            log.error("수정 권한 확인 중 게시글 조회 오류 (bno={})", bno, e);
            rttr.addFlashAttribute("errorMessage", "게시글 정보 확인 중 오류 발생");
            return "redirect:/edit?bno=" + bno; // 다시 수정폼으로
        }

        if (!hasPermission) {
            
            rttr.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
            return "redirect:/view?bno=" + bno;
        }
        // ★★★ 추가 코드 끝 ★★★
        
        
        
        String webPathForDb = null;    // DB에 최종 저장될 썸네일 웹 경로
        String oldFileWebPath = null;  // 삭제할 기존 파일 웹 경로

        try {
            // 3. 수정 권한 확인 (DB에서 원본 게시글 정보 가져와서 작성자 비교)
            //    조회수 증가 없는 메소드 사용 권장 (getBoardForEdit 등)
            originalBoard = boardService.getBoardDetail(bno); // 일단 getBoardDetail 사용

            if (originalBoard == null) {
                rttr.addFlashAttribute("errorMessage", "수정할 게시글이 존재하지 않습니다 (bno:" + bno + ").");
                return "redirect:/listup"; // 목록으로
            }
           
            oldFileWebPath = originalBoard.getThumbnail(); // 삭제할 수도 있는 기존 파일 경로 저장

            // 4. 새 썸네일 파일 처리
            boolean newFileUploaded = (thumbnailFile != null && !thumbnailFile.isEmpty());
            if (newFileUploaded) {
                log.info("새 썸네일 파일 감지됨. 처리 시작 (bno={}).", bno);
                // 파일 저장 디렉토리 (webapp/image/)
                String uploadDir = servletContext.getRealPath("/image/");
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) uploadDirFile.mkdirs();

                // 고유 파일명 생성
                String originalFilename = thumbnailFile.getOriginalFilename();
                String extension = "";
                if (originalFilename.contains(".")) {
                    extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String savedFileName = UUID.randomUUID().toString() + extension;
                File saveFile = new File(uploadDir, savedFileName);

                // 새 파일 저장
                thumbnailFile.transferTo(saveFile);
                webPathForDb = "/image/" + savedFileName; // DB에 저장될 새 경로
                log.info("새 썸네일 저장 완료: {}", webPathForDb);

                // dto에 새 경로 설정 (DB 업데이트 위함)
                dto.setThumbnail(webPathForDb);

            } else {
                // 새 파일이 없으면 기존 썸네일 유지
                // dto의 thumbnail 필드를 변경하지 않으면 Mapper의 <if>문에 의해 DB 업데이트 안됨
                log.info("새 썸네일 파일 없음. 기존 썸네일 유지 (bno={}).", bno);
                webPathForDb = oldFileWebPath; // DB 업데이트 후 파일 삭제 로직 위해 현재 경로 유지 (필수는 아님)
                // dto.setThumbnail(oldFileWebPath); // 이렇게 명시적으로 설정해도 Mapper의 <if>문에 의해 null이면 업데이트 안될 수 있음 (쿼리 확인 필요)
                                                    // Mapper의 <if test="thumbnail != null"> 조건이라면, DTO에 null이나 기존값을 넣어도 업데이트 안됨.
                                                    // 여기서는 DTO의 thumbnail은 그대로 두거나, 아래에서 null로 처리하여 Mapper <if> 활용
                 dto.setThumbnail(null); // Mapper의 <if test="thumbnail != null"> 를 활용하기 위해 null로 설정
            }

            // 5. 서비스 호출하여 DB 업데이트
            boolean updateSuccess = boardService.updateBoard(dto, userId);

            if (updateSuccess) {
                // 6. DB 업데이트 성공 시, (만약 새 파일이 업로드 되었다면) 기존 파일 삭제
                if (newFileUploaded && oldFileWebPath != null && !oldFileWebPath.isEmpty()) {
                     try {
                         String oldRealPath = servletContext.getRealPath(oldFileWebPath);
                         File oldFile = new File(oldRealPath);
                         if (oldFile.exists() && oldFile.isFile()) {
                             if (oldFile.delete()) {
                                 log.info("DB 업데이트 성공 후 기존 썸네일 파일 삭제 성공: {}", oldRealPath);
                             } else {
                                 log.warn("DB 업데이트 성공했으나 기존 썸네일 파일 삭제 실패: {}", oldRealPath);
                             }
                         }
                     } catch (Exception fileDeleteError) {
                         log.error("DB 업데이트 성공 후 기존 썸네일 파일 삭제 중 오류 (path={})", oldFileWebPath, fileDeleteError);
                     }
                 }

                rttr.addFlashAttribute("message", "게시글이 성공적으로 수정되었습니다.");
                return "redirect:/view?bno=" + bno; // 성공 시 상세 보기로
            } else {
                 // 서비스에서 false 반환 시 (권한 문제 등 Service 내부에서 처리된 경우)
                 rttr.addFlashAttribute("errorMessage", "게시글 수정에 실패했습니다.");
                 return "redirect:/edit?bno=" + bno; // 실패 시 다시 수정 폼으로
            }

        } catch (IOException e) { // 파일 저장(transferTo) 오류
            log.error("파일 저장 중 IOException 발생 (bno={})", bno, e);
            rttr.addFlashAttribute("errorMessage", "파일 저장 중 오류가 발생했습니다.");
            return "redirect:/edit?bno=" + bno;
        } catch (Exception e) { // 기타 모든 예외 (DB 오류, NullPointer 등)
            log.error("게시글 수정 처리 중 예외 발생 (bno={})", bno, e);
            rttr.addFlashAttribute("errorMessage", "게시글 수정 중 오류가 발생했습니다.");
            return "redirect:/edit?bno=" + bno; // 예외 시 다시 수정 폼으로
        }
    }

    
    
    
    /**
     * 게시글 좋아요 처리 (AJAX)
     * @param bno 좋아요할 게시글 번호
     * @param session 로그인 사용자 확인
     * @return 처리 결과 (성공 여부, 메시지, 현재 좋아요 수)
     */
    @RequestMapping(value = "/board/like", method = RequestMethod.POST) 
    @ResponseBody // 결과를 JSON으로 반환
    public Map<String, Object> boardLike(@RequestParam("bno") int bno, HttpSession session) {
        log.info("'/board/like' (POST AJAX) 요청 수신 - 게시글 번호: {}", bno);
        Map<String, Object> response = new HashMap<>();

        // 1. 로그인 상태 확인
        Boolean loginState = (Boolean) session.getAttribute("personalloginstate");
        String userId = (String) session.getAttribute("id"); // 좋아요 누른 사용자 ID (필요시 로깅/이력 관리용)

        if (loginState == null || !loginState || userId == null) {
            log.warn("좋아요 실패: 로그인이 필요합니다. (bno={})", bno);
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            response.put("likeCount", -1); // 오류 시 좋아요 수 -1 또는 이전 값
            return response;
        }

        log.info("좋아요 요청 사용자: {}", userId); // 누가 좋아요 눌렀는지 로그 기록

        try {
            // 2. 세션에서 '좋아요 누른 글 목록' 가져오기
            @SuppressWarnings("unchecked")
            Set<Integer> likedPostsInSession = (Set<Integer>) session.getAttribute("likedPostsMap");
            if (likedPostsInSession == null) {
                likedPostsInSession = new HashSet<>();
            }

            // 3. ★★★ 현재 세션에서 이미 좋아요를 눌렀는지 확인 ★★★
            if (likedPostsInSession.contains(bno)) {
                // 이미 현재 세션에서 좋아요를 눌렀으므로, DB 업데이트 없이 현재 상태만 반환
                log.info("사용자 {}가 게시글 {}을(를) 이미 현재 세션에서 좋아요 함 (DB 업데이트 없음).", userId, bno);
                response.put("success", true); // 작업은 성공 (상태 확인)
                response.put("message", "이미 '좋아요' 상태입니다. (세션)");
                response.put("action", "already_liked_in_session");
                // 현재 DB의 좋아요 수를 다시 조회해서 보내줌 (다른 사람이 눌렀을 수도 있으므로)
                response.put("likeCount", boardService.getLikeCount(bno));
            } else {
                // ★★★ 현재 세션에서 처음 좋아요 누름 -> DB 업데이트 + 세션 기록 ★★★
                log.info("사용자 {}가 게시글 {}에 대해 세션에서 처음 좋아요 누름. DB 업데이트 시도.", userId, bno);

                // 4. DB 업데이트 시도 (BoardService 호출)
                boolean dbUpdateSuccess = boardService.increaseLikeCount(bno);

                if (dbUpdateSuccess) {
                    // 5. DB 업데이트 성공 시, 세션에 기록
                    likedPostsInSession.add(bno);
                    session.setAttribute("likedPostsMap", likedPostsInSession);

                    // 6. 변경된 DB 좋아요 수 다시 조회
                    int currentLikeCount = boardService.getLikeCount(bno);

                    log.info("게시글 {} DB 좋아요 성공. 세션 기록 완료. 현재 좋아요 수: {}", bno, currentLikeCount);
                    response.put("success", true);
                    response.put("message", "'좋아요' 처리 완료!");
                    response.put("action", "liked_and_counted"); // DB 업데이트 및 세션 기록 완료 상태
                    response.put("likeCount", currentLikeCount); // 변경된 카운트 반환
                } else {
                    // DB 업데이트 실패 시 (없는 게시글 등)
                    log.warn("게시글 {} DB 좋아요 업데이트 실패 (service 결과 false).", bno);
                    response.put("success", false);
                    response.put("message", "'좋아요' 처리에 실패했습니다.");
                    response.put("action", "db_update_failed");
                    // 실패 시에도 현재 DB 카운트 조회 시도
                    response.put("likeCount", boardService.getLikeCount(bno));
                }
            }
        } catch (Exception e) {
            
            response.put("success", false);
            response.put("message", "오류가 발생했습니다. 다시 시도해주세요.");
            response.put("action", "error");
            // 오류 시 좋아요 수 -1 또는 조회 시도
             try { response.put("likeCount", boardService.getLikeCount(bno)); } catch (Exception ignored) { response.put("likeCount", -1); }
        }

        return response;
    }
    
    
    
    
    	
}
    
    

	 

