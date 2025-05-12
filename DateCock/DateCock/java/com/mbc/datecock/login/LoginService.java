package com.mbc.datecock.login;

import com.mbc.datecock.member.MemberDTO;

public interface LoginService {

	String pwselect(String id);

	String nameselect(String id);

	Integer getAdminStatus(String id);

}
