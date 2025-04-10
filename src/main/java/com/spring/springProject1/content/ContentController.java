package com.spring.springProject1.content;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/content")
public class ContentController {

	
	@GetMapping("/test")
	public String testPageGet() {
		return "content/test";
	}
}
