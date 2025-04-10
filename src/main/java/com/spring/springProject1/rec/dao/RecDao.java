package com.spring.springProject1.rec.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.springProject1.rec.UserBehaviorLogVo;

public interface RecDao {

	int setUserBehaviorLogInput(@Param("vo") UserBehaviorLogVo vo);

	List<UserBehaviorLogVo> getUserBehaviorLogList();

	int deleteLog(@Param("id") int id);

}
