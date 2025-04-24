package com.spring.springProject1.common;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CommonController {
	
	//개인정보 처리방침 페이지 열기
  @GetMapping("/privacyPolicy")
  public String privacyPolicyPage() {
    return "include/privacyPolicy";
  }
}
