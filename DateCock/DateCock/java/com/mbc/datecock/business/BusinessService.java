package com.mbc.datecock.business;

import java.util.ArrayList;

import com.mbc.datecock.businessmember.BusinessMemberDTO;

public interface BusinessService {



	ArrayList<BusinessDTO> businessselect(String businessnumber);


	void businessinsert(String businessnumber, String businessname, String address, String businesstime, String phone,
			String image, String information, int age, String zone, String activity);

	BusinessDTO updateselect(String businessnumber);

	void alldelete(String businessnumber);

	void updategogogo(String businessname, String address, String businesstime, String phone, String information,
			int age, String zone, String activity, String businessnumber); //이미지 x

	void updategogogogo(String businessname, String address, String businesstime, String phone, String image,
			String information, int age, String zone, String activity, String businessnumber); //이미지 o

	

}
