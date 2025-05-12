package com.mbc.datecock.reply; // <<<--- 실제 패키지 경로로 수정!

import java.util.Date;

public class ReplyDTO {
    private int rno;
    private int bno;
    private String replytext;
    private String replyer;
    private Date replydate;
    private Date updatedate;

    // 기본 생성자
    public ReplyDTO() {}

    // --- 모든 필드 Getter & Setter ---
    // (Lombok @Data 사용 가능)
    public int getRno() { return rno; }
    public void setRno(int rno) { this.rno = rno; }
    public int getBno() { return bno; }
    public void setBno(int bno) { this.bno = bno; }
    public String getReplytext() { return replytext; }
    public void setReplytext(String replytext) { this.replytext = replytext; }
    public String getReplyer() { return replyer; }
    public void setReplyer(String replyer) { this.replyer = replyer; }
    public Date getReplydate() { return replydate; }
    public void setReplydate(Date replydate) { this.replydate = replydate; }
    public Date getUpdatedate() { return updatedate; }
    public void setUpdatedate(Date updatedate) { this.updatedate = updatedate; }

    @Override
    public String toString() {
        return "ReplyDTO [rno=" + rno + ", bno=" + bno + ", replyer=" + replyer + "]";
    }
}