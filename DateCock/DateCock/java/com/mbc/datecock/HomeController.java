package com.mbc.datecock;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller
public class HomeController {
	@RequestMapping(value = "/")
	public String home(Model model) {
		 model.addAttribute("notop", true); //  서브메인 화면 탑 제거
		 model.addAttribute("nofooter", true); // 서브메인 화면 풋터 제거
		 
		 
		 
		return "servemain";
		
		
	}
	@RequestMapping(value = "/main") //로그인 안 했을때 돌아가는 메인
	public String main(HttpServletRequest request) {
		HttpSession session = request.getSession();
		 session.setAttribute("personalloginstate", false);
		 session.setAttribute("buisnessloginstate", false);
		return "main";
		
		
	}
	@RequestMapping(value = "/loginmain")
	public String loginmain() { //로그인 했을 때 돌아가는 메인
		
		return "main";
		
	}
	@RequestMapping(value = "/DateCocklog")
	public String DateCocklog() {
	
		return "DateCocklog";
		
		
	}
	@RequestMapping(value = "/game")
	public String game() {
	
		return "game";
		
		
	}
}
