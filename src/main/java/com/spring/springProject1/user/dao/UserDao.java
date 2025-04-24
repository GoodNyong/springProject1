package com.spring.springProject1.user.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.springProject1.user.UserVo;

public interface UserDao {

	UserVo getUsernameCheck(@Param("username") String username);

	int setUserJoinOk(@Param("vo") UserVo vo);

	UserVo getUserLoginCheck(@Param("email") String email, @Param("encPassword") String encPassword);

	void increaseLoginFail(@Param("email") String email);

	void resetLoginFail(@Param("email") String email);

	UserVo getUserEmailCheck(@Param("email") String email);

	int updatePassword(@Param("vo") UserVo vo);

	UserVo getUserByUser_id(@Param("user_id") Integer user_id);

	void setUserInvalid(@Param("user_id") Integer user_id);

	void setUserRole(@Param("user_id") Integer user_id, @Param("role_id") Integer role_id);

	List<String> getUserRoles(@Param("user_id") Integer user_id);


	//void getRoleToUser(@Param("user_id") int user_id, @Param("role_id") int role_id);


}
