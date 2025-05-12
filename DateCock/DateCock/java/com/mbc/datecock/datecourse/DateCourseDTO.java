package com.mbc.datecock.datecourse;

import java.sql.Date;

public class DateCourseDTO {
	String name;
	String phone;
	Date day;
	String intime;
	String businessname;
	String id;
	String image;
	public DateCourseDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	public DateCourseDTO(String name, String phone, Date day, String intime, String businessname, String id,
			String image) {
		super();
		this.name = name;
		this.phone = phone;
		this.day = day;
		this.intime = intime;
		this.businessname = businessname;
		this.id = id;
		this.image = image;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public Date getDay() {
		return day;
	}
	public void setDay(Date day) {
		this.day = day;
	}
	public String getIntime() {
		return intime;
	}
	public void setIntime(String intime) {
		this.intime = intime;
	}
	public String getBusinessname() {
		return businessname;
	}
	public void setBusinessname(String businessname) {
		this.businessname = businessname;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	
	
}
