<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<ul class="faq-list">
  <c:choose>
    <c:when test="${empty list}">
      <li><div class="question">등록된 사용자 QnA가 없습니다.</div></li>
    </c:when>
    <c:otherwise>
      <c:forEach var="dto" items="${list}">
        <li>
          <div class="question">[사용자 QnA] ${dto.title}</div>
          <div class="answer">
            <p>${dto.content}</p>
            <c:if test="${not empty dto.answer}">
              <hr>
              <p><strong>답변:</strong> ${dto.answer}</p>
            </c:if>
            <p style="font-size: 12px; color: #888;">
              작성자: ${dto.writer} |
              <fmt:formatDate value="${dto.regdate}" pattern="yyyy-MM-dd" />
            </p>
          </div>
        </li>
      </c:forEach>
    </c:otherwise>
  </c:choose>
</ul>

<script>
  document.querySelectorAll('.question').forEach(q => {
    q.addEventListener('click', () => {
      const answer = q.nextElementSibling;
      answer.style.display = (answer.style.display === 'block') ? 'none' : 'block';
    });
  });
</script>
