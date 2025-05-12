package com.mbc.datecock.business;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.mbc.datecock.businessmember.BusinessMemberDTO;


@Controller
public class BusinessController {
@Autowired
SqlSession sqlSession;
String path="C:\\MBC12AI\\spring\\DateCock\\src\\main\\webapp\\image";

@RequestMapping(value = "/businessinput")
public String businessinput() {
   
   
   return "businessinput";
}
@RequestMapping(value = "/businesssavego",method = RequestMethod.POST) //자료 입력
public String businesssave(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {
   String businessname=mul.getParameter("businessname");
    String address=mul.getParameter("address");
    String businesstime=mul.getParameter("businesstime");
    String phone=mul.getParameter("phone");
    String information=mul.getParameter("information");
    int age=Integer.parseInt(mul.getParameter("age"));
    String zone=mul.getParameter("zone");
   String activity=mul.getParameter("activity");
   MultipartFile mf=mul.getFile("businessimage");
   String image=mf.getOriginalFilename();
   
BusinessService bs =sqlSession.getMapper(BusinessService.class);
String businessnumber = (String) mul.getSession().getAttribute("businessnumberA");


UUID ud=UUID.randomUUID();
image=ud.toString()+"-"+image;
bs.businessinsert(businessnumber,businessname,address,businesstime,phone,image,information,age,zone,activity);
mf.transferTo(new File(path + "\\" + image));

   return "redirect:/loginmain";
}
@RequestMapping(value = "/businessout") //출력창 이동
public String businessout(Model model,BusinessDTO dto, HttpServletRequest request) {
   BusinessService bs =sqlSession.getMapper(BusinessService.class);
   String  businessnumber= (String) request.getSession().getAttribute("businessnumberA");
   
    
   ArrayList<BusinessDTO>list=bs.businessselect(businessnumber);
   model.addAttribute("list",list);
   return "businessout";
}
@RequestMapping(value = "/businessupdate") // 수정 jsp로 이동 
public String businessupdate(Model model,HttpServletRequest request) {
   BusinessService bs = sqlSession.getMapper(BusinessService.class);
   String businessnumber =request.getParameter("businessnumber");
    BusinessDTO dto = bs.updateselect(businessnumber);
    model.addAttribute("dto", dto);
    
   return "businessupdate";
}
@RequestMapping(value = "/businessupdategogogo") //수정 시작 
public String businessupdategogogo(MultipartHttpServletRequest mul) throws IllegalStateException, IOException {
   String businessnumber=mul.getParameter("businessnumber");
   String businessname=mul.getParameter("businessname");
    String address=mul.getParameter("address");
    String businesstime=mul.getParameter("businesstime");
    String phone=mul.getParameter("phone");
    String information=mul.getParameter("information");
    int age=Integer.parseInt(mul.getParameter("age"));
    String zone=mul.getParameter("zone");
   String activity=mul.getParameter("activity");
   String goimage=mul.getParameter("goimage");
   
   MultipartFile mf=mul.getFile("image"); //새로운이미지
   BusinessService service = sqlSession.getMapper(BusinessService.class);
   if(mf.isEmpty()) {
      service.updategogogo(businessname,address,businesstime,phone,information,age,zone,activity,businessnumber); //이미지를 뺀 값들
      
      }
   else {
      
      
      String image=mf.getOriginalFilename();
      
      UUID uuid = UUID.randomUUID();
      image=uuid.toString()+"-"+image;
      
      mf.transferTo(new File(path+"\\"+image));
      String deleteimage=mul.getParameter("deleteimage");
      File file = new File(path+"\\"+deleteimage);
      file.delete();
      service.updategogogogo(businessname,address,businesstime,phone,image,information,age,zone,activity,businessnumber); //이미지까지 업뎃
   }
   
    
   return "redirect:/businessout";
}

@ResponseBody
@RequestMapping(value = "alldelete", method = RequestMethod.POST)
public String alldelete(HttpServletRequest request) {
    String businessnumber = request.getParameter("businessnumber");
    String businessimage = request.getParameter("businessimage");

    BusinessService bs = sqlSession.getMapper(BusinessService.class);
    bs.alldelete(businessnumber);

    File file = new File(path + "\\" + businessimage);
    if (file.exists()) {
        file.delete();
    }

    return "success";
}
public class PageController {

    @RequestMapping("/support")
    public String supportPage() {
        return "support"; 
    }
}
}
