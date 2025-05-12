package com.mbc.datecock.datecourse;

public class DateCourseConditionDTO {
	String conditionAge;
	String conditionZone;
	String conditionActivity;
	public String getConditionAge() {
		return conditionAge;
	}
	public void setConditionAge(String conditionAge) {
		this.conditionAge = conditionAge;
	}
	public String getConditionZone() {
		return conditionZone;
	}
	public void setConditionZone(String conditionZone) {
		this.conditionZone = conditionZone;
	}
	public String getConditionActivity() {
		return conditionActivity;
	}
	public void setConditionActivity(String conditionActivity) {
		this.conditionActivity = conditionActivity;
	}
	public DateCourseConditionDTO(String conditionAge, String conditionZone, String conditionActivity) {
		super();
		this.conditionAge = conditionAge;
		this.conditionZone = conditionZone;
		this.conditionActivity = conditionActivity;
	}
	public DateCourseConditionDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
}
