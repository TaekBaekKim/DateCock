package com.mbc.datecock.businessmember;

import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class BusinessMemberController {
	
@Autowired
SqlSession sqlsession;

@Autowired
private JavaMailSender mailSender;


@RequestMapping(value="/businesssignup") //사업자 회원가입
public String businesssignup(Model model) {
	model.addAttribute("notop", true);
	return "businesssignup";
}

@RequestMapping(value="/businessmembersave" , method=RequestMethod.POST)
public String businesssave1(BusinessMemberDTO dto,RedirectAttributes redirectAttributes) {
	try {
	String businessnumber=dto.getBusinessnumber();
	String password=dto.getPassword();
	String password_confirm=dto.getPassword_confirm();
	String email=dto.getEmail();
	String businessname=dto.getBusinessname();
	String phone=dto.getPhone();
	String birthyear=dto.getBirthyear();
	
	
	//추가
    String specialCharPattern = ".*[!@#$%^&*(),.?\":{}|<>].*"; 
    
    if (password == null || password.isEmpty() || !password.matches(specialCharPattern)) {
    	redirectAttributes.addFlashAttribute("errorMessage", "비밀번호는 특수문자(!@#$%^&* 등)를 1개 이상 포함해야 합니다.");
    	return "redirect:/businesssignup"; // 형식 오류 시 리다이렉트
    	}
    //추가 끝
	
	if(password==null || password_confirm == null || password.isEmpty() || !password.equals(password_confirm)) {
		redirectAttributes.addFlashAttribute("errorMessage","비밀번호가 일치하지 않습니다, 다시 입력해주세요.");
		return "redirect:/businesssignup";
	}
	
	BusinessMemberService bs=sqlsession.getMapper(BusinessMemberService.class);
	PasswordEncoder pe = new BCryptPasswordEncoder();
	
	password=pe.encode(password);
	bs.businessinsert(businessnumber,password,email,businessname,phone,birthyear);
	
	} catch (Exception e){
		
		return "redirect:/businesssignup?error=true"; //오류 시 다시 회원가입 폼으로
	}
		return "redirect:/loginmain"; //성공 시 메인 페이지로 이동
	}

	@ResponseBody
	@RequestMapping(value="/businessnumbercheck2", method=RequestMethod.POST)
	public String businessnumbercheck2(BusinessMemberDTO dto, String businessnumber, RedirectAttributes redirectAttributes) {
		BusinessMemberService bs=sqlsession.getMapper(BusinessMemberService.class);
		String bigo = ""; //기존 변수명
		try {
			
	        int count = bs.businessnumbercheck(businessnumber);
	        
	        if (count == 1) {
	            bigo = "no";
	        } else {
	            bigo = "yes";
	        }
	        
	    } catch (Exception e) {
	        
	    	
	        bigo = "no"; // 오류 발생 시 기본적으로 사용 불가("no") 처리
	    }
	    return bigo;
	}
	
	//여기부터 사업자번호 찾기
	
	@RequestMapping(value = "/businessresult", method = RequestMethod.GET)
    public String searchm(Model mo) {
    	mo.addAttribute("notop",true);
        return "businessresult";
    }

	@RequestMapping(value = "/businessfindA", method = {RequestMethod.GET, RequestMethod.POST})
	public String searchId2(HttpServletRequest request,Model mo) {
		
		String businessname = request.getParameter("businessname");
		String email = request.getParameter("email");
		
		mo.addAttribute("notop",true);
		
	   
	    

	    BusinessMemberService bs = sqlsession.getMapper(BusinessMemberService.class);
	    try {
	        BusinessMemberDTO result = bs.findMemberId(businessname, email);

	        if (result != null) {
	            mo.addAttribute("findId", result);
	        } else {
	            mo.addAttribute("idSearchError", "해당 정보로 등록된 사업자가 없습니다.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        mo.addAttribute("idSearchError", "오류가 발생했습니다.");
	    }

	    mo.addAttribute("tab", "id");
	    return "businessresult";
	}

    //여기부터 pw찾기
    
    @ResponseBody //사업자 번호입력
    @RequestMapping(value = "/businessfindpwA", method = RequestMethod.POST)
    public String checkBusinessNumber(HttpSession session,HttpServletRequest request) {
    	String businessnumber=request.getParameter("businessnumber");
    	BusinessMemberService bs=sqlsession.getMapper(BusinessMemberService.class);
    	
        int exists = bs.samebusinessnumber(businessnumber); //사업자
        if (exists == 0) return "fail";
        session.setAttribute("businessnumber", businessnumber);
        return "success";
    }

    @ResponseBody //이메일 입력
    @RequestMapping(value = "/businessfindpwB", method = RequestMethod.POST)
    public String sendVerificationCode(HttpSession session, Model mo,HttpServletRequest request) {
    	
    	String businessnumber = (String) session.getAttribute("businessnumber");
    	String email = request.getParameter("email");
    	
    	
        BusinessMemberService bs=sqlsession.getMapper(BusinessMemberService.class);

        BusinessMemberDTO dto = new BusinessMemberDTO();
        dto.setBusinessnumber(businessnumber);
        dto.setEmail(email);

        int matched = bs.checkEmailMatch(dto);
        if (matched <= 0) return "nomatch";

        String code = generateVerificationCode();
        session.setAttribute("verificationCode", code);
        session.setAttribute("email", email);

        return sendVerificationEmail(email, code) ? "success" : "fail";
    }


    @ResponseBody
    @RequestMapping(value = "/businessfindpwC", method = RequestMethod.POST)
    public String verifyCode(HttpSession session, @RequestParam("inputCode") String inputCode) {
    	BusinessMemberService bs=sqlsession.getMapper(BusinessMemberService.class);
    	
        String sessionCode = (String) session.getAttribute("verificationCode");
        String businessnumber = (String) session.getAttribute("businessnumber");

        if (sessionCode == null || !sessionCode.equals(inputCode)) {
            return "invalid";
        }

        String tempPw = generateVerificationCode();
        String encryptedPw = new BCryptPasswordEncoder().encode(tempPw);

        BusinessMemberDTO dto = new BusinessMemberDTO();
        dto.setBusinessnumber(businessnumber);
        dto.setPassword(encryptedPw);

        int result = bs.updateTempPassword(dto);
        return result > 0 ? "tempPw:" + tempPw : "fail";
    }

    private String generateVerificationCode() {
        Random rand = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            sb.append(rand.nextInt(10));
        }
        return sb.toString();
    }

    private boolean sendVerificationEmail(String email, String code) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(email);
            helper.setSubject("[비밀번호 재설정] 인증번호 안내");
            helper.setText("<div>인증번호: <strong style='color:blue;'>" + code + "</strong><br>비밀번호는 운명이다.</div>", true);
            helper.setFrom("ehdtjr1578@gmail.com");

            mailSender.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
	
}

