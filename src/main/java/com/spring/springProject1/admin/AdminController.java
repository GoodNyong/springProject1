package com.spring.springProject1.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

	
	@GetMapping("/test")
	public String testPageGet() {
		return "admin/test";
	}
}
