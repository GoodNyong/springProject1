package com.spring.springProject1.user;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/user")
public class UserController {

	
	@GetMapping("/main")
	public String testPageGet() {
		return "user/main";
	}
	
	// user 등록폼
	@RequestMapping(value = "/userInput", method = RequestMethod.GET)
	public String userInputGet() {
		return "user/userInput";
	}
	
}
