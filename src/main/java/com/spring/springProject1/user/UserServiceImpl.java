package com.spring.springProject1.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.springProject1.user.dao.UserDao;

@Service
public class UserServiceImpl implements UserService {
	
	@Autowired
	UserDao userDao;

	@Override
	public UserVo getUsernameCheck(String username) {
		return userDao.getUsernameCheck(username);
	}
	
	
}
