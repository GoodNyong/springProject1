package com.spring.springProject1.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.springProject1.admin.dao.AdminDao;

@Service
public class AdminServiceImpl implements AdminService {
	@Autowired
	AdminDao adminDao;
}
