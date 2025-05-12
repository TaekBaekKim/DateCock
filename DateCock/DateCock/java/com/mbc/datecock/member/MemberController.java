package com.mbc.datecock.member;
import java.security.SecureRandom;
import java.util.HashMap; // Map 사용 위해 import
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mbc.datecock.login.LoginService;

@Controller
public class MemberController{
	@Autowired
	SqlSession sqlSession;
	@Autowired
    private JavaMailSender mailSender;
	
@RequestMapping(value = "/memberinput", method = RequestMethod.GET)
public String memIn(Model model) {
	model.addAttribute("notop", true);
	return "signup";
	
	
}
@RequestMapping(value = "/membersearch", method = RequestMethod.GET)
public String showMSearchPage() {
    // 필요한 로직 추가 가능
    return "msearch"; // "/WEB-INF/views/msearch.jsp" 파일을 보여주도록 설정 가정
}


@RequestMapping(value = "/searchid", method = RequestMethod.POST)
public String searchId( Model model,MemberDTO dto) {
	 if (dto.getSearchname() == null || dto.getSearchname().trim().isEmpty() ||
	            dto.getSearchemail() == null || dto.getSearchemail().trim().isEmpty()) {
	             model.addAttribute("idSearchError", "이름과 이메일을 모두 입력해주세요.");
	             return "msearch"; // 다시 입력 폼 보여주기
	        }
	try {
		MemberService ms = sqlSession.getMapper(MemberService.class);
		System.out.println("DB 조회 전 이름: " + dto.getSearchname());
		System.out.println("DB 조회 전 이메일: " + dto.getSearchemail());
		String foundMemberId = ms.findMemberId(dto);
		System.out.println("찾은 후 아이디:"+foundMemberId);
		if(foundMemberId != null&& !foundMemberId.isEmpty()){
			model.addAttribute("foundId",foundMemberId);
		}
		else {
			model.addAttribute("error","입력하신 정보와 일치하는 아이디가 없음");
		}

	} catch (Exception e) {
		model.addAttribute("msg", "오류가 발생되었습니다.");
		e.printStackTrace();
	}
	return "idResult";
}

@ResponseBody
@RequestMapping(value = "/idcheck2" ,method = RequestMethod.POST)
public String signUp1(String id) {
	MemberService ms = sqlSession.getMapper(MemberService.class);
	String bigo = ""; // 기존 변수명 유지
    try {
        int count = ms.idcheck(id);
        if (count == 1) {
            bigo = "no";
        } else {
            bigo = "yes";
        }
    } catch (Exception e) {
        System.err.println("ID Check Error: " + e.getMessage()); // 오류 로그 출력
        bigo = "no"; // 오류 발생 시 기본적으로 사용 불가("no") 처리
    }
    return bigo;
}

@RequestMapping(value = "/membersave", method = RequestMethod.POST)
public String save(MemberDTO dto,RedirectAttributes redirectAttributes) {
	try {
        String id = dto.getId();
        String pwd = dto.getPwd(); // 사용자가 입력한 평문 비밀번호
        String pwdConfirm = dto.getPwd_confirm();
        String email = dto.getEmail();
        String name = dto.getName();
        String birth = dto.getBirth();
        String phone = dto.getPhone();
        
        
        String specialCharPattern = ".*[!@#$%^&*(),.?\":{}|<>].*"; // 예시: 최소 1개의 지정된 특수문자 포함

        if (pwd == null || pwd.isEmpty() || !pwd.matches(specialCharPattern)) {
             redirectAttributes.addFlashAttribute("errorMessage", "비밀번호는 특수문자(!@#$%^&* 등)를 1개 이상 포함해야 합니다.");
             return "redirect:/memberinput"; // 형식 오류 시 리다이렉트
        }
        
        if (pwd == null || pwdConfirm == null || pwd.isEmpty() || !pwd.equals(pwdConfirm)) {
            // 오류 메시지를 Flash Attribute로 추가 (리다이렉트 후 JSP에서 사용 가능)
            redirectAttributes.addFlashAttribute("errorMessage", "비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
            // 회원가입 폼으로 리다이렉트
            return "redirect:/memberinput";
        }
     // ★★★ admin 값 설정 ★★★
        int admin = 0; // 일반 사용자는 0
        

        MemberService ms = sqlSession.getMapper(MemberService.class);
        PasswordEncoder pe = new BCryptPasswordEncoder(); // 기존 방식대로 인스턴스 생성 유지

        // --- 중요: 비밀번호 암호화 ---
        pwd = pe.encode(pwd); // 비밀번호를 암호화

        // DB 저장 시 암호화된 비밀번호 전달
        ms.insertm(id,pwd, email, name, birth, phone, admin); // encodedPassword 전달 (수정)

    } catch (Exception e) {
         // DB 저장 오류 시 처리
        
        return "redirect:/memberinput?error=true"; // 오류 시 다시 회원가입 폼으로
    }
    // 성공 시 메인 페이지로 이동
    return "redirect:/";
}

@RequestMapping(value = "/checkMemberExists", method = RequestMethod.POST)
@ResponseBody // 반환값을 JSON 응답 본문으로 처리
public CheckMember checkMemberExistsUsingDto(
		@RequestParam("findid") String id,
		@RequestParam("loginPw") String email){//반환 타입을 checkMemberfh qkRna
	
	 System.out.println("[/checkMemberExists] Received ID: " + id + ", Email(loginPw): " + email);
	
	boolean memberExists = false;
	String message = "";
	
	if (id == null || id.trim().isEmpty() || email == null || email.trim().isEmpty()) {
        // DTO 객체를 생성하여 실패 결과 반환
        return new CheckMember(false, "아이디와 이메일을 모두 입력해주세요.");
   }
	
	try {
		MemberService ls = sqlSession.getMapper(MemberService.class);
		Map<String,Object> params = new HashMap<>();
		params.put("id",id);
		params.put("email",email);
		int cnt = ls.checkMemberOk(params);
		
		if (cnt > 0) {
            memberExists = true;
            message = "회원 정보가 확인되었습니다.";
            System.out.println("일치함을 확인");
        } else {
            memberExists = false;
            message = "입력하신 정보와 일치하는 회원이 없습니다.";
        }

    } catch (Exception e) {
        System.err.println("[/checkMemberExists] Error: " + e.getMessage());
        e.printStackTrace();
        memberExists = false; // 예외 발생 시에도 실패로 간주
        message = "회원 확인 중 오류가 발생했습니다.";
    }
	 
	 
	return new CheckMember(memberExists, message);
		
}
//--- (신규) 비밀번호 찾기: 인증번호 발송 처리 (AJAX) -
@RequestMapping(value = "/sendVerificationCode", method = RequestMethod.POST)
@ResponseBody //json 응답 반환
public Map<String, Object> sendVerificationCode(@RequestParam("findid") String id,@RequestParam("loginPw") String email,HttpSession session){
		Map<String,Object> response = new HashMap<>();
		System.out.println("[/sendVerificationCode] Request for ID: " + id + ", Email: " + email);
		boolean sent  = false;
		// --- (수정!) AJAX 응답용 메시지 변수 ---
        String rmessage = ""; // 초기화
		try {
			Random random = new Random();
			int code = 10000+ random.nextInt(900000);
			String vfcode = String.valueOf(code);
			System.out.println("[/sendVerificationCode] Generated Code: " + vfcode + " for Email: " + email);

            // ---------------------------------------------------------
            // TODO: [필수] 실제 이메일 발송 로직 구현 부분
            // ---------------------------------------------------------
            // JavaMailSender 등을 사용하여 email 변수(수신자)에게 verificationCode(인증번호)를 포함한 메일 발송
            // 예시: boolean emailSent = emailService.sendVerificationEmail(email, verificationCode);
            // 아래는 임시로 성공 처리
			 // <-- 반드시 실제 발송 로직으로 대체해야 합니다!
			try {
                SimpleMailMessage message = new SimpleMailMessage();
                message.setTo(email); // 받는 사람 이메일 주소 설정
                message.setSubject("[DateCock] 비밀번호 찾기 인증번호입니다."); // 메일 제목
                message.setText("요청하신 인증번호는 [" + vfcode + "] 입니다. 3분 안에 입력해주세요."); // 메일 내용
                // message.setFrom("보내는사람@example.com"); // 필요 시 보내는 사람 설정 (mailSender 빈 설정에 따라 생략 가능)

                mailSender.send(message); // 메일 발송!
                sent = true; // 예외 없이 성공하면 true
                System.out.println("[/sendVerificationCode] Email sent successfully to " + email);

            } catch (MailException mailEx) { // 메일 발송 관련 예외 처리
            	
                 System.err.println("[/sendVerificationCode] Email Sending Error: " + mailEx.getMessage());
                 // mailEx.printStackTrace(); // 상세 로그 필요 시
                 sent = false;
                 rmessage = "인증번호 이메일 발송 중 오류가 발생했습니다. 메일 주소를 확인하거나 잠시 후 다시 시도해주세요.";
            }
			if(sent) {
				long expiry = System.currentTimeMillis() + (3 * 60 * 1000); // 현재 시간 + 3분
				session.setAttribute("verificationCode"+email, vfcode);
				session.setAttribute("verificationExpiry"+email, expiry);
				session.setAttribute("verificationEmail", email);
				System.out.println("[/sendVerificationCode] Code stored in session for email: " + email);
                response.put("success", true);
                response.put("message", "인증번호가 이메일로 발송되었습니다. 3분 안에 입력해주세요.");
			}
		 else {
            response.put("success", false);
            response.put("message", "인증번호 이메일 발송에 실패했습니다. 잠시 후 다시 시도해주세요.");
        }
		}
		catch(Exception e){
			System.err.println("[/sendVerificationCode] Error: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "인증번호 발송 중 오류가 발생했습니다.");
		}
		return response; // JSON으로 변환되어 응답됨
}	

// --- (필수 추가!) 인증번호 확인 처리 메소드 ---
@RequestMapping(value = "/checkVerificationCode", method = RequestMethod.POST)
@ResponseBody // JSON 응답 반환
public Map<String, Object> checkVerificationCode(
        @RequestParam("code") String inputCode,     // 사용자가 입력한 인증번호 (JS data key: 'code')
        @RequestParam("loginPw") String email,    // 해당 이메일 주소 (JS data key: 'loginPw')
        HttpSession session) {                  // 세션에서 저장된 정보 조회

    Map<String, Object> response = new HashMap<>();
    System.out.println("[/checkVerificationCode] Received Code: '" + inputCode + "' for Email: " + email);

    // 세션에서 저장된 인증번호, 이메일, 만료 시간 가져오기
    String storedCode = (String) session.getAttribute("verificationCode" + email);
    String sessionEmail = (String) session.getAttribute("verificationEmail"); // 발송 시 저장한 이메일 확인용
    Long expiryTime = (Long) session.getAttribute("verificationExpiry" + email);

    boolean verified = false;
    String message = "";

    // 1. 세션 정보 유효성 및 시간 만료 체크
    if (storedCode == null || expiryTime == null || sessionEmail == null || !sessionEmail.equals(email)) {
        message = "인증번호 발송 정보가 유효하지 않습니다. 다시 발송해주세요.";
        System.out.println("[/checkVerificationCode] Verification failed: Session data invalid or missing.");
    } else if (System.currentTimeMillis() > expiryTime) {
        message = "인증 시간이 만료되었습니다. 인증번호를 다시 발송해주세요.";
        System.out.println("[/checkVerificationCode] Verification failed: Code expired.");
        // 만료 시 세션 정보 삭제
        session.removeAttribute("verificationCode" + email);
        session.removeAttribute("verificationExpiry" + email);
        session.removeAttribute("verificationEmail");
        session.removeAttribute("pwdResetVerified" + email); // 인증 상태도 초기화
    } else if (storedCode.equals(inputCode)) {
        // 2. 인증번호 일치!
        verified = true;
        message = "인증되었습니다.";
        System.out.println("[/checkVerificationCode] Verification SUCCESS for email: " + email);
        // !!! 중요: 인증 성공 상태를 세션에 저장 !!!
        session.setAttribute("pwdResetVerified" + email, true);
        // (선택) 성공 후 인증번호 정보 즉시 삭제 (1회용으로 만들 경우)

    } else {
        // 3. 인증번호 불일치
        message = "인증번호가 올바르지 않습니다.";
        System.out.println("[/checkVerificationCode] Verification failed: Code mismatch.");
    }

    response.put("verified", verified); // 인증 성공 여부 (true/false)
    response.put("message", message);  // 결과 메시지

    return response; // JSON으로 변환되어 응답
}


@RequestMapping(value = "/searchpwd", method = RequestMethod.POST)
public String searchPwd( @RequestParam("findid") String id,
                         @RequestParam("loginPw") String email, // JS에서 'loginPw' key로 이메일 전송
                         HttpSession session,
                         RedirectAttributes redirectAttributes,
                         Model model) { // 결과를 다음 페이지로 전달하기 위해 Model 사용

    System.out.println("[/searchpwd] Final password reset request for ID: " + id + ", Email: " + email);

    // --- 1. 세션 속성 가져오기 (수정: 정확한 키 이름 사용) ---
    Boolean isVerified = (Boolean) session.getAttribute("pwdResetVerified" + email); // "pwdResetVerified" 사용
    String storedEmail = (String) session.getAttribute("verificationEmail");

    // --- 2. 인증 상태 확인 (수정: storedEmail null 체크 추가) ---
    if (isVerified == null || !isVerified || storedEmail == null || !email.equals(storedEmail)) {
        redirectAttributes.addFlashAttribute("pwdSearchError", "이메일 인증이 완료되지 않았거나 유효하지 않습니다. 처음부터 다시 시도해주세요.");

        // --- 리다이렉트 경로 수정: GET 요청 가능한 아이디/비번찾기 페이지로 ---
        return "redirect:/membersearch?tab=2"; // (이 경로가 실제 GET 매핑과 일치하는지 확인!)
    }

    // --- 3. 인증 성공 확인 후 세션 속성 제거 (수정: 제거 시점 및 정확한 키 이름 사용) ---
    session.removeAttribute("pwdResetVerified" + email); // "pwdResetVerified" 사용
    session.removeAttribute("verificationCode" + email);
    session.removeAttribute("verificationExpiry" + email);
    session.removeAttribute("verificationEmail");

    // --- 4. 비밀번호 재설정 로직 (try-catch 사용) ---
    try {
        MemberService ms = sqlSession.getMapper(MemberService.class); // MemberService 인터페이스 가정
        PasswordEncoder pe = new BCryptPasswordEncoder();

        // 4a. 임시 비밀번호 생성
        String tmpPwd = generateTemporaryPassword(10); // 아래 helper 메소드 사용

        // 4b. 임시 비밀번호 해싱 (DB 저장용)
        String newEncodedPwd = pe.encode(tmpPwd);

        // 4c. DB에 암호화된 임시 비밀번호로 업데이트
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        params.put("newPwd", newEncodedPwd); // Mapper에서 사용할 파라미터 이름 확인 필요
        int updateCnt = ms.updatePassword(params); // MemberService에 updatePassword 메소드 필요 가정

        // 4d. DB 업데이트 결과에 따라 Model에 정보 담기
        if (updateCnt > 0) {
            // DB 업데이트 성공
            model.addAttribute("tempPasswordGenerated", true);
            model.addAttribute("targetUserId", id);
            model.addAttribute("temporaryPassword", tmpPwd); // 평문 임시 비밀번호 (화면 표시용)
            System.out.println("[/searchpwd] Password updated successfully for ID: " + id);
        } else {
            // DB 업데이트 실패 (해당 아이디가 없거나 업데이트 실패)
            model.addAttribute("pwdSearchErrorOnResult", "비밀번호 업데이트에 실패했습니다. 사용자 정보를 확인해주세요.");
            System.out.println("[/searchpwd] Password update failed for ID: " + id + " (updateCnt=0)");
        }
    } catch (Exception e) {
        // 4e. 예외 발생 시 처리
        System.err.println("[/searchpwd] Exception during password update for ID: " + id + ", Email: " + email);
        e.printStackTrace();
        model.addAttribute("msg", "비밀번호 처리 중 오류가 발생했습니다. 관리자에게 문의하세요.");
        // 오류 발생 시에도 결과 페이지("passwordResult")로 이동
        return "pwdResult"; // 명시적으로 추가 (없어도 마지막 return으로 동작은 함)
    }

    // 5. 비밀번호 찾기 결과 페이지 이름 반환 ("pwdResult"가 JSP 파일 이름과 일치)
    return "pwdResult";
}
//임시 비밀번호 생성 Helper 메소드
private String generateTemporaryPassword(int length) {
    String upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String lower = "abcdefghijklmnopqrstuvwxyz";
    String digits = "0123456789";
    String special = "!@#$%^&*";
    String allChars = upper + lower + digits + special;
    Random random = new SecureRandom();
    StringBuilder sb = new StringBuilder(length);
    for (int i = 0; i < length; i++) {
        sb.append(allChars.charAt(random.nextInt(allChars.length())));
    }
    return sb.toString();
}

}