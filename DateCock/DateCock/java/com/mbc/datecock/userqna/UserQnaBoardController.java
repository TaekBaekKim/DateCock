package com.mbc.datecock.userqna;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mbc.datecock.board.PageDTO;

@Controller
// @RequestMapping("/userqna") // 클래스 레벨에 공통 경로 추가 권장
public class UserQnaBoardController {

    private static final Logger log = LoggerFactory.getLogger(UserQnaBoardController.class);

    @Autowired
    private UserQnaBoardService userQnaService;

    @Autowired
    private ServletContext servletContext;

    private static final String IMAGE_UPLOAD_PATH = "/image"; // UserQna 이미지 업로드 경로

    // 접근 권한 확인 (일반 사용자 또는 관리자)
    private boolean canAccess(HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) return true; // 관리자는 항상 접근 가능
        // 일반 사용자의 경우, 'personal' 타입이고 ID가 있어야 함
        String userType = (String) session.getAttribute("userType");
        return "personal".equals(userType) && session.getAttribute("id") != null;
    }

    // 목록
    @RequestMapping(value = "/uqlist", method = RequestMethod.GET)
    public String list(PageDTO pageDTO, Model model, HttpSession session, HttpServletResponse response) throws Exception {
        // 관리자가 아니고, 일반 사용자 접근 조건도 만족하지 못하면 접근 불가
        if (!Boolean.TRUE.equals(session.getAttribute("isAdmin")) && !canAccess(session)) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            // 사용자를 메인 페이지 또는 로그인 페이지로 리디렉션
            out.println("<script>alert('문의게시판 접근 권한이 없습니다.'); location.href='../main';</script>");
            out.flush();
            return null;
        }

        pageDTO.setLoginUserId((String) session.getAttribute("id"));
        pageDTO.setAdmin(Boolean.TRUE.equals(session.getAttribute("isAdmin")));

        int totalCount = userQnaService.getTotalUserQnaCount(pageDTO);
        pageDTO.setTotal(totalCount);
        if (pageDTO.getTotal() > 0) {
             pageDTO.calculatePaging();
        } else {
            // 게시글이 없을 경우 페이징 계산이 의미 없으므로, 기본값으로 설정하거나 비워둠
             log.info("총 게시글 수가 0이므로 페이징 계산을 건너뜁니다.");
        }


        List<UserQnaBoardDTO> list = userQnaService.getUserQnaListPaged(pageDTO);
        model.addAttribute("list", list);
        model.addAttribute("paging", pageDTO);
        model.addAttribute("currentLoginUserId", session.getAttribute("id"));
        model.addAttribute("isUserAdmin", Boolean.TRUE.equals(session.getAttribute("isAdmin")));
        return "uqlist";
    }

    // 글쓰기 폼
    @RequestMapping(value = "/uqwrite", method = RequestMethod.GET)
    public String writeForm(HttpSession session, HttpServletResponse response, Model model) throws IOException {
        // 일반 사용자 'personal' 타입만 글쓰기 가능
        if (session.getAttribute("id") == null || !"personal".equals(session.getAttribute("userType"))) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('일반 사용자만 문의글을 작성할 수 있습니다.'); location.href='../DateCocklog';</script>");
            out.flush();
            return null;
        }
        model.addAttribute("userQnaBoardDTO", new UserQnaBoardDTO()); // EL에서 사용하기 위해 빈 DTO 전달
        return "uqwrite";
    }

    // 글쓰기 처리
    @RequestMapping(value = "/uqwriteAction", method = RequestMethod.POST)
    public String writeAction(UserQnaBoardDTO dto, HttpSession session, RedirectAttributes rttr, HttpServletResponse response) throws Exception {
        String userId = (String) session.getAttribute("id");
        if (userId == null || !"personal".equals(session.getAttribute("userType"))) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('로그인이 필요하거나 권한이 없습니다.'); location.href='../DateCocklog';</script>");
            out.flush();
            return null;
        }
        dto.setWriter(userId);
        // secret 값은 JSP 폼에서 checkbox 등을 통해 0 또는 1로 UserQnaBoardDTO에 바인딩되어야 함
        // 예: <input type="checkbox" name="secret" value="1"> (체크하면 1, 안하면 0 또는 null - 컨트롤러에서 null 처리 필요)
        //    또는 <select name="secret"><option value="0">공개</option><option value="1">비밀</option></select>

        MultipartFile uploadFile = dto.getQnaImageFile();
        String uploadedFileName = null;
        if (uploadFile != null && !uploadFile.isEmpty()) {
            String originalFileName = uploadFile.getOriginalFilename();
            String uploadDir = servletContext.getRealPath(IMAGE_UPLOAD_PATH); // UserQna 이미지 업로드 실제 경로
            File saveDir = new File(uploadDir);
            if (!saveDir.exists()) {
                if(saveDir.mkdirs()) {
                    log.info("UserQnA 업로드 폴더 생성 성공: {}", uploadDir);
                } else {
                     log.error("UserQnA 업로드 폴더 생성 실패: {}", uploadDir);
                     rttr.addFlashAttribute("errorMessage", "파일 저장 폴더 생성에 실패했습니다.");
                     rttr.addFlashAttribute("userQnaBoardDTO", dto); // 입력값 유지를 위해 DTO 다시 전달
                     return "redirect:/uqwrite";
                }
            }

            String fileExtension = "";
            if (originalFileName.contains(".")) {
                fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            }
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            File saveFile = new File(uploadDir, uniqueFileName);

            try {
                uploadFile.transferTo(saveFile);
                uploadedFileName = uniqueFileName; 
                log.info("UserQnA 파일 업로드 성공: " + saveFile.getAbsolutePath());
            } catch (IOException e) {
                log.error("UserQnA 파일 업로드 실패: ", e);
                rttr.addFlashAttribute("errorMessage", "파일 업로드 중 오류가 발생했습니다.");
                rttr.addFlashAttribute("userQnaBoardDTO", dto);
                return "redirect:/uqwrite";
            }
        }
        dto.setImageFile(uploadedFileName); // DB에 저장될 파일명 (없으면 null)

        boolean writeSuccess = false;
        try {
             writeSuccess = userQnaService.writeUserQna(dto);
        } catch (Exception e) {
             log.error("UserQnA DB 저장 중 오류 발생", e);
             // writeSuccess는 이미 false
        }


        if (writeSuccess) {
            rttr.addFlashAttribute("message", "문의글이 등록되었습니다.");
        } else {
            rttr.addFlashAttribute("errorMessage", "문의글 등록에 실패했습니다. 입력 내용을 확인해주세요.");
            rttr.addFlashAttribute("userQnaBoardDTO", dto); // 실패 시 입력값 유지를 위해 DTO 전달
            if (uploadedFileName != null) { // 파일 업로드는 성공했으나 DB 저장이 실패한 경우, 업로드된 파일 삭제
                 try {
                    new File(servletContext.getRealPath(IMAGE_UPLOAD_PATH + File.separator + uploadedFileName)).delete();
                    log.info("DB 저장 실패로 인한 업로드 파일 삭제: {}", uploadedFileName);
                 } catch(Exception e) {
                    log.error("DB 저장 실패 후 업로드 파일 삭제 중 오류", e);
                 }
            }
            return "redirect:/uqwrite"; // 글쓰기 폼으로 다시 이동
        }
        return "redirect:/uqlist"; // 성공 시 목록으로
    }

    // 상세보기
    @RequestMapping(value = "/uqview", method = RequestMethod.GET)
    public String view(@RequestParam("bno") int bno, PageDTO pageDTO, Model model, HttpSession session, RedirectAttributes rttr, HttpServletResponse response) throws Exception {
        String currentUserId = (String) session.getAttribute("id");
        boolean isAdmin = Boolean.TRUE.equals(session.getAttribute("isAdmin"));

        UserQnaBoardDTO dtoForAuth = userQnaService.getUserQnaForAuth(bno); // 권한 확인용 (조회수 증가 X)
        if (dtoForAuth == null) {
            rttr.addFlashAttribute("errorMessage", "해당 문의글을 찾을 수 없습니다.");
            return "redirect:/uqlist" + pageDTO.getQueryString(); // 목록으로 리다이렉트
        }

        boolean canView = isAdmin; // 관리자는 항상 볼 수 있음
        if (!canView && dtoForAuth.getWriter().equals(currentUserId)) { // 작성자 본인인 경우
            canView = true;
        }
        // 공개글(secret == 0)인 경우에도 볼 수 있도록 조건 추가
        if (!canView && dtoForAuth.getSecret() == 0) {
            canView = true;
        }


        if (!canView) { // 최종적으로 볼 권한이 없으면
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('글을 볼 권한이 없습니다.'); location.href='../uqlist" + pageDTO.getQueryString() +"';</script>");
            out.flush();
            return null;
        }

        // 실제 상세보기 로직 (조회수 증가 포함)
        UserQnaBoardDTO dto = userQnaService.getUserQnaDetail(bno, currentUserId, isAdmin);
        
        boolean canViewContent = true; // 기본적으로 내용을 볼 수 있다고 가정
        // 비밀글(1)이면서, 관리자도 아니고, 작성자 본인도 아니면 내용 가림 (서비스에서 이미 처리됨)
        // if (dto.isSecretPost() && !isAdmin && (currentUserId == null || !currentUserId.equals(dto.getWriter()))) {
        //    canViewContent = false;
        // }
        // 서비스 레이어에서 이미 비밀글 내용 처리를 하므로, 컨트롤러에서는 해당 결과를 그대로 사용

        model.addAttribute("dto", dto);
        model.addAttribute("paging", pageDTO);
        model.addAttribute("canViewContent", canViewContent); // JSP에서 이 값으로 내용 표시 여부 결정 가능
        model.addAttribute("currentLoginUserId", currentUserId);
        model.addAttribute("isUserAdmin", isAdmin);
        // JSP 파일명이 'uqview.jsp'이고, WEB-INF/views/userqna/ 폴더 안에 있다면
        return "uqview";
    }

 // 수정 폼
    @RequestMapping(value = "/uqedit", method = RequestMethod.GET)
    public String editForm(@RequestParam("bno") int bno, PageDTO pageDTO, Model model, HttpSession session, RedirectAttributes rttr, HttpServletResponse response) throws Exception {
        String currentUserId = (String) session.getAttribute("id");
        boolean isAdmin = Boolean.TRUE.equals(session.getAttribute("isAdmin"));
        UserQnaBoardDTO dto = userQnaService.getUserQnaForAuth(bno); // 수정 전 원본 데이터 (조회수 증가 X)

        if (dto == null) {
            rttr.addFlashAttribute("errorMessage", "수정할 글이 존재하지 않습니다.");
            // 목록으로 리다이렉트 시 페이징 정보 유지 (RedirectAttributes 사용)
            rttr.addAttribute("nowPage", pageDTO.getNowPage());
            rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
            rttr.addAttribute("searchType", pageDTO.getSearchType());
            rttr.addAttribute("keyword", pageDTO.getKeyword());
            return "redirect:/uqlist"; // 목록으로 리다이렉트
        }
        // 관리자가 아니고, 현재 로그인한 사용자가 글 작성자가 아니면 권한 없음
        if (!isAdmin && (currentUserId == null || !currentUserId.equals(dto.getWriter()))) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('수정 권한이 없습니다.'); history.back();</script>");
            out.flush();
            return null;
        }
        model.addAttribute("dto", dto); // Spring form tag 사용 위해 이름 "dto"로 설정
        model.addAttribute("paging", pageDTO);
        return "uqedit"; // WEB-INF/views/userqna/uqedit.jsp (또는 Tiles 설정에 따라)
    }

    // 수정 처리 (로깅 강화 버전)
    @RequestMapping(value = "/uqeditAction", method = RequestMethod.POST)
    public String editAction(
            UserQnaBoardDTO dto,
            @RequestParam(value="deleteExistingImage", required=false) String deleteExistingImage,
            PageDTO pageDTO,
            HttpSession session,
            RedirectAttributes rttr,
            HttpServletResponse response) throws Exception {

        log.info("--- 문의글 수정 처리 시작 (bno: {}) ---", dto.getBno());
        // log.info("전달된 DTO: {}", dto); // MultipartFile 객체 자체는 로깅이 복잡할 수 있음
        log.info("전달된 DTO 제목: {}", dto.getTitle());
        log.info("전달된 DTO 내용 길이: {}", dto.getContent() != null ? dto.getContent().length() : 0);
        log.info("전달된 DTO secret: {}", dto.getSecret());
        log.info("전달된 DTO qnaImageFile 존재 여부: {}", dto.getQnaImageFile() != null && !dto.getQnaImageFile().isEmpty());
        log.info("기존 이미지 삭제 요청 (deleteExistingImage): {}", deleteExistingImage);
        log.info("페이징 정보: {}", pageDTO);


        String currentUserId = (String) session.getAttribute("id");
        boolean isAdmin = Boolean.TRUE.equals(session.getAttribute("isAdmin"));

        // --- 1. 수정 권한 확인 ---
        UserQnaBoardDTO originalDto = userQnaService.getUserQnaForAuth(dto.getBno());
        if (originalDto == null) {
            log.warn("수정할 원본 글 없음 (bno: {})", dto.getBno());
            rttr.addFlashAttribute("errorMessage", "수정할 원본 글이 없습니다.");
            rttr.addAttribute("nowPage", pageDTO.getNowPage()); // 페이징 정보 추가
            //... (cntPerPage, searchType, keyword 추가) ...
            return "redirect:/uqlist";
        }
        if (!isAdmin && (currentUserId == null || !currentUserId.equals(originalDto.getWriter()))) {
            log.warn("수정 권한 없음 (bno: {}, 요청자: {})", dto.getBno(), currentUserId);
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            rttr.addAttribute("nowPage", pageDTO.getNowPage()); // 페이징 정보 추가
             //... (cntPerPage, searchType, keyword 추가) ...
            out.println("<script>alert('수정 권한이 없습니다.'); location.href='../uqlist';</script>"); // URL 경로 확인
            out.flush();
            return null;
        }

        // --- 2. 파일 처리 ---
        String oldFileName = originalDto.getImageFile();
        String dbUpdateFileName = oldFileName;
        String newUploadedFileName = null;
        String realUploadPath = servletContext.getRealPath(IMAGE_UPLOAD_PATH); // 상수 사용
        log.info("이미지 실제 저장 경로: {}", realUploadPath);

        MultipartFile uploadFile = dto.getQnaImageFile();

        // 2-1. 새 파일 업로드 확인
        if (uploadFile != null && !uploadFile.isEmpty()) {
            log.info("새 이미지 파일 감지됨: {}", uploadFile.getOriginalFilename());
            File saveDir = new File(realUploadPath);
            if (!saveDir.exists()) {
                if (saveDir.mkdirs()) log.info("업로드 폴더 생성 성공: {}", realUploadPath);
                else {
                    log.error("★★★ 업로드 폴더 생성 실패!: {}", realUploadPath); // 에러 로그 강화
                    rttr.addFlashAttribute("errorMessage", "파일 저장 폴더 생성에 실패했습니다. 서버 설정을 확인하세요.");
                    rttr.addAttribute("bno", dto.getBno()); // 파라미터 추가
                    //... 페이징/검색 파라미터 추가 ...
                    return "redirect:/uqedit";
                }
            }

            String originalFileName = uploadFile.getOriginalFilename();
            String fileExtension = (originalFileName.contains(".")) ? originalFileName.substring(originalFileName.lastIndexOf(".")) : "";
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            File saveFile = new File(realUploadPath, uniqueFileName);

            try {
                uploadFile.transferTo(saveFile); // 파일 저장
                newUploadedFileName = uniqueFileName;
                dbUpdateFileName = newUploadedFileName;
                log.info("새 이미지 파일 저장 성공: {}", saveFile.getAbsolutePath());
            } catch (IOException e) {
                
                rttr.addFlashAttribute("errorMessage", "파일 저장 중 오류가 발생했습니다. 파일 크기 또는 경로 권한을 확인하세요.");
                rttr.addAttribute("bno", dto.getBno()); // 파라미터 추가
                 //... 페이징/검색 파라미터 추가 ...
                return "redirect:/uqedit";
            }
        } else {
             // 2-2. 기존 이미지 삭제 요청 확인
            if ("yes".equals(deleteExistingImage) && oldFileName != null) {
                log.info("기존 이미지 삭제 요청됨 (파일명: {})", oldFileName);
                dbUpdateFileName = null; // DB는 null로 업데이트
            } else {
                log.info("새 이미지 파일 없음, 기존 이미지 유지 또는 삭제 요청 없음 (기존 파일명: {})", oldFileName);
            }
        }

        // --- 3. DTO에 최종 파일명 설정 및 DB 업데이트 ---
        dto.setImageFile(dbUpdateFileName);
        log.info("DB 업데이트 전 DTO 최종 imageFile: {}", dto.getImageFile()); // 최종 값 확인

        boolean updateSuccess = false;
        try {
             dto.setWriter(originalDto.getWriter()); // 작성자는 변경하지 않도록 원본 사용
             updateSuccess = userQnaService.updateUserQna(dto, currentUserId, isAdmin);
             log.info("DB 업데이트 결과: {}", updateSuccess ? "성공" : "실패");
        } catch (Exception e) {
            log.error("★★★ UserQnA DB 업데이트 중 오류 발생!", e); // 예외 로그 상세히
            updateSuccess = false;
        }

        // --- 4. 결과 처리 및 파일 최종 정리 ---
        if (updateSuccess) {
            log.info("DB 업데이트 성공, 파일 정리 시작");
            // 4-1. 새 파일 업로드 성공 & 기존 파일 있었으면 -> 기존 파일 삭제
            if (newUploadedFileName != null && oldFileName != null && !oldFileName.isEmpty()) {
                File oldServerFile = new File(realUploadPath, oldFileName);
                if (oldServerFile.exists()) {
                    log.info("기존 파일 삭제 시도: {}", oldServerFile.getAbsolutePath());
                    if (!oldServerFile.delete()) log.warn("★★★ 기존 이미지 파일 삭제 실패!: {}", oldServerFile.getAbsolutePath());
                    else log.info("기존 이미지 파일 삭제 성공.");
                } else log.warn("삭제할 기존 파일이 실제 경로에 없음: {}", oldServerFile.getAbsolutePath());
            }
            // 4-2. '기존 이미지 삭제' 요청 & DB null 업데이트 성공 & 기존 파일 있었으면 -> 기존 파일 삭제
            else if ("yes".equals(deleteExistingImage) && dbUpdateFileName == null && oldFileName != null && !oldFileName.isEmpty()) {
                File oldServerFile = new File(realUploadPath, oldFileName);
                 if (oldServerFile.exists()) {
                    log.info("기존 파일 삭제 시도 (삭제 요청됨): {}", oldServerFile.getAbsolutePath());
                    if (!oldServerFile.delete()) log.warn("★★★ 기존 이미지 파일 삭제 실패! (삭제 요청됨): {}", oldServerFile.getAbsolutePath());
                    else log.info("기존 이미지 파일 삭제 성공 (삭제 요청됨).");
                } else log.warn("삭제할 기존 파일(삭제 요청됨)이 실제 경로에 없음: {}", oldServerFile.getAbsolutePath());
            }

            rttr.addFlashAttribute("message", dto.getBno() + "번 글이 성공적으로 수정되었습니다.");
            rttr.addAttribute("bno", dto.getBno());
            //... (페이징/검색 파라미터 추가) ...
             rttr.addAttribute("nowPage", pageDTO.getNowPage());
             rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
             rttr.addAttribute("searchType", pageDTO.getSearchType());
             rttr.addAttribute("keyword", pageDTO.getKeyword());
            return "redirect:/uqview"; // 성공

        } else { // DB 업데이트 실패
            log.warn("DB 업데이트 실패, 롤백 처리 시작");
            rttr.addFlashAttribute("errorMessage", "글 수정에 실패했습니다. 다시 시도해주세요.");
            // 4-3. DB 실패 시, 업로드했던 새 파일 롤백(삭제)
            if (newUploadedFileName != null) {
                File newServerFile = new File(realUploadPath, newUploadedFileName);
                if (newServerFile.exists()) {
                     log.info("DB 실패로 인한 새 파일 롤백 삭제 시도: {}", newServerFile.getAbsolutePath());
                    if (newServerFile.delete()) log.info("새 파일 롤백 삭제 성공.");
                    else log.error("★★★ 새 파일 롤백 삭제 실패!: {}", newServerFile.getAbsolutePath());
                }
            }
            rttr.addAttribute("bno", dto.getBno());
            //... (페이징/검색 파라미터 추가) ...
             rttr.addAttribute("nowPage", pageDTO.getNowPage());
             rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
             rttr.addAttribute("searchType", pageDTO.getSearchType());
             rttr.addAttribute("keyword", pageDTO.getKeyword());
            return "redirect:/uqedit"; // 실패
        }
    } // end of editAction
    // 삭제 처리
    @RequestMapping(value = "/uqdelete", method = RequestMethod.GET) // 보통 POST나 DELETE지만, 편의상 GET으로 둘 수 있음
    public String deleteAction(@RequestParam("bno") int bno, PageDTO pageDTO, HttpSession session, RedirectAttributes rttr, HttpServletResponse response) throws Exception {
        String currentUserId = (String) session.getAttribute("id");
        boolean isAdmin = Boolean.TRUE.equals(session.getAttribute("isAdmin"));

        UserQnaBoardDTO dtoToDelete = userQnaService.getUserQnaForAuth(bno); // 삭제 전 정보 확인
        if (dtoToDelete == null) {
            rttr.addFlashAttribute("errorMessage", "삭제할 글이 존재하지 않습니다.");
            return "redirect:/uqlist" + pageDTO.getQueryString();
        }
        if (!isAdmin && (currentUserId == null || !currentUserId.equals(dtoToDelete.getWriter()))) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('삭제 권한이 없습니다.'); location.href='../uqlist';</script>");
            out.flush();
            return null;
        }

        boolean deleteDbSuccess = false;
        try {
            deleteDbSuccess = userQnaService.deleteUserQna(bno, currentUserId, isAdmin);
        } catch (Exception e) {
            log.error("UserQnA DB 삭제 중 오류", e);
            // deleteDbSuccess는 false
        }

        if (deleteDbSuccess) {
            if (dtoToDelete.getImageFile() != null && !dtoToDelete.getImageFile().isEmpty()) {
                String filePath = servletContext.getRealPath(IMAGE_UPLOAD_PATH + File.separator + dtoToDelete.getImageFile());
                File fileToDelete = new File(filePath);
                if (fileToDelete.exists()) {
                    if(fileToDelete.delete()){
                         log.info("UserQnA 첨부파일 삭제 성공: " + filePath);
                    } else {
                        log.warn("UserQnA 첨부파일 삭제 실패: " + filePath);
                        // 파일 삭제 실패 시 에러 메시지를 전달할 수도 있음
                    }
                }
            }
            rttr.addFlashAttribute("message", bno + "번 글이 삭제되었습니다.");
        } else {
            rttr.addFlashAttribute("errorMessage", "글 삭제에 실패했거나 권한이 없습니다.");
            // 실패 시 상세 보기 페이지로 리다이렉트 (이미 삭제 시도된 글이므로 목록으로 가는게 나을 수도 있음)
            return "redirect:/uqview?bno=" + bno + pageDTO.getQueryString();
        }
        return "redirect:/uqlist" + pageDTO.getQueryString(); // 성공 시 목록으로
    }

    // 관리자 답변 저장/수정
 // 관리자 답변 저장/수정
    @RequestMapping(value = "/saveAnswer", method = RequestMethod.POST)
    public String saveAnswer(
            UserQnaBoardDTO dto, // bno, answerContent 바인딩
            PageDTO pageDTO, // nowPage, cntPerPage 등 hidden 필드 값 바인딩
            HttpSession session,
            RedirectAttributes rttr, // RedirectAttributes 파라미터 추가
            HttpServletResponse response) throws Exception {

        // 관리자 권한 확인
        if (!Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('답변 작성 권한이 없습니다.'); history.back();</script>");
            out.flush();
            return null;
        }
        String adminId = (String) session.getAttribute("id"); // 관리자 ID

        boolean saveSuccess = false;
        try {
             // 서비스 호출하여 답변 저장/수정
             saveSuccess = userQnaService.saveAnswer(dto, adminId);
        } catch (Exception e) {
            log.error("UserQnA 답변 저장 중 오류 발생 (bno: {})", dto.getBno(), e);
            saveSuccess = false;
        }

        // 결과 메시지 설정
        if (saveSuccess) {
            rttr.addFlashAttribute("message", dto.getBno() + "번 글에 답변이 등록/수정되었습니다.");
        } else {
            rttr.addFlashAttribute("errorMessage", "답변 등록/수정에 실패했습니다.");
        }

        // !!! 수정된 부분: RedirectAttributes 사용 !!!
        // 리다이렉트될 URL에 필요한 파라미터를 추가
        rttr.addAttribute("bno", dto.getBno());
        rttr.addAttribute("nowPage", pageDTO.getNowPage());
        rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
        rttr.addAttribute("searchType", pageDTO.getSearchType());
        rttr.addAttribute("keyword", pageDTO.getKeyword());

        // 리다이렉트 경로는 기본 경로만 지정
        return "redirect:/uqview"; // Spring이 올바른 URL(?bno=...&nowPage=...)을 생성
    }
}