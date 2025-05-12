package com.mbc.datecock.userqna;

import java.util.Date;
import org.springframework.web.multipart.MultipartFile; // MultipartFile 임포트

public class UserQnaBoardDTO {
    private int bno;
    private String title;
    private String content;
    private String writer;
    private Date regdate;
    private int viewcnt;
    // SECRET 필드 타입을 char에서 int로 변경 (0: 공개글, 1: 비밀글)
    private int secret = 0; // 기본값 공개글(0)
    private String answerStatus = "답변대기";
    private String answerContent;
    private String answerWriter;
    private Date answerDate;

    // --- 이미지 파일 관련 필드 추가 ---
    private String imageFile; // DB에 저장될 파일명 또는 웹 경로
    private MultipartFile qnaImageFile; // 글쓰기/수정 시 파일 데이터를 받기 위한 필드 (DB 저장 X)

    // 기본 생성자
    public UserQnaBoardDTO() {}

    // --- Getter and Setter ---

    public int getBno() { return bno; }
    public void setBno(int bno) { this.bno = bno; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }
    public Date getRegdate() { return regdate; }
    public void setRegdate(Date regdate) { this.regdate = regdate; }
    public int getViewcnt() { return viewcnt; }
    public void setViewcnt(int viewcnt) { this.viewcnt = viewcnt; }

    // secret 필드의 getter와 setter를 int 타입으로 수정
    public int getSecret() { return secret; }
    public void setSecret(int secret) { this.secret = secret; }

    public String getAnswerStatus() { return answerStatus; }
    public void setAnswerStatus(String answerStatus) { this.answerStatus = answerStatus; }
    public String getAnswerContent() { return answerContent; }
    public void setAnswerContent(String answerContent) { this.answerContent = answerContent; }
    public String getAnswerWriter() { return answerWriter; }
    public void setAnswerWriter(String answerWriter) { this.answerWriter = answerWriter; }
    public Date getAnswerDate() { return answerDate; }
    public void setAnswerDate(Date answerDate) { this.answerDate = answerDate; }


    public String getImageFile() {
        return imageFile;
    }

    public void setImageFile(String imageFile) {
        this.imageFile = imageFile;
    }

    public MultipartFile getQnaImageFile() {
        return qnaImageFile;
    }

    public void setQnaImageFile(MultipartFile qnaImageFile) {
        this.qnaImageFile = qnaImageFile;
    }

    // isSecretPost() 메소드 수정: secret 값이 1이면 true 반환
    public boolean isSecretPost() {
        return this.secret == 1;
    }

    @Override
    public String toString() {
        return "UserQnaBoardDTO [bno=" + bno + ", title=" + title + ", writer=" + writer + ", secret=" + secret
                + ", answerStatus=" + answerStatus + ", imageFile=" + imageFile +"]";
    }
}