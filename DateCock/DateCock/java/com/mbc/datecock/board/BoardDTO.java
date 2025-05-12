package com.mbc.datecock.board;

import java.util.Date;

public class BoardDTO {
	int bno;
	String title,content,writer;
	Date regdate;
	int viewcnt,replycnt;
	int likecnt;
	String thumbnail;
	
	String snippet;//내용 미리보기
	String relativeTime; //상대시간 (예: 5분전 작성)
	public int getBno() {
		return bno;
	}
	public void setBno(int bno) {
		this.bno = bno;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	public int getViewcnt() {
		return viewcnt;
	}
	public void setViewcnt(int viewcnt) {
		this.viewcnt = viewcnt;
	}
	public int getReplycnt() {
		return replycnt;
	}
	public void setReplycnt(int replycnt) {
		this.replycnt = replycnt;
	}
	public int getLikecnt() {
		return likecnt;
	}
	public void setLikecnt(int likecnt) {
		this.likecnt = likecnt;
	}
	public String getThumbnail() {
		return thumbnail;
	}
	public void setThumbnail(String thumnail) {
		this.thumbnail = thumnail;
	}
	public String getSnippet() {
		return snippet;
	}
	public void setSnippet(String snippet) {
		this.snippet = snippet;
	}
	public String getRelativeTime() {
		return relativeTime;
	}
	public void setRelativeTime(String relativeTime) {
		this.relativeTime = relativeTime;
	}
	public BoardDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
}
