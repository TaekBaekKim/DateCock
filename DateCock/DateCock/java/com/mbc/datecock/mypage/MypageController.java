package com.mbc.datecock.mypage;

import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mbc.datecock.business.BusinessDTO;
import com.mbc.datecock.datecourse.DateCourseDTO;
import com.mbc.datecock.member.MemberDTO;

@Controller
public class MypageController {

	@Autowired
    SqlSession sqlsession;

    @RequestMapping("/businessmypage")
    public String myinfo() {
      
        return "businessmypage";
    }
    
    @RequestMapping("/mypage")
    public String mypage(Model model, HttpServletRequest request, RedirectAttributes ra) {
        String id = (String) request.getSession().getAttribute("id");
        
        if (id == null || id.isBlank()) {
            ra.addFlashAttribute("errorMessage", "세션이 만료되었습니다. 다시 로그인해주세요.");
            return "redirect:/main"; // 로그인 페이지로 튕기기
        }

        MypageService service = sqlsession.getMapper(MypageService.class);
        ArrayList<DateCourseDTO> allReservations = service.select(id);

        // 오늘 이후 예약 필터
        ArrayList<DateCourseDTO> upcomingReservations = new ArrayList<>();
        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
        for (DateCourseDTO r : allReservations) {
            if (r.getDay().compareTo(today) >= 0) {
                upcomingReservations.add(r);
            }
        }

        model.addAttribute("list", upcomingReservations);
        model.addAttribute("upcomingReservations", !upcomingReservations.isEmpty());

        return "mypage";
    }

    
    @RequestMapping("/details")
    public String details(Model model, HttpServletRequest request) {
        String businessname = request.getParameter("businessname");
        String id = request.getParameter("id");
        Date day =Date.valueOf(request.getParameter("day"));
        MypageService service = sqlsession.getMapper(MypageService.class);
        
        BusinessDTO dto = service.businessinputselect(businessname);
        ArrayList<DateCourseDTO>  list = service.datereservationselect(id,businessname,day);
        model.addAttribute("dto",dto); // 가게목록
        model.addAttribute("list", list); //예약목록
        return "datecoursedetails";
    }
    
    @ResponseBody
    @RequestMapping(value = "reservationdelete", method = RequestMethod.POST)
    public String reservationdelete(HttpServletRequest request) {
        String name = request.getParameter("name");
        Date day=Date.valueOf(request.getParameter("day"));
        String businessname= request.getParameter("businessname");
        // Service 레이어 호출
        MypageService service = sqlsession.getMapper(MypageService.class);
        int deleted = service.datelistdelete(name,day,businessname);  // 삭제 행 수 리턴

        if (deleted > 0) {
            return "success";
        } else {
            return "fail";
        }
    }
    
    @RequestMapping("/datelist")
    public String pastdates(Model model, HttpServletRequest request) {
        String id = (String) request.getSession().getAttribute("id");
        MypageService service = sqlsession.getMapper(MypageService.class);
        
        ArrayList<DateCourseDTO> allReservations = service.select(id);
       
        // 오늘 이전의 예약만 추출
        ArrayList<DateCourseDTO> pastReservations = new ArrayList<>();
        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
        for (DateCourseDTO r : allReservations) {
            if (r.getDay().compareTo(today) < 0) { // 오늘 이전 날짜만
                pastReservations.add(r);
            }
        }

        model.addAttribute("list", pastReservations);
        return "datelist";  
    }
    
    @RequestMapping(value="/userdelete")
    public String userdelete(Model mo, HttpServletRequest request) {
    	
    	String id = (String) request.getSession().getAttribute("id");
    	MypageService ms = sqlsession.getMapper(MypageService.class);
    	
    	String email = ms.getuseremail(id);
    	mo.addAttribute("email",email);
    	
    	return "userdelete";
    }
    
    @RequestMapping(value="/userdelete1")
    public String userdelete1(HttpSession session, RedirectAttributes ra, MemberDTO dto, HttpServletRequest request) {
        
        String id = (String) session.getAttribute("id");
        
        System.out.println("세션에서 꺼낸 ID: " + id);
        
        MypageService ms = sqlsession.getMapper(MypageService.class);
        ms.userinfodelete(id);
        
        session.invalidate();
        
        return "redirect:/main";
    }

    @RequestMapping(value="/usermodify")
    public String usermodify(HttpSession session, Model mo) {
    	
    	String id = (String) session.getAttribute("id");
    	
    	MypageService ms =sqlsession.getMapper(MypageService.class);
    	UsermypageDTO dto = ms.userinfomodifyview(id);
    	
    	mo.addAttribute("user",dto);
    	return "usermodify";
    }
    
    @RequestMapping(value="/usermodify1")
    public String usermodify1(UsermypageDTO dto, Model mo, RedirectAttributes ra) {
    	String id=dto.getId();
    	String name=dto.getName();
    	String email=dto.getEmail();
    	String phone=dto.getPhone();
    	
    	MypageService ms = sqlsession.getMapper(MypageService.class);
    	ms.userinfomodify(dto);
    	
    	ra.addFlashAttribute("successMessage", "회원 정보가 성공적으로 변경되었습니다.");
    	
    	return "redirect:/mypage";
    }
    
    @RequestMapping(value="/userpwmodify")
    public String userpwmodify(HttpSession session) {
        String businessnumber = (String) session.getAttribute("businessnumberA"); // 이거 쓸 거면 쓰고, 아니면 삭제해도 됨
        return "userpwmodify";
    }

    @RequestMapping(value="/userpwmodify1", method = RequestMethod.POST)
    public String userpwmodify1(HttpServletRequest request, HttpSession session, RedirectAttributes ra) {

        String id = (String) session.getAttribute("id");

        if (id == null) {
            ra.addFlashAttribute("errorMessage", "세션이 만료되었습니다. 다시 로그인해주세요.");
            return "redirect:/userpwmodify";
        }

        String currentPwd = request.getParameter("pwd");
        String newPwd = request.getParameter("newpwd");
        String newPwdConfirm = request.getParameter("newpwd_confirm");

        MypageService ms = sqlsession.getMapper(MypageService.class);
        String getPassword = ms.getuserpw(id);  // 기존 암호화 비밀번호 조회

        if (getPassword == null) {
            ra.addFlashAttribute("errorMessage", "비밀번호 조회에 실패했습니다.");
            return "redirect:/userpwmodify";
        }

        BCryptPasswordEncoder pe = new BCryptPasswordEncoder();

        if (currentPwd == null || !pe.matches(currentPwd, getPassword)) {
            ra.addFlashAttribute("errorMessage", "현재 비밀번호가 일치하지 않습니다.");
            return "redirect:/userpwmodify";
        }

        if (newPwd == null || newPwdConfirm == null || !newPwd.equals(newPwdConfirm)) {
            ra.addFlashAttribute("errorMessage", "새 비밀번호와 확인이 일치하지 않습니다.");
            return "redirect:/userpwmodify";
        }

        if (!newPwd.matches(".*[!@#$%^&*(),.?\":{}|<>].*")) {
            ra.addFlashAttribute("errorMessage", "비밀번호는 특수문자를 1개 이상 포함해야 합니다.");
            return "redirect:/userpwmodify";
        }

        String encodedNewPassword = pe.encode(newPwd);

        // 🔥 map 방식 적용
        Map<String, String> map = new HashMap<>();
        map.put("id", id);
        map.put("encodedNewPassword", encodedNewPassword);

        System.out.println("ID: " + id);
        System.out.println("ENCODED PW: " + encodedNewPassword);
        
        ms.userpwmodifyRaw(map); // map 넘김

        System.out.println("map.get(id): " + map.get("id"));
        System.out.println("map.get(encodedNewPassword): " + map.get("encodedNewPassword"));
        
        session.invalidate();

        ra.addFlashAttribute("successMessage", "비밀번호가 성공적으로 변경되었습니다. 다시 로그인 해주세요.");
        return "redirect:/memberinput";
    }
	
	@RequestMapping(value="/businessmanual")
	public String myinfomanual() {
		
		return "businessmanual";
	}
	
	@RequestMapping(value="/businessnotice")
	public String myinfonotice() {
		
		return "businessnotice";
	}
	
	@RequestMapping(value="/businessdelete") //탈퇴할 사업자의 이메일 보내주기
	public String myinfodelete1(Model mo,HttpServletRequest request) {
		
		String businessnumber = (String) request.getSession().getAttribute("businessnumberA");
		
		MypageService ms = sqlsession.getMapper(MypageService.class);
		String email = ms.getbusinessemail(businessnumber);
		
		mo.addAttribute("email",email);
		
		return "businessdelete";
	}
	
	@RequestMapping(value="/businessdelete1")
	public String myinfodelete2(MypageDTO dto,HttpSession session,HttpServletRequest request) {
		
		String businessnumber = (String) request.getSession().getAttribute("businessnumberA");
		MypageService bs=sqlsession.getMapper(MypageService.class);
		
		bs.businessinfodelete(businessnumber);
			
		 HttpSession hs = request.getSession();
		 hs.removeAttribute("buisnessloginstate");
         hs.removeAttribute("businessnumberA");
         hs.removeAttribute("businessname");
		return "redirect:/main";
	}
	
	@RequestMapping(value="/businessmodify")
	public String myinfomodify1(HttpSession session, Model mo) {
		String businessnumber=(String) session.getAttribute("businessnumberA");
		
		MypageService bs=sqlsession.getMapper(MypageService.class);
		MypageDTO dto= bs.businessinfomodifyview(businessnumber);
		
		mo.addAttribute("business",dto);
		return "businessmodify";
	}
	
	@RequestMapping(value="/businessmodify1")
	public String myinfomodify2(MypageDTO dto, Model mo, RedirectAttributes ra) {
		String businessnumber=dto.getBusinessnumber();
		String businessname=dto.getBusinessname();
		String email=dto.getEmail();
		String phone=dto.getPhone();
		
		MypageService bs=sqlsession.getMapper(MypageService.class);
		bs.businessinfomodify(dto);
		
		ra.addFlashAttribute("successMessage", "회원 정보가 성공적으로 변경되었습니다.");
		
		return "redirect:/businessmypage";
	}
	
	@RequestMapping(value="/businesspwmodify", method = RequestMethod.GET) //비밀번호 변경
	public String myinfopwmodify(HttpSession session) {
	    String businessnumber = (String) session.getAttribute("businessnumberA");
	    
	    if (businessnumber == null || businessnumber.isBlank()) {
	        return "redirect:/login"; // 세션 없으면 로그인으로 튕김
	    }
	    return "businesspwmodify"; // Tiles 이름. businesspwmodify.jsp 보여줌
	}
	
	@RequestMapping(value="/businesspwmodify", method = RequestMethod.POST)
	public String myinfopwmodify2(MypageDTO dto, HttpSession session, RedirectAttributes ra) {
	    

	    String businessnumber = (String) session.getAttribute("businessnumberA");

	    if (businessnumber == null) {
	        ra.addFlashAttribute("errorMessage", "세션이 만료되었습니다. 다시 로그인해주세요.");
	        return "redirect:/businesspwmodify";
	    }

	    dto.setBusinessnumber(businessnumber);
	   
	    MypageService bs = sqlsession.getMapper(MypageService.class);
	    String getPassword = bs.getbusinesspw(businessnumber);
	    
	    if (getPassword == null) {
	        ra.addFlashAttribute("errorMessage", "비밀번호 조회에 실패했습니다.");
	        return "redirect:/businesspwmodify";
	    }

	    BCryptPasswordEncoder pe = new BCryptPasswordEncoder();

	    if (dto.getPassword() == null || !pe.matches(dto.getPassword(), getPassword)) {
	        ra.addFlashAttribute("errorMessage", "현재 비밀번호가 일치하지 않습니다.");
	        return "redirect:/businesspwmodify";
	    }


	    if (dto.getBusinessnewpw() == null || dto.getBusinessnewpw_confirm() == null ||
	    	    !dto.getBusinessnewpw().equals(dto.getBusinessnewpw_confirm())) {
	    	    ra.addFlashAttribute("errorMessage", "새 비밀번호와 확인이 일치하지 않습니다.");
	    	    return "redirect:/businesspwmodify";
	    	}

	    if (!dto.getBusinessnewpw().matches(".*[!@#$%^&*(),.?\":{}|<>].*")) {
	       
	        ra.addFlashAttribute("errorMessage", "비밀번호는 특수문자를 1개 이상 포함해야 합니다.");
	        return "redirect:/businesspwmodify";
	    }

	    String encodenewpassword = pe.encode(dto.getBusinessnewpw());
	    dto.setPassword(encodenewpassword);

	    bs.businesspwmodify(dto);

	    session.invalidate(); // 세션 끊기

	    ra.addFlashAttribute("successMessage", "비밀번호가 성공적으로 변경되었습니다. 다시 로그인 해주세요.");
	    return "redirect:/businesssignup";
	}


}