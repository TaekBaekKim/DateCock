package com.mbc.datecock.mypage;

import java.sql.Date;
import java.util.ArrayList;
import java.util.Map;

import com.mbc.datecock.business.BusinessDTO;
import com.mbc.datecock.datecourse.DateCourseDTO;

public interface MypageService {

	void businessinfodelete(String businessnumber);

	MypageDTO businessinfomodifyview(String businessnumber);

	void businessinfomodify(MypageDTO dto);

	String getbusinesspw(String businessnumber);

	void businesspwmodify(MypageDTO dto);

	ArrayList<DateCourseDTO> select(String id); //예약내용 가져오기 

	BusinessDTO businessinputselect(String businessname);

	ArrayList<DateCourseDTO> datereservationselect(String id, String businessname, Date day);

	ArrayList<BusinessDTO> businessinputview(String businessname);

	int datelistdelete(String name, Date day, String businessname);

	void userinfodelete(String id);

	UsermypageDTO userinfomodifyview(String id);

	void userinfomodify(UsermypageDTO dto);

	String getuserpw(String id);

	void userpwmodifyRaw(Map<String, String> map);

	String getuseremail(String id);

	String getbusinessemail(String businessnumber);

}
