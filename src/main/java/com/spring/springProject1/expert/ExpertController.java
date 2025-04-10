package com.spring.springProject1.expert;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/expert")
public class ExpertController {

	
	@GetMapping("/test")
	public String testPageGet() {
		return "expert/test";
	}
}
