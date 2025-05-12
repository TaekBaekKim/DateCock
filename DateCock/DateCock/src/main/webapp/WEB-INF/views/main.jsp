<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>메인 슬라이드</title>

  <!-- CSS 라이브러리 -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css" />

  <style>
    img {
  max-width: 100%;
  height: auto;
  display: block;
}
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
html, body {
  width: 100%;
  min-height: 100vh;
  background-color: rgb(248, 241, 241);
  font-family: 'Noto Sans KR', sans-serif;
}
.main-content {
  width: 100%;
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

/* 이벤트 슬라이드 */
.slider-wrapper {
  width: 1750px;
  height: 500px;
  display: flex;
}
.carousel,
.carousel-inner,
.carousel-item {
  width: 100%;
  height: 100%;
}
.carousel-item {
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}
.carousel-caption {
  position: absolute;
  top: 50%;
  left: 10%;
  transform: translateY(-50%);
  text-align: left;
}
.carousel-caption h2 {
  font-size: 48px;
  font-weight: bold;
  color: #fff;
}
.carousel-caption p {
  font-size: 20px;
  color: #ffee99;
}
.carousel-caption button {
  background-color: #ffa95f;
  border: none;
  padding: 12px 24px;
  color: #fff;
  font-weight: bold;
  border-radius: 5px;
  cursor: pointer;
}
.carousel-control-prev-icon,
.carousel-control-next-icon {
  background-color: rgba(0, 0, 0, 0.4);
  border-radius: 50%;
}

.datecourse-section {
  padding: 60px 40px;
  background-color: rgb(248,241,241);
  width: 100%;
  box-sizing: border-box;
}
.section-title {
  font-size: 26px;
  font-weight: bold;
  margin-bottom: 30px;
  color: #333;
}

/* 🔁 새로운 카드 슬라이드 무한 루프 */
.loop-container {
  overflow: hidden;
  width: 100%;
  position: relative;
}
.loop-track {
  display: flex;
  width: calc(260px * 16 + 24px * 15);
  animation: scroll-left 60s linear infinite;
}
.loop-slide {
  background-color: #000;
  width: 260px;
  height: 330px;
  border-radius: 12px;
  overflow: hidden;
  margin-right: 24px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
}
.loop-slide img {
  width: 100%;
  height: 180px;
  object-fit: cover;
}
.course-info {
  padding: 14px;
  color: #fff;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  overflow: hidden;
}
.course-info .location {
  font-size: 12px;
  color: #aaa;
  margin-bottom: 6px;
}
.course-info h3 {
  font-size: 17px;
  margin-bottom: 8px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.course-info p {
  font-size: 13px;
  color: #ccc;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
@keyframes scroll-left {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(-50%);
  }
}

    
  </style>
</head>
<body>

<div class="main-content">
  <!-- 이벤트 슬라이드 -->
  <div class="slider-wrapper">
    <div id="mainCarousel" class="carousel slide" data-ride="carousel">
      <div class="carousel-inner">
        <div class="carousel-item active" style="background-image: url('./image/ivent1.png');">
          <div class="carousel-caption">
            <h2>연인과 떨리는 데이트</h2>
            <p>오늘 어디를 갈지 모르겠다면?</p>
            <button onclick="location.href='recommendation'">데이트 추천 받기</button>
          </div>
        </div>
        <div class="carousel-item" style="background-image: url('./image/ivent2.png');">
          <div class="carousel-caption">
            <h2>데이트하면 돈을 준다고?</h2>
            <p>DateCock이 데이트 지원비를 쏜다!</p>
            <button>이벤트 참여</button>
          </div>
        </div>
      </div>
      <a class="carousel-control-prev" href="#mainCarousel" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </a>
      <a class="carousel-control-next" href="#mainCarousel" role="button" data-slide="next">
        <span class="carousel-control-next-icon"></span>
      </a>
    </div>
  </div>

  <!-- 방문자 수 -->
  <div style="text-align: left; padding: 20px 40px;">
    <h2 style="font-weight: bold; font-size: 26px;">
      현재 <span id="visitor-count">0</span>명 DateCock을 이용하고 있습니다.
    </h2>
  </div>

  <!-- 데이트코스 슬라이드 -->
  <div class="datecourse-section">
  <h2 class="section-title">오늘의 Best 코스</h2>
  <div class="loop-container">
    <div class="loop-track">
      <%-- 카드 8개 x 2 = 16개 --%>
      <% for (int i = 0; i < 2; i++) { %>
        <div class="loop-slide">
    	 <img src="./image/바운스 트램폴린파크.jfif">
    	  <div class="course-info">
      		<span class="location">1등⭐</span>
      		<h3>바운스 트램폴린 파크</h3>
     	 	<p>서울 강남구 영동대로 325 지하 3층</p>
    	  </div>
	  </div>
        <div class="loop-slide">
          <img src="./image/스파더원.jfif">
          <div class="course-info">
            <span class="location">2등⭐</span>
            <h3>스파더원</h3>
            <p>서울 마포구 어울마당로 55-4 2층</p>
          </div>
        </div>
        <div class="loop-slide">
          <img src="./image/코노미.gif">
          <div class="course-info">
            <span class="location">3등⭐</span>
            <h3>코노미</h3>
            <p>서울 마포구 잔다리로6길 28</p>
          </div>
        </div>
        <div class="loop-slide">
          <img src="./image/영화관.PNG">
          <div class="course-info">
            <span class="location">4등⭐</span>
            <h3>메가박스</h3>
            <p>서울 서초구 서초대로77길 3</p>
          </div>
        </div>
        <div class="loop-slide">
          <img src="./image/반지공방.PNG">
          <div class="course-info">
            <span class="location">5등⭐</span>
            <h3>반지공방 아뜰리에호수</h3>
            <p>서울 마포구 어울마당로 147-1</p>
          </div>
        </div>
        <div class="loop-slide">
          <img src="./image/멘텐.gif">
          <div class="course-info">
            <span class="location">6등⭐</span>
            <h3>멘텐</h3>
            <p>서울 중구 삼일대로 305</p>
          </div>
        </div>
        <div class="loop-slide">
          <img src="./image/명동 실탄사격장.jfif">
          <div class="course-info">
            <span class="location">7등⭐</span>
            <h3>명동 실탄 사격장</h3>
            <p>서울 중구 명동 8가길</p>
          </div>
        </div>
        <div class="loop-slide">
          <img src="./image/요호 도자기공방.jfif">
          <div class="course-info">
            <span class="location">8등⭐</span>
            <h3>요호</h3>
            <p>서울 중구 퇴계로 159-6</p>
          </div>
        </div>
      <% } %>
    </div>
  </div>
</div>
</div>
<!-- JS -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.js"></script>

<script>
const swiper = new Swiper('.courseSwiper', {
  slidesPerView: 'auto',
  spaceBetween: 24,
  loop: true,
  loopedSlides: 16, // 8보다 훨씬 크게, Swiper 내부 복제용
  speed: 8000, // 부드러운 속도
  autoplay: {
    delay: 1, // 0은 버그 유발, 1로 설정
    disableOnInteraction: false
  },
  allowTouchMove: false, // 사용자 조작 막기
  grabCursor: false,
});
</script>


<script>
  function animateNumber(id, start, end, duration) {
    const obj = document.getElementById(id);
    const range = end - start;
    const stepTime = Math.max(Math.floor(duration / range), 10);
    const startTime = new Date().getTime();
    const endTime = startTime + duration;
    const formatter = new Intl.NumberFormat();

    function run() {
      const now = new Date().getTime();
      const remaining = Math.max((endTime - now) / duration, 0);
      const value = Math.round(end - (remaining * range));
      obj.innerText = formatter.format(value);
      if (value === end) clearInterval(timer);
    }

    const timer = setInterval(run, stepTime);
    run();
  }

  animateNumber("visitor-count", 0, 999999, 3000);
</script>

</body>
</html>
