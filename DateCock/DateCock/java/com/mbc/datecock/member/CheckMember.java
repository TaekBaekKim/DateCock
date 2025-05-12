package com.mbc.datecock.member;

public class CheckMember {
	
	boolean exists;
	String message;
	public boolean isExists() {
		return exists;
	}
	public void setExists(boolean exists) {
		this.exists = exists;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public CheckMember(boolean exists, String message) {
		super();
		this.exists = exists;
		this.message = message;
	}
	public CheckMember() {
		super();
		// TODO Auto-generated constructor stub
	}
	
}
