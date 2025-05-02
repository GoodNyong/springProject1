package com.spring.springProject1.user;

import java.util.List;

public interface UserService {

	UserVo getUsernameCheck(String username);

	int setUserJoinOk(UserVo vo);

	UserVo getUserLoginCheck(String email, String encPassword);

	void increaseLoginFail(String email);

	void resetLoginFail(String email);

	UserVo getUserEmailCheck(String email);

	int updatePassword(UserVo vo);

	UserVo getUserByUser_id(Integer user_id);

	void setUserInvalid(Integer user_id);

	void setUserRole(Integer user_id, Integer role_id);

	List<String> getUserRoles(Integer user_id);

	int updateUser(UserVo vo);

}
