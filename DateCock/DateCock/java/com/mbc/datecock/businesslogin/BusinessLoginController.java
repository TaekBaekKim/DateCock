package com.mbc.datecock.businesslogin;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.mbc.datecock.business.BusinessService;

@Controller
public class BusinessLoginController {

	@Autowired
	SqlSession sqlsession;
	
	@RequestMapping(value="/login")
	public String log1() {
		
		return "login";
	}
	
	@RequestMapping(value="/bisinessloginprocess")
	   public String log2(HttpServletRequest request, HttpServletResponse response) throws IOException {
	      String businessnumber = request.getParameter("businessnumberA"); //사업자 등록번호
	      String businesspw = request.getParameter("businesspwA"); //사업자 비밀번호
	      
	      
	      BusinessLoginService ls = sqlsession.getMapper(BusinessLoginService.class);
	      String cpw = ls.pwselect(businessnumber); //암호화된 패스워드를 가지고 왔음
	      String businessname = ls.nameselect(businessnumber);
	      
	      PasswordEncoder pe = new BCryptPasswordEncoder();
	      boolean flag = pe.matches(businesspw,cpw); // 암호화된 패스워드와 로그인한 패스워드를 비교
	      
	      //디버그 코드임
	      if (cpw == null) {
	          
	          response.setContentType("text/html;charset=utf-8");
	          PrintWriter pww = response.getWriter();
	          pww.print("<script>alert('존재하지 않는 사업자번호입니다.'); location.href='businesssignup';</script>");
	          pww.close();
	          return null; // 더이상 진행 안함
	      }
	      //디버그 코드 여기까지
	      
	      if(flag)
	      {
	    	
	         HttpSession hs = request.getSession();
	        
	         hs.removeAttribute("isAdmin"); // 관리자 플래그 제거
	         hs.removeAttribute("id");      // 일반/관리자 ID 제거
	         hs.removeAttribute("name");    // 일반 회원 이름 제거 (혹시 모를 충돌 방지)
	         hs.removeAttribute("personalloginstate"); // 일반 회원 로그인 상태 제거
	         hs.removeAttribute("personalloginstate2");
	         hs.removeAttribute("userType"); // 이전 userType 제거
	         // *** --------------------------- ***

	         // 기업 회원 속성 설정
	         hs.setAttribute("buisnessloginstate", true); // 오타 유지
	         hs.setAttribute("businessnumberA", businessnumber);
	         hs.setAttribute("businessname", businessname);
	         hs.setAttribute("userType", "business"); // 사용자 유형 설정
	         
	         return "redirect:/loginmain";
	      }
	      else {
	    	
	         response.setContentType("text/html;charset=utf-8");
	         PrintWriter pww = response.getWriter();
	         pww.print("<script>alert('비밀번호가 일치하지 않습니다.'); location.href='businesssignup';</script>");
	         pww.close();
	         
	         
	         return "redirect:/businesssignup";
	      }
	      
	   }
	
	@RequestMapping(value="/businesslogout")
	   public String log33(HttpServletRequest request) {
	      
	         HttpSession hs = request.getSession();
	         hs.removeAttribute("buisnessloginstate");
	         hs.removeAttribute("businessnumberA");
	         hs.removeAttribute("businessname");
	         hs.removeAttribute("userType"); // ★★★ 기업 사용자 유형 세션 제거 추가 ★★★
	         hs.invalidate();
	         return "redirect:/main";
	      }
}
