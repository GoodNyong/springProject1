package com.spring.springProject1.rec;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.springProject1.rec.dao.RecDao;

@Service
public class RecServiceImpl implements RecService {
	
	@Autowired
	private RecDao recDao;

//	목록 조회
	@Override
	public int setUserBehaviorLogInput(UserBehaviorLogVo vo) {
		return recDao.setUserBehaviorLogInput(vo);
	}

//	입력
	@Override
	public List<UserBehaviorLogVo> getUserBehaviorLogList() {
		return recDao.getUserBehaviorLogList();
	}

	@Override
	public int deleteLog(int id) {
		return recDao.deleteLog(id);
	}
	
	

}
