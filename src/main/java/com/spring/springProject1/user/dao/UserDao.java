package com.spring.springProject1.user.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.springProject1.user.UserVo;

public interface UserDao {

	UserVo getUsernameCheck(@Param("username") String username);

	int setUserJoinOk(@Param("vo") UserVo vo);

	UserVo getUserLoginCheck(@Param("email") String email, @Param("encPassword") String encPassword);

	void increaseLoginFail(@Param("email") String email);

	List<String> getUserRoles(@Param("user_id") int user_id);

	void resetLoginFail(@Param("email") String email);

	//void getRoleToUser(@Param("user_id") int user_id, @Param("role_id") int role_id);


}
