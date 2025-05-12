package com.mbc.datecock.datecourse;


import java.sql.Timestamp;

public class GuestDTO {
    private String name;
    private String memo;
    private Timestamp todays;

    public GuestDTO() {

    }

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public Timestamp getTodays() {
		return todays;
	}

	public void setTodays(Timestamp todays) {
		this.todays = todays;
	}

	public GuestDTO(String name, String memo, Timestamp todays) {
		super();
		this.name = name;
		this.memo = memo;
		this.todays = todays;
	}
}