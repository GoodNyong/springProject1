package com.spring.springProject1.user;

import java.util.List;

public interface UserService {

	UserVo getUsernameCheck(String username);

	int setUserJoinOk(UserVo vo);

	UserVo getUserLoginCheck(String email, String encPassword);

	void increaseLoginFail(String email);

	List<String> getUserRoles(int user_id);

	void resetLoginFail(String email);

	//void getRoleToUser(int user_id, int role_id);


}
