package com.mbc.datecock.mypage;

public class MypageDTO {
	
	String businessnumber; //사업자 등록번호
	String password; //비밀번호
	String password_confirm;
	String email; //Email 주소
	String phone; //전화번호
	String businessname; //이름
	String birthyear; //생년월일
	String businessnewpw;
	String businessnewpw_confirm;
	public MypageDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	public MypageDTO(String businessnumber, String password, String password_confirm, String email, String phone,
			String businessname, String birthyear, String businessnewpw, String businessnewpw_confirm) {
		super();
		this.businessnumber = businessnumber;
		this.password = password;
		this.password_confirm = password_confirm;
		this.email = email;
		this.phone = phone;
		this.businessname = businessname;
		this.birthyear = birthyear;
		this.businessnewpw = businessnewpw;
		this.businessnewpw_confirm = businessnewpw_confirm;
	}
	public String getBusinessnumber() {
		return businessnumber;
	}
	public void setBusinessnumber(String businessnumber) {
		this.businessnumber = businessnumber;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getPassword_confirm() {
		return password_confirm;
	}
	public void setPassword_confirm(String password_confirm) {
		this.password_confirm = password_confirm;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getBusinessname() {
		return businessname;
	}
	public void setBusinessname(String businessname) {
		this.businessname = businessname;
	}
	public String getBirthyear() {
		return birthyear;
	}
	public void setBirthyear(String birthyear) {
		this.birthyear = birthyear;
	}
	public String getBusinessnewpw() {
		return businessnewpw;
	}
	public void setBusinessnewpw(String businessnewpw) {
		this.businessnewpw = businessnewpw;
	}
	public String getBusinessnewpw_confirm() {
		return businessnewpw_confirm;
	}
	public void setBusinessnewpw_confirm(String businessnewpw_confirm) {
		this.businessnewpw_confirm = businessnewpw_confirm;
	}
	
}
