package com.mbc.datecock.mypage;

public class UsermypageDTO {
	
		String id;
		String pwd;
		String email;
		String name;
		String birth;
		String phone;
		String pwd_confirm;
		String company;
		String searchname;
		String searchemail;
		String newpwd;
		String newpwd_confirm;
		
	public UsermypageDTO(String id, String pwd, String email, String name, String birth, String phone,
			String pwd_confirm, String company, String searchname, String searchemail, String newpwd,
			String newpwd_confirm) {
		super();
		this.id = id;
		this.pwd = pwd;
		this.email = email;
		this.name = name;
		this.birth = birth;
		this.phone = phone;
		this.pwd_confirm = pwd_confirm;
		this.company = company;
		this.searchname = searchname;
		this.searchemail = searchemail;
		this.newpwd = newpwd;
		this.newpwd_confirm = newpwd_confirm;
	}
	
	public UsermypageDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getBirth() {
		return birth;
	}
	public void setBirth(String birth) {
		this.birth = birth;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getPwd_confirm() {
		return pwd_confirm;
	}
	public void setPwd_confirm(String pwd_confirm) {
		this.pwd_confirm = pwd_confirm;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public String getSearchname() {
		return searchname;
	}
	public void setSearchname(String searchname) {
		this.searchname = searchname;
	}
	public String getSearchemail() {
		return searchemail;
	}
	public void setSearchemail(String searchemail) {
		this.searchemail = searchemail;
	}
	public String getNewpwd() {
		return newpwd;
	}
	public void setNewpwd(String newpwd) {
		this.newpwd = newpwd;
	}
	public String getNewpwd_confirm() {
		return newpwd_confirm;
	}
	public void setNewpwd_confirm(String newpwd_confirm) {
		this.newpwd_confirm = newpwd_confirm;
	}
	
}
