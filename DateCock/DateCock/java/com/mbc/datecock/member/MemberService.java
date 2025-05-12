package com.mbc.datecock.member;

import java.util.ArrayList;
import java.util.Map;



public interface MemberService {

	

	int idcheck(String id);



	

	ArrayList<MemberDTO> allout();





	void insertm(String id, String pwd, String email, String name, String birth, String phone, String company);





	String findMemberId(MemberDTO dto);





	int checkMemberOk(Map<String, Object> params);





	int updatePassword(Map<String, Object> params);





	void insertm(String id, String pwd, String email, String name, String birth, String phone, int admin);

}
