package com.mbc.datecock.datecourse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mbc.datecock.business.BusinessDTO;
import com.mbc.datecock.member.MemberDTO;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;


@Controller
public class DatecourseController {
@Autowired
SqlSession sqlSession;
String path="C:\\MBC12AI\\spring\\DateCock\\src\\main\\webapp\\image";


@RequestMapping(value = "/datecourseout")
public String datecourseout(Model model) {
   
   DateCourseService service = sqlSession.getMapper(DateCourseService.class);
   ArrayList<BusinessDTO> list = service.allselect();
   model.addAttribute("list", list);
   
   return "datecourseout";
}

@RequestMapping(value = "/datereservation")
public String datereservation(Model model, HttpServletRequest request) {
    String businessname = request.getParameter("businessname");
    String name = (String) request.getSession().getAttribute("name");
    
    DateCourseService service = sqlSession.getMapper(DateCourseService.class);
    MemberDTO dto = service.select(name);
    ArrayList<BusinessDTO> list = service.bselect(businessname);
    BusinessDTO mapaddress = service.mapaddress(businessname);
    ArrayList<GuestDTO> guestList = service.alltime();  //  여기서 guestList 불러오기
    HttpSession hp=request.getSession();
    String image = service.image(businessname);
    
     
    model.addAttribute("dto", dto);
    model.addAttribute("list", list);
    model.addAttribute("mapaddress", mapaddress);
    model.addAttribute("businessname", businessname);
    model.addAttribute("image", image); // 가게 이미지를 사용 하기 위함 
    model.addAttribute("getname",name); //개인 로그인 된 사람의 이름을 댓글에서 가져오기 위함
    model.addAttribute("guestList", guestList); //  JSP에서 사용할 수 있도록 전달
    return "datereservation";
}

@RequestMapping(value = "/reservationsave")
public String reservationsave(Model model,HttpServletRequest request,HttpServletResponse response) throws IOException {
   String name = request.getParameter("name");
   String phone = request.getParameter("phone");
   Date day = Date.valueOf(request.getParameter("day"));
   String intime = request.getParameter("intime"); 
   String businessname = request.getParameter("businessname");
   String id = request.getParameter("id");
   String image = request.getParameter("image");
   DateCourseService service = sqlSession.getMapper(DateCourseService.class);
   DateCourseDTO result = service.reservationselect(businessname,day);
   if(result == null) {
      service.insert(name,phone,day,intime,businessname,id,image);
      return "redirect:/loginmain";
   }
   
   else {
       response.setContentType("text/html;charset=utf-8");
       PrintWriter out = response.getWriter();
       out.print("<script>alert('이미 예약되어 있습니다'); location.href='datecourseout';</script>");
       out.close();
       return null;
   }
}
@RequestMapping(value = "/recommendation")
public String datecourseout(Model model,HttpServletRequest request,HttpServletResponse response) throws IOException {
   HttpSession hs = request.getSession();
   Object loginAttr = hs.getAttribute("personalloginstate");
   boolean login = Boolean.TRUE.equals(loginAttr); // 
   if(login) {
      
      return "recommendation";
   }
   else {
         response.setContentType("text/html;charset=UTF-8");
         PrintWriter printwriter = response.getWriter();
         printwriter.print("<script>alert('회원만 이용 가능합니다!!')</script>");
         printwriter.print("<script>location.href='DateCocklog'</script>");
         printwriter.close();
      return "redirect:/DateCocklog";
   }
   
}
@ResponseBody
@RequestMapping(value = "/getDateCourse", method = RequestMethod.POST)
public ArrayList<BusinessDTO> getDateCourse(HttpServletRequest request) {
    String step1 = request.getParameter("step1");
    String step2 = request.getParameter("step2");
    String step3 = request.getParameter("step3");

    DateCourseService service = sqlSession.getMapper(DateCourseService.class);
    service.courseinsert(step1, step2, step3);
    return service.conditionselect(step1, step2, step3);  // JSON 자동 변환
}
@RequestMapping(value = "/recommendresult", method = RequestMethod.POST)
public String recommendResult(HttpServletRequest request, Model model) {
    String json = request.getParameter("resultList");

    try {
        Gson gson = new Gson();
        ArrayList<BusinessDTO> list = gson.fromJson(json, new TypeToken<ArrayList<BusinessDTO>>(){}.getType());
        model.addAttribute("resultList", list);
    } catch (Exception e) {
        e.printStackTrace();
    }
    return "datecourse/recommendresult"; // Tiles 적용 없이 JSP 직접
}

// insertGuest
@ResponseBody
@RequestMapping(value = "/insertGuest", method = RequestMethod.POST)
public GuestDTO insertGuest(@RequestParam String name, @RequestParam String memo) {
    GuestDTO g = new GuestDTO();
    g.setName(name);
    g.setMemo(memo);
    g.setTodays(new Timestamp(System.currentTimeMillis()));
    sqlSession.getMapper(DateCourseService.class).insertGuest(g);
    return g;
}

// deleteGuest
@ResponseBody
@RequestMapping(value="/deleteGuest", method=RequestMethod.POST)
public String deleteGuest(
        @RequestParam String name,
        @RequestParam String todays  // "yyyy-MM-dd HH:mm:ss" 형식의 문자열
) 

{
    // 문자열을 Timestamp로 변환
    Timestamp ts = Timestamp.valueOf(todays);
    sqlSession.getMapper(DateCourseService.class)
              .deleteGuest(name, ts);
    
    return name;
}
}
