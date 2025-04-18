package com.spring.springProject1.user;

import java.util.List;

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

	@Override
	public int setUserJoinOk(UserVo vo) {
		return userDao.setUserJoinOk(vo);
	}

	@Override
	public UserVo getUserLoginCheck(String email, String encPassword) {
		return userDao.getUserLoginCheck(email, encPassword);
	}

	@Override
	public void increaseLoginFail(String email) {
		userDao.increaseLoginFail(email);
	}

	@Override
	public List<String> getUserRoles(int user_id) {
		return userDao.getUserRoles(user_id);
	}

	@Override
	public void resetLoginFail(String email) {
		userDao.resetLoginFail(email);
	}

	/*
	 * @Override public void getRoleToUser(int user_id, int role_id) {
	 * userDao.getRoleToUser(user_id, role_id); }
	 */
	
	
}
