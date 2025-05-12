package com.mbc.datecock.userqna;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.mbc.datecock.board.PageDTO;

@Service
public class UserQnaBoardServiceImpl implements UserQnaBoardService {

    private static final Logger log = LoggerFactory.getLogger(UserQnaBoardServiceImpl.class);
    private static final String NAMESPACE = "com.mbc.datecock.userqna.mapper.UserQnaBoardMapper.";

    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<UserQnaBoardDTO> getUserQnaListPaged(PageDTO pageDTO) throws Exception {
        log.info("Service - listPage 호출, pageDTO: {}", pageDTO);
        List<UserQnaBoardDTO> resultList = sqlSession.selectList(NAMESPACE + "listPage", pageDTO);
        log.info("Service - listPage 결과 수: {}", (resultList != null ? resultList.size() : "null 또는 0"));
        return resultList;
    }

    @Override
    public int getTotalUserQnaCount(PageDTO pageDTO) throws Exception {
        return sqlSession.selectOne(NAMESPACE + "getTotalCount", pageDTO);
    }

    @Override
    @Transactional
    public boolean writeUserQna(UserQnaBoardDTO dto) throws Exception {
        // ... (기존 유효성 검사) ...
        if (dto.getWriter() == null || /* ... */ dto.getContent().trim().isEmpty()) {
            log.warn("writeUserQna - 필수 정보 누락: {}", dto);
            return false;
        }

        // !!! 중요: DB 저장 직전 DTO 상태 로깅 !!!
        log.info("Service - writeUserQna DB 저장 시도 전 DTO: {}", dto);
        log.info("Service - writeUserQna DB 저장 시도 전 imageFile 값: [{}]", dto.getImageFile()); // 대괄호로 감싸서 빈 값 확인 용이

        int result = sqlSession.insert(NAMESPACE + "insert", dto);
        log.info("Service - writeUserQna DB 저장 결과 (0=실패, 1=성공): {}", result);
        if(result != 1) {
             log.warn("Service - writeUserQna DB 저장 실패! DTO: {}", dto); // 실패 시 값 재확인
        }
        return result == 1;
    }


    @Override
    @Transactional
    public UserQnaBoardDTO getUserQnaDetail(int bno, String currentUserId, boolean isAdmin) throws Exception {
        sqlSession.update(NAMESPACE + "increaseViewCnt", bno); // 조회수 증가
        UserQnaBoardDTO dto = sqlSession.selectOne(NAMESPACE + "getDetail", bno);

        if (dto != null && dto.isSecretPost()) { // isSecretPost()는 secret == 1 인지 확인
            if (!isAdmin && (currentUserId == null || !currentUserId.equals(dto.getWriter()))) {
                dto.setContent("비밀글입니다. 작성자와 관리자만 내용을 확인할 수 있습니다.");
            }
        }
        return dto;
    }
    
    @Override
    public UserQnaBoardDTO getUserQnaForAuth(int bno) throws Exception {
        return sqlSession.selectOne(NAMESPACE + "getDetail", bno);
    }


    @Override
    @Transactional
    public boolean updateUserQna(UserQnaBoardDTO dto, String currentUserId, boolean isAdmin) throws Exception {
        UserQnaBoardDTO originalDto = getUserQnaForAuth(dto.getBno());
        // ... (기존 권한 검사) ...
        if (originalDto == null || /* ... */ !currentUserId.equals(originalDto.getWriter()))  {
             // 권한 없음 또는 글 없음 처리
            return false;
        }

        dto.setWriter(originalDto.getWriter()); // 작성자는 원본 유지

        dto.setWriter(originalDto.getWriter());

        // !!! (선택 사항) 서비스 레벨에서 DTO의 답변 관련 필드 초기화 !!!
        dto.setAnswerStatus("답변대기");
        dto.setAnswerContent(null);
        dto.setAnswerWriter(null);
        dto.setAnswerDate(null);
        log.info("Service - updateUserQna: 답변 상태 초기화됨.");

        log.info("Service - updateUserQna DB 업데이트 시도 전 DTO: {}", dto);
        log.info("Service - updateUserQna DB 업데이트 시도 전 imageFile 값: [{}]", dto.getImageFile());

        int result = sqlSession.update(NAMESPACE + "update", dto); // XML에서 이미 초기화하므로 DTO 값은 참고만 됨
        log.info("Service - updateUserQna DB 업데이트 결과 (0=실패, 1=성공): {}", result);
         if(result != 1) {
             log.warn("Service - updateUserQna DB 업데이트 실패! DTO: {}", dto); // 실패 시 값 재확인
        }
        return result == 1;
    }

    @Override
    @Transactional
    public boolean deleteUserQna(int bno, String currentUserId, boolean isAdmin) throws Exception {
        UserQnaBoardDTO originalDto = getUserQnaForAuth(bno);
        if (originalDto == null) {
            log.warn("deleteUserQna - 삭제할 게시글 없음: bno={}", bno);
            return false;
        }
        if (!isAdmin && (currentUserId == null || !currentUserId.equals(originalDto.getWriter()))) {
            log.warn("deleteUserQna - 삭제 권한 없음: bno={}, 요청자={}", bno, currentUserId);
            return false;
        }
        int result = sqlSession.delete(NAMESPACE + "delete", bno);
        return result == 1;
    }

    @Override
    @Transactional
    public boolean saveAnswer(UserQnaBoardDTO dto, String adminId) throws Exception {
        if (dto.getBno() <= 0 || dto.getAnswerContent() == null || dto.getAnswerContent().trim().isEmpty()) {
            log.warn("saveAnswer - 필수 정보 누락 (bno 또는 답변 내용)");
            return false;
        }
        dto.setAnswerWriter(adminId); 
        dto.setAnswerStatus("답변완료"); 
        int result = sqlSession.update(NAMESPACE + "updateAnswer", dto);
        return result == 1;
    }
}