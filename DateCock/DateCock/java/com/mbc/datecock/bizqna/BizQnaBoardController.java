package com.mbc.datecock.bizqna; // 패키지명 변경

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
// import com.mbc.datecock.bizqna.BizQnaBoardDTO; // DTO 임포트
// import com.mbc.datecock.bizqna.BizQnaBoardService; // Service 임포트

@Controller
public class BizQnaBoardController { // 클래스명 변경

    private static final Logger log = LoggerFactory.getLogger(BizQnaBoardController.class); // 클래스명 변경

    @Autowired
    private BizQnaBoardService bizQnaService; // 서비스 타입 변경

    @Autowired
    private ServletContext servletContext;

    // 기업 Q&A용 이미지 업로드 경로 (기존 UserQna와 구분하거나 동일하게 사용 가능)
    private static final String BIZ_QNA_IMAGE_UPLOAD_PATH = "/image"; // 예시: 경로 변경

    // 접근 권한 확인 (기업 사용자 또는 관리자)
    private boolean canAccessBizQna(HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) return true; // 관리자는 항상 접근 가능

        // *** 수정된 부분: 세션 키 "buisnessloginstate" 사용 ***
        Boolean isBusinessLoggedIn = (Boolean) session.getAttribute("buisnessloginstate"); // <-- 오타 유지
        String businessNumber = (String) session.getAttribute("businessnumberA");        // 기업회원 번호 세션 키

        return Boolean.TRUE.equals(isBusinessLoggedIn) && businessNumber != null && !businessNumber.isEmpty();
    }

    // 목록
    @RequestMapping(value = "/bqlist", method = RequestMethod.GET) // 경로 변경
    public String list(PageDTO pageDTO, Model model, HttpSession session, HttpServletResponse response) throws Exception {
        // 관리자가 아니고, 기업 사용자 접근 조건도 만족하지 못하면 접근 불가 (canAccessBizQna 호출)
        if (!Boolean.TRUE.equals(session.getAttribute("isAdmin")) && !canAccessBizQna(session)) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('기업 문의게시판 접근 권한이 없습니다.'); location.href='../main';</script>"); // 로그인 페이지나 메인으로
            out.flush();
            return null;
        }

        // PageDTO에 현재 로그인한 사용자 정보 설정
        String currentLoginId = null; // 관리자 또는 사업자 번호
        boolean isAdmin = Boolean.TRUE.equals(session.getAttribute("isAdmin"));
        if (isAdmin) {
            currentLoginId = (String) session.getAttribute("id"); // 관리자 ID (혹은 다른 식별자)
        } else {
            currentLoginId = (String) session.getAttribute("businessnumberA"); // 사업자 번호
        }
        pageDTO.setLoginUserId(currentLoginId); // MyBatis에서 writer 비교 시 사용 (사업자번호 또는 null)
        pageDTO.setAdmin(isAdmin);

        int totalCount = bizQnaService.getTotalBizQnaCount(pageDTO); // 서비스 메소드명 변경
        pageDTO.setTotal(totalCount);
        if (pageDTO.getTotal() > 0) {
             pageDTO.calculatePaging();
        } else {
             log.info("총 기업 문의 게시글 수가 0이므로 페이징 계산을 건너뜁니다.");
        }

        List<BizQnaBoardDTO> list = bizQnaService.getBizQnaListPaged(pageDTO); // 서비스 메소드명, 반환타입 변경
        model.addAttribute("list", list);
        model.addAttribute("paging", pageDTO);
        model.addAttribute("currentLoginUserId", currentLoginId); // JSP에서 작성자 비교 등에 사용
        model.addAttribute("isUserAdmin", isAdmin);
        return "bqlist"; // JSP 경로 변경
    }

    // 글쓰기 폼
    @RequestMapping(value = "/bqwrite", method = RequestMethod.GET)
    public String writeForm(HttpSession session, HttpServletResponse response, Model model) throws IOException {
        // --- 권한 확인 로직 ---
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        // *** 수정된 부분: 세션 키 "buisnessloginstate" 사용 ***
        Boolean isBusinessLoggedIn = (Boolean) session.getAttribute("buisnessloginstate"); // <-- 오타 유지
        String businessNumber = (String) session.getAttribute("businessnumberA");
        String adminId = (String) session.getAttribute("id"); // 관리자 ID 가져오기 (세션 키 확인 필요)

        boolean isAuthorized = false;
        if (Boolean.TRUE.equals(isAdmin)) { // 관리자 우선 확인
            isAuthorized = true;
            log.info("관리자({})가 기업 문의 작성 페이지 접근", adminId);
        } else if (Boolean.TRUE.equals(isBusinessLoggedIn) && businessNumber != null && !businessNumber.isEmpty()) { // 기업 회원 확인
            isAuthorized = true;
            log.info("기업 사용자({})가 기업 문의 작성 페이지 접근", businessNumber);
        }

        if (!isAuthorized) { // 권한이 없는 경우
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            // 접근 불가 메시지
            out.println("<script>alert('기업 문의글 작성 권한이 없습니다. 기업회원 또는 관리자로 로그인해주세요.'); location.href='../DateCocklog';</script>"); // 로그인 페이지 경로 확인
            out.flush();
            return null; // View 반환 안 함
        }
        // --- 권한 확인 로직 끝 ---

        // 권한이 있으면 빈 DTO 모델에 추가하고 폼 페이지로 이동
        model.addAttribute("bizQnaBoardDTO", new BizQnaBoardDTO());
        return "bqwrite"; // Tiles definition 이름
    }

    @RequestMapping(value = "/bqwriteAction", method = RequestMethod.POST)
    public String writeAction(BizQnaBoardDTO dto, HttpSession session, RedirectAttributes rttr, HttpServletResponse response) throws Exception {
        // --- 권한 확인 및 작성자, 사업자명 설정 로직 ---
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Boolean isBusinessLoggedIn = (Boolean) session.getAttribute("buisnessloginstate"); // 세션 키 오타 유지
        String businessNumberFromSession = (String) session.getAttribute("businessnumberA"); // 세션에서 사업자 번호 가져오기
        String adminId = (String) session.getAttribute("id"); // 관리자 ID

        boolean isAuthorized = false;
        String writerIdentity = null;       // 실제 작성자로 기록될 값 (사업자번호 또는 관리자ID)
        String sessionBusinessName = null;  // 세션에서 가져올 사업자명

        if (Boolean.TRUE.equals(isAdmin) && adminId != null) { // 관리자 케이스
            isAuthorized = true;
            writerIdentity = adminId;
            // 관리자가 글을 쓸 경우 사업자명 처리 정책 필요 (예: "관리자" 또는 null)
            sessionBusinessName = "관리자"; // 예시: 관리자가 작성 시 "관리자"로 표시
            log.info("관리자({})가 기업 문의 작성 처리 시도", writerIdentity);
        } else if (Boolean.TRUE.equals(isBusinessLoggedIn) && businessNumberFromSession != null && !businessNumberFromSession.isEmpty()) { // 기업 회원 케이스
            isAuthorized = true;
            writerIdentity = businessNumberFromSession;
            // *** 중요: 세션에서 사업자명 가져오기 ***
            sessionBusinessName = (String) session.getAttribute("businessname");
            log.info("기업 사용자({})가 기업 문의 작성 처리 시도, 사업자명: {}", writerIdentity, sessionBusinessName);
        }

        if (!isAuthorized) { // 권한 없는 경우 처리
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('로그인이 필요하거나 글 작성 권한이 없습니다.'); location.href='../DateCocklog';</script>");
            out.flush();
            return null;
        }

        dto.setWriter(writerIdentity); // DTO에 확정된 작성자(사업자번호 또는 관리자ID) 설정
        // *** 중요: DTO에 세션에서 가져온 사업자명 설정 ***
        dto.setBusinessName(sessionBusinessName);
        // --- 권한 확인 및 작성자, 사업자명 설정 끝 ---

        // --- 파일 업로드 로직 (기존과 거의 동일) ---
        MultipartFile uploadFile = dto.getQnaImageFile();
        String uploadedFileName = null;
        if (uploadFile != null && !uploadFile.isEmpty()) {
            String originalFileName = uploadFile.getOriginalFilename();
            // 이미지 업로드 경로 (BIZ_QNA_IMAGE_UPLOAD_PATH 확인 필요)
            String uploadDir = servletContext.getRealPath(BIZ_QNA_IMAGE_UPLOAD_PATH); 
            File saveDir = new File(uploadDir);
            if (!saveDir.exists()) {
                if(!saveDir.mkdirs()) {
                     log.error("BizQnA 업로드 폴더 생성 실패: {}", uploadDir);
                     rttr.addFlashAttribute("errorMessage", "파일 저장 폴더 생성에 실패했습니다.");
                     rttr.addFlashAttribute("bizQnaBoardDTO", dto); // 입력값 유지를 위해 DTO 전달
                     return "redirect:/bqwrite"; // 글쓰기 폼으로 다시 이동
                }
            }
            String fileExtension = (originalFileName.contains(".")) ? originalFileName.substring(originalFileName.lastIndexOf(".")) : "";
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            File saveFile = new File(uploadDir, uniqueFileName);
            try {
                uploadFile.transferTo(saveFile);
                uploadedFileName = uniqueFileName;
                log.info("BizQnA 파일 업로드 성공: {}", saveFile.getAbsolutePath());
            } catch (IOException e) {
                log.error("BizQnA 파일 업로드 실패: ", e);
                rttr.addFlashAttribute("errorMessage", "파일 업로드 중 오류가 발생했습니다.");
                rttr.addFlashAttribute("bizQnaBoardDTO", dto);
                return "redirect:/bqwrite";
            }
        }
        dto.setImageFile(uploadedFileName); // DB에 저장될 파일명 (없으면 null)
        // --- 파일 업로드 로직 끝 ---

        // --- 서비스 호출 및 결과 처리 ---
        boolean writeSuccess = false;
        try {
             // 이제 DTO에는 writer와 businessName이 모두 설정되어 있음
            writeSuccess = bizQnaService.writeBizQna(dto);
        } catch (Exception e) {
            log.error("BizQnA DB 저장 중 오류 발생", e);
            // writeSuccess는 이미 false
        }

        if (writeSuccess) {
            rttr.addFlashAttribute("message", "기업 문의글이 등록되었습니다.");
        } else {
            rttr.addFlashAttribute("errorMessage", "기업 문의글 등록에 실패했습니다. 입력 내용을 확인해주세요.");
            rttr.addFlashAttribute("bizQnaBoardDTO", dto); // 실패 시 입력값 유지를 위해 DTO 전달
            if (uploadedFileName != null) { // 파일 업로드는 성공했으나 DB 저장이 실패한 경우, 업로드된 파일 삭제
                 try {
                    new File(servletContext.getRealPath(BIZ_QNA_IMAGE_UPLOAD_PATH + File.separator + uploadedFileName)).delete();
                    log.info("DB 저장 실패로 인한 BizQnA 업로드 파일 삭제: {}", uploadedFileName);
                 } catch(Exception e) {
                    log.error("DB 저장 실패 후 업로드 파일 삭제 중 오류", e);
                 }
            }
            return "redirect:/bqwrite"; // 글쓰기 폼으로 다시 이동
        }
        return "redirect:/bqlist"; // 성공 시 목록으로
        // --- 서비스 호출 및 결과 처리 끝 ---
    }

    // 상세보기
    @RequestMapping(value = "/bqview", method = RequestMethod.GET) // 경로 변경
    public String view(@RequestParam("bno") int bno, PageDTO pageDTO, Model model, HttpSession session, RedirectAttributes rttr, HttpServletResponse response) throws Exception {
        String currentLoginId = null; // 현재 로그인한 사용자 ID (관리자 ID 또는 사업자번호)
        boolean isAdmin = Boolean.TRUE.equals(session.getAttribute("isAdmin"));
        // *** 여기는 이미 오타("buisnessloginstate")로 되어 있음 ***
        Boolean isBusinessLoggedIn = (Boolean) session.getAttribute("buisnessloginstate"); // <-- 오타 유지됨
        String businessNumber = (String) session.getAttribute("businessnumberA");

        if (isAdmin) {
            currentLoginId = (String) session.getAttribute("id"); // 관리자의 경우 일반 ID 사용 가정
        } else if (Boolean.TRUE.equals(isBusinessLoggedIn) && businessNumber != null) {
            currentLoginId = businessNumber;
        }

        BizQnaBoardDTO dtoForAuth = bizQnaService.getBizQnaForAuth(bno); // 서비스 메소드명, 반환타입 변경
        if (dtoForAuth == null) {
            rttr.addFlashAttribute("errorMessage", "해당 기업 문의글을 찾을 수 없습니다.");
            // *** 중요: 상세보기에서도 pageDTO.getQueryString() 사용 필요 ***
            // rttr.addAttribute(...) 로 개별 파라미터 추가하거나, PageDTO의 getQueryString() 사용
            return "redirect:/bqlist" + pageDTO.getQueryString(); // 수정된 bqlist.jsp의 링크 생성 방식과 일치시키기 위해 필요
        }

        boolean canView = isAdmin; // 관리자는 항상 보기 가능
        if (!canView && dtoForAuth.getWriter().equals(currentLoginId)) { // 작성자 본인(사업자)인 경우
            canView = true;
        }
        if (!canView && dtoForAuth.getSecret() == 0) { // 공개글인 경우
            canView = true;
        }


        if (!canView) { // 최종 권한 체크 (여기서도 isBusinessLoggedIn 사용)
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('글을 볼 권한이 없습니다.'); location.href='../bqlist" + pageDTO.getQueryString() +"';</script>"); // 경로 변경 및 파라미터 전달
            out.flush();
            return null;
        }

        BizQnaBoardDTO dto = bizQnaService.getBizQnaDetail(bno, currentLoginId, isAdmin); // 서비스 메소드명, 반환타입 변경

        model.addAttribute("dto", dto); // DTO 타입 변경
        model.addAttribute("paging", pageDTO);
        model.addAttribute("currentLoginUserId", currentLoginId); // JSP에서 사용
        model.addAttribute("isUserAdmin", isAdmin);
        return "bqview"; // JSP 경로 변경
    }

    // 수정 폼
    @RequestMapping(value = "/bqedit", method = RequestMethod.GET) // 경로 변경
    public String editForm(@RequestParam("bno") int bno, PageDTO pageDTO, Model model, HttpSession session, RedirectAttributes rttr, HttpServletResponse response) throws Exception {
        String currentLoginId = null;
        boolean isAdmin = Boolean.TRUE.equals(session.getAttribute("isAdmin"));
        String businessNumberFromSession = (String) session.getAttribute("businessnumberA");

        if (isAdmin) {
            currentLoginId = (String) session.getAttribute("id");
        } else if (businessNumberFromSession != null) {
            currentLoginId = businessNumberFromSession;
        }


        BizQnaBoardDTO dto = bizQnaService.getBizQnaForAuth(bno); // 서비스 메소드명, 반환타입 변경

        if (dto == null) {
            rttr.addFlashAttribute("errorMessage", "수정할 글이 존재하지 않습니다.");
            // *** 리다이렉트 시 페이징 정보 유지 ***
            rttr.addAttribute("nowPage", pageDTO.getNowPage());
            rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
            if (pageDTO.getSearchType() != null) rttr.addAttribute("searchType", pageDTO.getSearchType());
            if (pageDTO.getKeyword() != null) rttr.addAttribute("keyword", pageDTO.getKeyword());
            return "redirect:/bqlist"; // 경로 변경
        }
        // 관리자가 아니고, 현재 로그인한 사업자 번호가 글 작성자(사업자번호)와 다르면 권한 없음
        if (!isAdmin && (currentLoginId == null || !currentLoginId.equals(dto.getWriter()))) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('수정 권한이 없습니다.'); history.back();</script>");
            out.flush();
            return null;
        }
        model.addAttribute("dto", dto); // DTO 타입 변경
        model.addAttribute("paging", pageDTO);
        return "bqedit"; // JSP 경로 변경
    }

    // 수정 처리
    @RequestMapping(value = "/bqeditAction", method = RequestMethod.POST) // 경로 변경
    public String editAction(
            BizQnaBoardDTO dto, // DTO 타입 변경
            @RequestParam(value="deleteExistingImage", required=false) String deleteExistingImage,
            PageDTO pageDTO,
            HttpSession session,
            RedirectAttributes rttr,
            HttpServletResponse response) throws Exception {

        log.info("--- 기업 문의글 수정 처리 시작 (bno: {}) ---", dto.getBno());

        String currentLoginId = null; // 현재 로그인한 사용자 ID (관리자 ID 또는 사업자번호)
        boolean isAdmin = Boolean.TRUE.equals(session.getAttribute("isAdmin"));
        String businessNumberFromSession = (String) session.getAttribute("businessnumberA");

        if (isAdmin) {
            currentLoginId = (String) session.getAttribute("id");
        } else if (businessNumberFromSession != null) {
            currentLoginId = businessNumberFromSession;
        }

        BizQnaBoardDTO originalDto = bizQnaService.getBizQnaForAuth(dto.getBno()); // 서비스, DTO 변경
        if (originalDto == null) {
            // *** 원본 글 없음 처리 (리다이렉트 시 페이징 정보 유지) ***
            rttr.addFlashAttribute("errorMessage", "수정할 원본 글이 없습니다.");
            rttr.addAttribute("nowPage", pageDTO.getNowPage());
            rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
            if (pageDTO.getSearchType() != null) rttr.addAttribute("searchType", pageDTO.getSearchType());
            if (pageDTO.getKeyword() != null) rttr.addAttribute("keyword", pageDTO.getKeyword());
            return "redirect:/bqlist"; // 경로 변경
        }
        if (!isAdmin && (currentLoginId == null || !currentLoginId.equals(originalDto.getWriter()))) {
            // (수정 권한 없음 처리 로직은 UserQna와 동일)
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('수정 권한이 없습니다.'); history.back();</script>");
            out.flush();
            return null;
        }

        // --- 파일 처리 ---
        String oldFileName = originalDto.getImageFile();
        String dbUpdateFileName = oldFileName;
        String newUploadedFileName = null;
        String realUploadPath = servletContext.getRealPath(BIZ_QNA_IMAGE_UPLOAD_PATH);

        MultipartFile uploadFile = dto.getQnaImageFile();
        if (uploadFile != null && !uploadFile.isEmpty()) {
             File saveDir = new File(realUploadPath);
            if (!saveDir.exists()) { saveDir.mkdirs(); }
            String originalFilename = uploadFile.getOriginalFilename();
            String extension = "";
            if (originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String savedFileName = UUID.randomUUID().toString() + extension;
            File saveFile = new File(realUploadPath, savedFileName);
            try {
                uploadFile.transferTo(saveFile);
                newUploadedFileName = savedFileName;
                dbUpdateFileName = newUploadedFileName;
                log.info("기업 QnA 새 파일 저장 성공: {}", savedFileName);
            } catch (IOException e) {
                 rttr.addFlashAttribute("errorMessage", "파일 저장 중 오류 발생");
                 // *** 리다이렉트 시 페이징 정보 유지 ***
                 rttr.addAttribute("bno", dto.getBno());
                 rttr.addAttribute("nowPage", pageDTO.getNowPage());
                 rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
                 if (pageDTO.getSearchType() != null) rttr.addAttribute("searchType", pageDTO.getSearchType());
                 if (pageDTO.getKeyword() != null) rttr.addAttribute("keyword", pageDTO.getKeyword());
                 return "redirect:/bqedit"; // 경로 변경
            }
        } else {
            if ("yes".equals(deleteExistingImage) && oldFileName != null) {
                dbUpdateFileName = null;
            }
        }
        dto.setImageFile(dbUpdateFileName);
        // --- 파일 처리 끝 ---

        boolean updateSuccess = false;
        try {
             dto.setWriter(originalDto.getWriter()); // 작성자는 변경 불가
             updateSuccess = bizQnaService.updateBizQna(dto, currentLoginId, isAdmin); // 서비스 메소드명, 파라미터 타입 변경
        } catch (Exception e) {
            log.error("BizQnA DB 업데이트 중 오류 발생!", e);
        }

        if (updateSuccess) {
            // 파일 최종 정리
            if (newUploadedFileName != null && oldFileName != null && !oldFileName.isEmpty()) {
                new File(realUploadPath, oldFileName).delete();
            } else if ("yes".equals(deleteExistingImage) && dbUpdateFileName == null && oldFileName != null && !oldFileName.isEmpty()) {
                new File(realUploadPath, oldFileName).delete();
            }
            rttr.addFlashAttribute("message"," 기업 문의글이 수정되었습니다.");
            // *** 상세보기 리다이렉트 시 페이징 정보 유지 ***
            rttr.addAttribute("bno", dto.getBno());
            rttr.addAttribute("nowPage", pageDTO.getNowPage());
            rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
            if (pageDTO.getSearchType() != null) rttr.addAttribute("searchType", pageDTO.getSearchType());
            if (pageDTO.getKeyword() != null) rttr.addAttribute("keyword", pageDTO.getKeyword());
            return "redirect:/bqview"; // 경로 변경
        } else {
            // DB 업데이트 실패 시 롤백 처리
            if (newUploadedFileName != null) {
                new File(realUploadPath, newUploadedFileName).delete();
            }
            rttr.addFlashAttribute("errorMessage", "기업 문의글 수정에 실패했습니다.");
            // *** 수정폼 리다이렉트 시 페이징 정보 유지 ***
            rttr.addAttribute("bno", dto.getBno());
            rttr.addAttribute("nowPage", pageDTO.getNowPage());
            rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
            if (pageDTO.getSearchType() != null) rttr.addAttribute("searchType", pageDTO.getSearchType());
            if (pageDTO.getKeyword() != null) rttr.addAttribute("keyword", pageDTO.getKeyword());
            return "redirect:/bqedit"; // 경로 변경
        }
    }

    // 삭제 처리
    @RequestMapping(value = "/bqdelete", method = RequestMethod.GET) // 경로 변경
    public String deleteAction(@RequestParam("bno") int bno, PageDTO pageDTO, HttpSession session, RedirectAttributes rttr, HttpServletResponse response) throws Exception {
        String currentLoginId = null;
        boolean isAdmin = Boolean.TRUE.equals(session.getAttribute("isAdmin"));
        String businessNumberFromSession = (String) session.getAttribute("businessnumberA");

        if (isAdmin) {
            currentLoginId = (String) session.getAttribute("id");
        } else if (businessNumberFromSession != null) {
            currentLoginId = businessNumberFromSession;
        }

        BizQnaBoardDTO dtoToDelete = bizQnaService.getBizQnaForAuth(bno); // 서비스, DTO 변경
        if (dtoToDelete == null) {
            // *** 글 없음 처리 (리다이렉트 시 페이징 정보 유지) ***
            rttr.addFlashAttribute("errorMessage", "삭제할 글이 존재하지 않습니다.");
            // pageDTO.getQueryString() 대신 개별 파라미터 추가
            rttr.addAttribute("nowPage", pageDTO.getNowPage());
            rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
            if (pageDTO.getSearchType() != null) rttr.addAttribute("searchType", pageDTO.getSearchType());
            if (pageDTO.getKeyword() != null) rttr.addAttribute("keyword", pageDTO.getKeyword());
            return "redirect:/bqlist"; // 경로 변경
        }
        if (!isAdmin && (currentLoginId == null || !currentLoginId.equals(dtoToDelete.getWriter()))) {
            // (삭제 권한 없음 처리 로직은 UserQna와 동일)
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('삭제 권한이 없습니다.'); history.back();</script>");
            out.flush();
            return null;
        }

        boolean deleteDbSuccess = false;
        try {
            deleteDbSuccess = bizQnaService.deleteBizQna(bno, currentLoginId, isAdmin); // 서비스 메소드명 변경
        } catch (Exception e) {
            log.error("BizQnA DB 삭제 중 오류", e);
        }

        if (deleteDbSuccess) {
            // 첨부파일 삭제
            if (dtoToDelete.getImageFile() != null && !dtoToDelete.getImageFile().isEmpty()) {
                String filePath = servletContext.getRealPath(BIZ_QNA_IMAGE_UPLOAD_PATH + File.separator + dtoToDelete.getImageFile());
                new File(filePath).delete();
            }
            rttr.addFlashAttribute("message", "기업 문의글이 삭제되었습니다.");
        } else {
            rttr.addFlashAttribute("errorMessage", "기업 문의글 삭제에 실패했거나 권한이 없습니다.");
            // *** 실패 시 상세보기 리다이렉트 - 페이징 정보 유지 ***
            rttr.addAttribute("bno", bno);
            rttr.addAttribute("nowPage", pageDTO.getNowPage());
            rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
            if (pageDTO.getSearchType() != null) rttr.addAttribute("searchType", pageDTO.getSearchType());
            if (pageDTO.getKeyword() != null) rttr.addAttribute("keyword", pageDTO.getKeyword());
            return "redirect:/bqview"; // 경로 변경
        }
        // *** 성공 시 목록 리다이렉트 - 페이징 정보 유지 ***
        rttr.addAttribute("nowPage", pageDTO.getNowPage());
        rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
        if (pageDTO.getSearchType() != null) rttr.addAttribute("searchType", pageDTO.getSearchType());
        if (pageDTO.getKeyword() != null) rttr.addAttribute("keyword", pageDTO.getKeyword());
        return "redirect:/bqlist"; // 경로 변경
    }

    // 관리자 답변 저장/수정
    @RequestMapping(value = "/bqSaveAnswer", method = RequestMethod.POST) // 경로 변경
    public String saveAnswer(
            BizQnaBoardDTO dto, // DTO 타입 변경
            PageDTO pageDTO,
            HttpSession session,
            RedirectAttributes rttr,
            HttpServletResponse response) throws Exception {

        if (!Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {
            // (관리자 권한 없음 처리 로직은 UserQna와 동일)
             response.setContentType("text/html;charset=UTF-8");
             PrintWriter out = response.getWriter();
             out.println("<script>alert('답변 작성 권한이 없습니다.'); history.back();</script>");
             out.flush();
            return null;
        }
        String adminId = (String) session.getAttribute("id"); // 관리자 ID

        boolean saveSuccess = false;
        String qnaTitle = ""; // 제목을 담을 변수
        try {
            // 원본 게시글 정보 조회 (답변 저장 전에)
            BizQnaBoardDTO originalDto = bizQnaService.getBizQnaForAuth(dto.getBno()); // 예시: 제목을 가져오기 위한 조회
            if (originalDto != null) {
                qnaTitle = originalDto.getTitle();
            }
            saveSuccess = bizQnaService.saveAnswer(dto, adminId);
        } catch (Exception e) {
            log.error("BizQnA 답변 저장 중 오류 발생 (bno: {})", dto.getBno(), e);
        }

        if (saveSuccess) {
            // 조회한 title 사용
            rttr.addFlashAttribute("message", "'" + qnaTitle + "' 제목의 기업 문의글에 답변이 등록/수정되었습니다.");
        } else {
            rttr.addFlashAttribute("errorMessage", "기업 문의글 답변 등록/수정에 실패했습니다.");
        }
        // *** 상세보기 리다이렉트 시 페이징 정보 유지 ***
        rttr.addAttribute("bno", dto.getBno());
        rttr.addAttribute("nowPage", pageDTO.getNowPage());
        rttr.addAttribute("cntPerPage", pageDTO.getCntPerPage());
        if (pageDTO.getSearchType() != null) rttr.addAttribute("searchType", pageDTO.getSearchType());
        if (pageDTO.getKeyword() != null) rttr.addAttribute("keyword", pageDTO.getKeyword());
        return "redirect:/bqview"; // 경로 변경
    }
}