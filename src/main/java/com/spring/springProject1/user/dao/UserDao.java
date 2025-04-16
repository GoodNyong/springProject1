package com.spring.springProject1.user.dao;

import org.apache.ibatis.annotations.Param;

import com.spring.springProject1.user.UserVo;

public interface UserDao {

	UserVo getUsernameCheck(@Param("username") String username);

}
