package com.mbc.datecock.bizqna; // 패키지명 변경

import java.util.Date;
import org.springframework.web.multipart.MultipartFile;

public class BizQnaBoardDTO { // 클래스명 변경
    private int bno;
    private String title;
    private String content;
    private String writer; // 사업자등록번호 저장
    private Date regdate;
    private int viewcnt;
    // private int secret = 0; // 기존: int 타입, 기본값 0 (공개글)
    private Integer secret; // *** 수정: Integer 타입으로 변경 (null 허용) ***
    private String answerStatus = "답변대기";
    private String answerContent;
    private String answerWriter; // 관리자 ID 저장
    private Date answerDate;
    private String imageFile;
    private MultipartFile qnaImageFile; // 폼에서 파일 받을 때 사용
    private String businessName;
    public String getBusinessName() {
		return businessName;
	}

	public void setBusinessName(String businessName) {
		this.businessName = businessName;
	}

	// 기본 생성자
    public BizQnaBoardDTO() {}

    // --- Getter and Setter ---
    public int getBno() { return bno; }
    public void setBno(int bno) { this.bno = bno; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getWriter() { return writer; } // 사업자 번호가 저장될 것임
    public void setWriter(String writer) { this.writer = writer; }
    public Date getRegdate() { return regdate; }
    public void setRegdate(Date regdate) { this.regdate = regdate; }
    public int getViewcnt() { return viewcnt; }
    public void setViewcnt(int viewcnt) { this.viewcnt = viewcnt; }

    // *** 수정: secret 필드의 getter와 setter를 Integer 타입으로 ***
    public Integer getSecret() { return secret; }
    public void setSecret(Integer secret) { this.secret = secret; }

    public String getAnswerStatus() { return answerStatus; }
    public void setAnswerStatus(String answerStatus) { this.answerStatus = answerStatus; }
    public String getAnswerContent() { return answerContent; }
    public void setAnswerContent(String answerContent) { this.answerContent = answerContent; }
    public String getAnswerWriter() { return answerWriter; }
    public void setAnswerWriter(String answerWriter) { this.answerWriter = answerWriter; }
    public Date getAnswerDate() { return answerDate; }
    public void setAnswerDate(Date answerDate) { this.answerDate = answerDate; }
    public String getImageFile() { return imageFile; }
    public void setImageFile(String imageFile) { this.imageFile = imageFile; }
    public MultipartFile getQnaImageFile() { return qnaImageFile; }
    public void setQnaImageFile(MultipartFile qnaImageFile) { this.qnaImageFile = qnaImageFile; }

    // *** 수정: isSecretPost() 메소드에서 null 안전 비교 사용 ***
    public boolean isSecretPost() {
        // secret 필드가 null이 아니고, 그 값이 1과 같으면 true 반환
        return Integer.valueOf(1).equals(this.secret);
    }

    @Override
    public String toString() {
        return "BizQnaBoardDTO [bno=" + bno + ", title=" + title + ", writer=" + writer
                + ", businessName=" + businessName // 추가된 필드 포함
                + ", secret=" + secret + ", answerStatus=" + answerStatus + ", imageFile=" + imageFile +"]";
    }
}