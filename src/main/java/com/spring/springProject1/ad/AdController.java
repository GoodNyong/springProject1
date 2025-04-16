package com.spring.springProject1.ad;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/ad")
public class AdController {

	
	@GetMapping("/test")
	public String testPageGet() {
		return "ad/test";
	}
}
