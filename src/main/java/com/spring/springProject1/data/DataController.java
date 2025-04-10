package com.spring.springProject1.data;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/data")
public class DataController {

	
	@GetMapping("/test")
	public String testPageGet() {
		return "data/test";
	}
}
