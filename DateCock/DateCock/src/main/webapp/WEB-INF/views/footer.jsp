<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
@font-face {
    font-family: 'Binggrae-Two';
    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_one@1.0/Binggrae-Bold.woff') format('woff');
    font-weight: normal;
    font-style: normal;
}
.bb {
    font-weight: 900; 
    font-family: 'Binggrae-Two';
    font-size: 28px;
}
.topline {
    margin: 20px auto 10px auto;
    font-size: 16px;
    text-align: center;
}
.hrhr {
    width: 80%;
    margin: 0 auto;
}
.topline a {
    margin: 0 30px;
    color: white;
    text-decoration: none;
}
.topline a:hover {
    color: #ffe8cc;
}
.sns-container {
    display: flex;
    margin-top: 10px;
}
.sns {
    margin-right: 10px;
    width: 36px;
    height: 36px;
}
.sns img {
    border-radius: 8px;
    width: 100%;
    height: 100%;
    object-fit: cover;
    cursor: pointer;
}


footer {
    background-color: rgb(253,166,165);
    color: white; /* 기본 footer 텍스트 색상을 white로 설정되어 있습니다. */
    padding: 20px 50px;
    font-family: 'NanumSquareRound', sans-serif;
    font-size: 14px;
    line-height: 22px;
}
.footer-content {
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    margin-top: 20px;
}
.info, .cc {
    flex: 1;
    min-width: 280px;
    margin: 10px 20px;
}
</style>
</head>

<footer>
  <div class="topline">
    <a href="">서비스 이용약관</a> |  
    <a href="">개인정보 처리방침</a> | 
    <a href="">위치정보 이용약관</a> | 
    <a href="">인재 채용</a> | 
    <a href="">입점 문의</a> |  
    <a href="">광고/제휴 문의</a> 
  </div>
  <hr class="hrhr">


  <div class="footer-content">
    <div class="info">
      <b>COMPANY INFO</b>
      <%-- DateCock 글자색 흰색으로 변경 --%>
      <h2 class="bb" style="color: white !important;">DateCock</h2>
      담당자: MBC 5조 | 연락처: 010-XXXX-XXXX<br>
      주소: 경기 수원시 팔달구 어딘가<br>
      사업자등록번호: 677-54188-874122 | 개인정보보호책임자: Park(ehddls@xxxxxxxx.com)<br>  
      제휴/협력 문의 : 010-XXXX-XXXX <br><br>
    </div>

    <div class="cc">
      <b>CUSTOMER CENTER</b>
      <%-- 1688-8885 글자색 흰색으로 변경 --%>
      <h2 class="bb" style="color: white !important;">1688-8885</h2><br>
      운영시간 월-금 09:30 - 17:00<br>
      점심시간 12:30 - 13:30<br>
      휴무안내 토/일/공휴일/임시공휴일<br><br>
      전화 연결이 안될 시,<br>
      게시판에 문의 남겨주시면 빠른 처리 해드리겠습니다.
    </div>

    <div class="cc">
      <b>SNS</b>
      <div class="sns-container">
        <div class="sns"><img src="./image/kakaotalk.png"></div>
        <div class="sns"><img src="./image/instagram.png"></div>
        <div class="sns"><img src="./image/facebook.png"></div>
      </div>
      <div class="sns-container">
        <div class="sns"><img src="./image/twitter.png"></div>
        <div class="sns"><img src="./image/line.png"></div>
        <div class="sns"><img src="./image/youtube.png"></div>
      </div>
    </div>
  </div>
  

</footer>
</html>