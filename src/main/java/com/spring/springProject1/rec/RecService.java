package com.spring.springProject1.rec;

import java.util.List;

public interface RecService {

	int setUserBehaviorLogInput(UserBehaviorLogVo vo);

	List<UserBehaviorLogVo> getUserBehaviorLogList();

	int deleteLog(int id);


}
