package com.mbc.datecock.business;

import java.sql.Time;

public class BusinessDTO {
String businessnumber,businessname,address;
String businesstime;
String phone,image,information;
int age;
String zone,activity;
public BusinessDTO() {
	super();
	// TODO Auto-generated constructor stub
}
public BusinessDTO(String businessnumber, String businessname, String address, String businesstime, String phone,
		String image, String information, int age, String zone, String activity) {
	super();
	this.businessnumber = businessnumber;
	this.businessname = businessname;
	this.address = address;
	this.businesstime = businesstime;
	this.phone = phone;
	this.image = image;
	this.information = information;
	this.age = age;
	this.zone = zone;
	this.activity = activity;
}
public String getBusinessnumber() {
	return businessnumber;
}
public void setBusinessnumber(String businessnumber) {
	this.businessnumber = businessnumber;
}
public String getBusinessname() {
	return businessname;
}
public void setBusinessname(String businessname) {
	this.businessname = businessname;
}
public String getAddress() {
	return address;
}
public void setAddress(String address) {
	this.address = address;
}
public String getBusinesstime() {
	return businesstime;
}
public void setBusinesstime(String businesstime) {
	this.businesstime = businesstime;
}
public String getPhone() {
	return phone;
}
public void setPhone(String phone) {
	this.phone = phone;
}
public String getImage() {
	return image;
}
public void setImage(String image) {
	this.image = image;
}
public String getInformation() {
	return information;
}
public void setInformation(String information) {
	this.information = information;
}
public int getAge() {
	return age;
}
public void setAge(int age) {
	this.age = age;
}
public String getZone() {
	return zone;
}
public void setZone(String zone) {
	this.zone = zone;
}
public String getActivity() {
	return activity;
}
public void setActivity(String activity) {
	this.activity = activity;
}

	


}
