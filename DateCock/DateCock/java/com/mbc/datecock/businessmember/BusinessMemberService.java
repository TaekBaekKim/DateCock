package com.mbc.datecock.businessmember;

public interface BusinessMemberService {
	//회원가입
	void businessinsert(String businessnumber, String password, String email, String businessname, String phone,
			String birthyear);
	
	//사업자 등록번호 중복검사
	int businessnumbercheck(String businessnumber);
	
	//사업자명과 이메일이 db에 있는지 검사 - 사업자 등록번호 찾기
	BusinessMemberDTO findMemberId(String businessname, String email);
	
	//변경된 pw db에 반영 - 비밀번호 찾기
	int updateTempPassword(BusinessMemberDTO dto);
	
	//사업자 등록번호 db에 있는지 검사 - 비밀번호 찾기
	int samebusinessnumber(String businessnumber);
	
	//이메일 db에 있는지 검사 - 비밀번호 찾기
	int checkEmailMatch(BusinessMemberDTO dto);
	
	
}
