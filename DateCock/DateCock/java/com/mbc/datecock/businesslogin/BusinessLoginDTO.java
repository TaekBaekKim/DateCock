package com.mbc.datecock.businesslogin;

public class BusinessLoginDTO {

	public BusinessLoginDTO(String id, String pw) {
		super();
		this.id = id;
		this.pw = pw;
	}
	public BusinessLoginDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	String id;
	String pw;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	
}
