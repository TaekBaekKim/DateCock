package com.mbc.datecock.businesslogin;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service // 스프링 서비스 빈으로 등록!
public class BusinessLoginServiceImpl implements BusinessLoginService {

    @Autowired
    private SqlSession sqlSession; // MyBatis 사용을 위해 SqlSession 주입

    private static final String NAMESPACE = "com.mbc.datecock.businesslogin.BusinessLoginService."; // 매퍼 네임스페이스

    @Override
    public String pwselect(String businessnumber) {
        return sqlSession.selectOne(NAMESPACE + "pwselect", businessnumber);
    }

    @Override
    public String nameselect(String businessnumber) {
        // 매퍼 XML의 nameselect 쿼리 ID와 파라미터 확인
        return sqlSession.selectOne(NAMESPACE + "nameselect", businessnumber);
    }
}