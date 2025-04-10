package com.spring.springProject1.add;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/add")
public class AddController {

	
	@GetMapping("/test")
	public String testPageGet() {
		return "add/test";
	}
}
