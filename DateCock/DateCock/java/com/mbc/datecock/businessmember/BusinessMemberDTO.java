package com.mbc.datecock.businessmember;



public class BusinessMemberDTO {
	
	public BusinessMemberDTO(String businessnumber, String password, String password_confirm, String email,
			String businessname, String phone, String birthyear) {
		super();
		this.businessnumber = businessnumber;
		this.password = password;
		this.password_confirm = password_confirm;
		this.email = email;
		this.businessname = businessname;
		this.phone = phone;
		this.birthyear = birthyear;
	}
	public BusinessMemberDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	String businessnumber;
	String password;
	String password_confirm;
	String email;
	String businessname;
	String phone;
	String birthyear;
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
	public String getBusinessname() {
		return businessname;
	}
	public void setBusinessname(String businessname) {
		this.businessname = businessname;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getBirthyear() {
		return birthyear;
	}
	public void setBirthyear(String birthyear) {
		this.birthyear = birthyear;
	}
	
}
