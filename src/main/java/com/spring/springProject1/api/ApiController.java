package com.spring.springProject1.api;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/api")
public class ApiController {

	
	@GetMapping("/test")
	public String testPageGet() {
		return "api/test";
	}
}
