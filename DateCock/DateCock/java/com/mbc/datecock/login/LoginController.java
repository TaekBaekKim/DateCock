package com.mbc.datecock.login;

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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.mbc.datecock.login.LoginService;
import com.mbc.datecock.member.MemberDTO;
@Controller
public class LoginController {
	@Autowired
	SqlSession sqlSession;
	
	@RequestMapping(value="/loginprocess",method = RequestMethod.POST)
	public String log2(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String id = request.getParameter("loginId");
		String pw = request.getParameter("loginPw");
		LoginService ls = sqlSession.getMapper(LoginService.class);
		String cpw = ls.pwselect(id); //암호화된 패스워드를 가지고 왔음
		String name = ls.nameselect(id);
		
		PasswordEncoder pe = new BCryptPasswordEncoder();
		boolean flag = pe.matches(pw,cpw); // 암호화된 패스워드와 로그인한 패스워드를 비교
		if(flag)
		{	
			
			
			Integer adminStatus = ls.getAdminStatus(id);
			Boolean isAdmin = (adminStatus != null && adminStatus ==1);
			HttpSession hs = request.getSession();
			hs.setAttribute("personalloginstate", true);
			hs.setAttribute("personalloginstate2", true);
			hs.setAttribute("id", id);
			hs.setAttribute("name", name);
			hs.setAttribute("userType", "personal"); // ★★★ 일반 사용자 유형 설정 ★★★
			hs.setAttribute("isAdmin", isAdmin);
			
			
			return "redirect:/loginmain";
		}
		else {
			response.setContentType("text/html;charset=utf-8");
			PrintWriter pww = response.getWriter();
			pww.print("<script>alert('비밀번호가 일치하지않습니다.');</script>");
			pww.print("<script>location.href='memberinput';</script>");
			pww.close();
			
			
			return "redirect:/signup";
		}
		
	}
	
	@RequestMapping(value="/logout")
	public String log33(HttpServletRequest request) {
		
			HttpSession hs = request.getSession();
			hs.removeAttribute("personalloginstate");
			hs.removeAttribute("personalloginstate2");
			hs.removeAttribute("name");
			hs.removeAttribute("id");
			hs.removeAttribute("likedPostsMap");
			hs.removeAttribute("userType"); // ★★★ 로그아웃 시 userType 세션 속성 제거 추가 ★★★
			// ★★★ 추가된 코드: isAdmin 세션 속성 제거 ★★★
            hs.removeAttribute("isAdmin");
            // ★★★ --- ★★★
			hs.invalidate();
			 System.out.println("세션무효화 성공");
			 return "redirect:/";
		}
	
}
