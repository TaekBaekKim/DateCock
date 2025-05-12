<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>공지사항</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
  <style>
    * {
      box-sizing: border-box;
      font-family: 'Noto Sans KR', sans-serif;
      margin: 0;
      padding: 0;
    }
    body {
      background-color: #fff;
      padding: 20px;
      color: #333;
    }
    .notice-container {
      width: 600px;
      margin: 40px auto;
      background-color: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 0 15px rgba(0,0,0,0.1);
    }
    .notice-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 2px solid #000;
      padding: 10px 0 20px;
      margin-bottom: 20px;
    }
    .notice-header h1 {
      font-size: 24px;
      font-weight: bold;
    }
    .notice-list {
      list-style: none;
    }
    .notice-item {
      border-bottom: 1px solid #ddd;
      padding: 16px 0;
      cursor: pointer;
      transition: background-color 0.2s ease-in-out;
    }
    .notice-item:hover {
      background-color: #f9f9f9;
    }
    .notice-title {
      font-size: 16px;
      font-weight: 500;
      margin-bottom: 5px;
    }
    .notice-date {
      font-size: 13px;
      color: #999;
    }
    .notice-toggle {
      float: right;
      font-size: 20px;
      transform: rotate(0);
      transition: transform 0.3s;
    }
    .notice-item.open .notice-toggle {
      transform: rotate(180deg);
    }
    .notice-content {
      display: none;
      font-size: 14px;
      color: #444;
      margin-top: 10px;
    }
    .notice-item.open .notice-content {
      display: block;
    }
    .notice-header .close-btn {
      font-size: 24px;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <div class="notice-container">
    <div class="notice-header">
      <h1>공지사항</h1>
      <div class="close-btn" onclick="location.href='businessmypage'">&#10005;</div>
    </div>

    <ul class="notice-list">
      <li class="notice-item">
        <div class="notice-title">데이트 콕 이용약관 개정 안내(5/22 시행) <span class="notice-toggle">▼</span></div>
        <div class="notice-date">2025-04-15</div>
        <div class="notice-content">
          약관 변경 내용 및 전문은 고객센터 > 공지사항에서 확인하실 수 있습니다.
        </div>
      </li>
      <li class="notice-item">
        <div class="notice-title">커플 파손으로 인한 일부 지역 배송 제한 안내 (5/11 시행)<span class="notice-toggle">▼</span></div>
        <div class="notice-date">2025-04-10</div>
        <div class="notice-content">
          배송 불가지역 안내 및 대체 배송 방법에 대한 안내입니다.
        </div>
      </li>
      <li class="notice-item">
        <div class="notice-title">if (정신이_지옥에_갇혀있다면) { <span class="notice-toggle">▼</span></div>
        <div class="notice-date">2025-04-10</div>
        <div class="notice-content">
          System.out.println("😂 인증메일로 탈출하세요. 비밀번호는 운명이다."); }
        </div>
      </li>
      <li class="notice-item">
        <div class="notice-title">라면 맛있게 끓이는 방법 SUPER EASY (4/4 시행)<span class="notice-toggle">▼</span></div>
        <div class="notice-date">2025-04-10</div>
        <div class="notice-content">
          정성껏 끓인다.
        </div>
      </li>
      <li class="notice-item">
        <div class="notice-title">데이트 코스 기능패치 안내 (3/1 시행)<span class="notice-toggle">▼</span></div>
        <div class="notice-date">2025-04-10</div>
        <div class="notice-content">
          즐기세요.
        </div>
      </li>
      <li class="notice-item">
        <div class="notice-title">데이트 코스 게시판 안내 (3/1 시행)<span class="notice-toggle">▼</span></div>
        <div class="notice-date">2025-04-10</div>
        <div class="notice-content">
          이웃을 사랑합시다.
        </div>
      </li>
      <li class="notice-item">
        <div class="notice-title">자유 게시판 이용안내 (2/27 시행)<span class="notice-toggle">▼</span></div>
        <div class="notice-date">2025-04-10</div>
        <div class="notice-content">
          왼손이 하는 일을 오른손이 모르게 하세요.
        </div>
      </li>
      <li class="notice-item">
        <div class="notice-title">장기 휴먼이용자 안내 (2025/1/1 시행)<span class="notice-toggle">▼</span></div>
        <div class="notice-date">2025-04-10</div>
        <div class="notice-content">
          잘가세요.
        </div>
      </li>
      <li class="notice-item">
        <div class="notice-title">가나다라 마바사 (12/3 시행)<span class="notice-toggle">▼</span></div>
        <div class="notice-date">2025-04-10</div>
        <div class="notice-content">
          아자차카 타파하
        </div>
      </li>
      </li>
      <li class="notice-item">
        <div class="notice-title">알고 계셨나요? (12/1 시행)<span class="notice-toggle">▼</span></div>
        <div class="notice-date">2025-04-10</div>
        <div class="notice-content">
          번개는 두 번 칩니다.
        </div>
      </li>

    </ul>
  </div>

  <script>
    const noticeItems = document.querySelectorAll('.notice-item');

    noticeItems.forEach(item => {
      item.addEventListener('click', () => {
        item.classList.toggle('open');
      });
    });
  </script>
</body>
</html>