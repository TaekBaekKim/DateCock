package com.mbc.datecock.qna;

import java.util.List;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/support")
public class QnAController {

    @Autowired
    private SqlSession sqlSession;  // SqlSession 직접 가져오기
    
    @RequestMapping(value="/ajax/supportfaq", method=RequestMethod.GET)
    public String supportFaq() {
        return "QnA/supportfaq"; 
    }

    @RequestMapping(value="/ajax/userqnalist", method=RequestMethod.GET)
    public String userQnaList(Model model) {
        List<QnADTO> list = sqlSession.selectList("com.mbc.datecock.qna.QnaMapper.getUserQnaList");
        model.addAttribute("list", list);
        return "QnA/userqnalist";
    }

    @RequestMapping(value="/ajax/businessqnalist", method=RequestMethod.GET)
    public String businessQnaList(Model model) {
        List<QnADTO> list = sqlSession.selectList("com.mbc.datecock.qna.QnaMapper.getBusinessQnaList");
        model.addAttribute("list", list);
        return "QnA/businessqnalist";
    }

    @RequestMapping(value="/supportqna", method=RequestMethod.POST)
    public String insertQna(QnADTO dto, HttpSession session) {
        String businessnumber = (String) session.getAttribute("businessnumberA");

        if (businessnumber != null) {
            dto.setType("business");
            dto.setWriter(businessnumber);
        } else {
            dto.setType("user");
            dto.setWriter("guest");
        }

        sqlSession.insert("com.mbc.datecock.qna.QnaMapper.insertQna", dto);

        return "redirect:/support";
    }
    
    @RequestMapping(value="/support")
    public String support() {
    	
    	return "support";
    }
    
    @RequestMapping(value="/ajax/supportqna", method=RequestMethod.GET)
    public String supportQnaForm() {
        return "QnA/supportqna"; 
    }

}
