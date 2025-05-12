package com.mbc.datecock.datecourse;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.mbc.datecock.business.BusinessDTO;
import com.mbc.datecock.member.MemberDTO;

public interface DateCourseService {

	ArrayList<BusinessDTO> allselect();

	

	void insert(String name, String phone, Date day, String intime, String businessname, String id, String image);



	MemberDTO select(String name);



	ArrayList<BusinessDTO> bselect(String businessname);



	BusinessDTO mapaddress(String businessname);



	DateCourseDTO reservationselect(String businessname, Date day);



	ArrayList<GuestDTO> alltime();



	void courseinsert(String conditionAge, String conditionZone, String conditionActivity);



	ArrayList<BusinessDTO> conditionselect(String conditionAge, String conditionZone, String conditionActivity);


    GuestDTO selectGuestById(String id);
    


    
		ArrayList<GuestDTO> insertGuest();
		
		
		void insertGuest(GuestDTO g);
		
	    
		int deleteGuest(
			        @Param("name")   String name,
			        @Param("todays") Timestamp todays );



		String image(String businessname);



		



		
	



	

}
