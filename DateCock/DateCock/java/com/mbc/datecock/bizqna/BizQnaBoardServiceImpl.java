package com.mbc.datecock.bizqna;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mbc.datecock.board.PageDTO;
import com.mbc.datecock.businesslogin.BusinessLoginService; // *** BusinessLoginService 임포트 ***

@Service
public class BizQnaBoardServiceImpl implements BizQnaBoardService {

    private static final Logger log = LoggerFactory.getLogger(BizQnaBoardServiceImpl.class);
    private static final String NAMESPACE = "com.mbc.datecock.bizqna.mapper.BizQnaBoardMapper.";

    @Autowired
    private SqlSession sqlSession;

    // *** 글 작성 시 사업자명 조회를 위해 BusinessLoginService 주입 ***
    @Autowired(required = true)
    private BusinessLoginService businessLoginService;

    // getBizQnaListPaged, getTotalBizQnaCount 는 Mapper에서 businessName을 가져오므로 Service 수정 불필요
    @Override
    public List<BizQnaBoardDTO> getBizQnaListPaged(PageDTO pageDTO) throws Exception {
        log.info("BizQnaService - listPage 호출, pageDTO: {}", pageDTO);
        List<BizQnaBoardDTO> resultList = sqlSession.selectList(NAMESPACE + "listPage", pageDTO);
        log.info("BizQnaService - listPage 결과 수: {}", (resultList != null ? resultList.size() : "null 또는 0"));
        // 이제 DTO에 businessName 필드가 Mapper에 의해 채워짐
        return resultList;
    }

    @Override
    public int getTotalBizQnaCount(PageDTO pageDTO) throws Exception {
        return sqlSession.selectOne(NAMESPACE + "getTotalCount", pageDTO);
    }

    @Override
    @Transactional
    public boolean writeBizQna(BizQnaBoardDTO dto) throws Exception {
        // secret 필드 null 처리
        if (dto.getSecret() == null) {
            dto.setSecret(0);
        }

        // 유효성 검사
        if (dto.getWriter() == null || dto.getWriter().trim().isEmpty() ||
            dto.getTitle() == null || dto.getTitle().trim().isEmpty() ||
            dto.getContent() == null || dto.getContent().trim().isEmpty()) {
            log.warn("writeBizQna - 필수 정보 누락: {}", dto);
            return false;
        }

        // *** 추가: 작성자(writer) 기반으로 사업자명(businessName) 설정 ***
        String writerId = dto.getWriter();
        String businessName = null; // DB에 저장될 이름

        // TODO: 관리자 ID 구별 로직 필요 (ServiceImpl의 populateWriterDisplayName 예시 참고)
     // 수정 제안: writerId가 숫자로만 이루어져 있으면 사업자로 간주, 아니면 관리자로 간주
     // (실제 관리자 ID가 문자를 포함한다는 가정 하에)
        boolean isBusinessUserByIdFormat = (writerId != null && writerId.matches("\\d+")); // 숫자만으로 구성되었는지 확인

        if (isBusinessUserByIdFormat && businessLoginService != null) { // 사업자 번호 형식이라고 판단되면
            try {
                businessName = businessLoginService.nameselect(writerId);
                log.info("사업자 번호 '{}'의 이름 '{}' 조회 성공.", writerId, businessName);
            } catch (Exception e) {
                log.error("글 작성 시 사업자 이름 조회 오류 (사업자 번호: {}): {}", writerId, e.getMessage());
                // 이름 조회 실패 시 DB에 null 저장 (또는 기본값 설정 가능)
            }
        } else { // 사업자 번호 형식이 아니라고 판단되면 (관리자 또는 기타 ID로 간주)
            log.info("[Service-writeBizQna] 작성자 '{}'는 사업자번호 형식이 아니므로(관리자 등), Controller에서 설정된 값 또는 기본값 처리.", writerId);
            businessName = dto.getBusinessName(); 
        }
        // *** ----------------------------------------------- ***

        log.info("BizQnaService - writeBizQna DB 저장 시도 전 DTO: {}", dto);
        int result = sqlSession.insert(NAMESPACE + "insert", dto); // Mapper 호출
        log.info("BizQnaService - writeBizQna DB 저장 결과 (0=실패, 1=성공): {}", result);
        return result == 1;
    }

    // getBizQnaDetail, getBizQnaForAuth 는 Mapper에서 businessName을 가져오므로 Service 수정 불필요
    @Override
    @Transactional
    public BizQnaBoardDTO getBizQnaDetail(int bno, String currentUserId, boolean isAdmin) throws Exception {
        sqlSession.update(NAMESPACE + "increaseViewCnt", bno);
        BizQnaBoardDTO dto = sqlSession.selectOne(NAMESPACE + "getDetail", bno);

        if (dto != null) {
            // 비밀글 내용 처리
            if (dto.isSecretPost()) {
                if (!isAdmin && (currentUserId == null || !currentUserId.equals(dto.getWriter()))) {
                    dto.setContent("비밀글입니다. 작성자와 관리자만 내용을 확인할 수 있습니다.");
                }
            }
        }
        return dto;
    }

    @Override
    public BizQnaBoardDTO getBizQnaForAuth(int bno) throws Exception {
        return sqlSession.selectOne(NAMESPACE + "getDetail", bno);
    }

    // updateBizQna, deleteBizQna, saveAnswer 는 businessName을 직접 수정하지 않으므로 그대로 둠
     @Override
    @Transactional
    public boolean updateBizQna(BizQnaBoardDTO dto, String currentUserId, boolean isAdmin) throws Exception {
        BizQnaBoardDTO originalDto = getBizQnaForAuth(dto.getBno());
        if (originalDto == null) { /* ... */ return false; }
        if (!isAdmin && (currentUserId == null || !currentUserId.equals(originalDto.getWriter()))) { /* ... */ return false; }

        dto.setWriter(originalDto.getWriter()); // 작성자 ID/번호는 원본 유지
        // businessName은 update 쿼리에서 제외했으므로 DTO에 있더라도 변경되지 않음

        log.info("BizQnaService - updateBizQna DB 업데이트 시도 전 DTO: {}", dto);
        int result = sqlSession.update(NAMESPACE + "update", dto);
        log.info("BizQnaService - updateBizQna DB 업데이트 결과 (0=실패, 1=성공): {}", result);
        return result == 1;
    }

     @Override
    @Transactional
    public boolean deleteBizQna(int bno, String currentUserId, boolean isAdmin) throws Exception {
         BizQnaBoardDTO originalDto = getBizQnaForAuth(bno);
        if (originalDto == null) { /* ... */ return false; }
        if (!isAdmin && (currentUserId == null || !currentUserId.equals(originalDto.getWriter()))) { /* ... */ return false; }
        int result = sqlSession.delete(NAMESPACE + "delete", bno);
        return result == 1;
    }

     @Override
    @Transactional
    public boolean saveAnswer(BizQnaBoardDTO dto, String adminId) throws Exception {
         if (dto.getBno() <= 0 || dto.getAnswerContent() == null || dto.getAnswerContent().trim().isEmpty()) { /* ... */ return false; }
        dto.setAnswerWriter(adminId);
        dto.setAnswerStatus("답변완료");
        int result = sqlSession.update(NAMESPACE + "updateAnswer", dto);
        return result == 1;
    }
}