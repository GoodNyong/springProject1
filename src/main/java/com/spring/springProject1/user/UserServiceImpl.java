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
	public void resetLoginFail(String email) {
		userDao.resetLoginFail(email);
	}

	@Override
	public UserVo getUserEmailCheck(String email) {
		return userDao.getUserEmailCheck(email);
	}

	@Override
	public int updatePassword(UserVo vo) {
		return userDao.updatePassword(vo);
	}

	@Override
	public UserVo getUserByUser_id(Integer user_id) {
		return userDao.getUserByUser_id(user_id);
	}

	@Override
	public void setUserInvalid(Integer user_id) {
		userDao.setUserInvalid(user_id);
	}

	@Override
	public void setUserRole(Integer user_id, Integer role_id) {
		userDao.setUserRole(user_id, role_id);
	}

	@Override
	public List<String> getUserRoles(Integer user_id) {
		return userDao.getUserRoles(user_id);
	}
	
}
