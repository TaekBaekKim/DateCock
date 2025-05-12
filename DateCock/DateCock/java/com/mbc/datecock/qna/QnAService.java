package com.mbc.datecock.qna;

import java.util.List;

public interface QnAService {

	List<QnADTO> getUserQnaList();

	List<QnADTO> getBusinessQnaList();

	void insertQna(QnADTO dto);

}
