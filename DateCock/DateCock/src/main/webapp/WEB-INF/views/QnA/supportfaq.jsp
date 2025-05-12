<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<ul class="faq-list">
  <li>
    <div class="question">[자주 묻는 질문] 예약 취소는 어떻게 하나요?</div>
    <div class="answer">MY > 예약내역에서 취소 가능합니다.</div>
  </li>
  <li>
    <div class="question">[자주 묻는 질문] 영수증은 어디서 확인하나요?</div>
    <div class="answer">결제 내역에서 확인 가능합니다.</div>
  </li>
  <li>
    <div class="question">[자주 묻는 질문] 후기 작성은 어디서 하나요?</div>
    <div class="answer">데이트 코스 기록에서 가능합니다.</div>
  </li>

</ul>

<script>
  document.querySelectorAll('.question').forEach(q => {
    q.addEventListener('click', () => {
      const answer = q.nextElementSibling;
      answer.style.display = (answer.style.display === 'block') ? 'none' : 'block';
    });
  });
</script>