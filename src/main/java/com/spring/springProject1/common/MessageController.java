package com.spring.springProject1.common;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MessageController {

	@RequestMapping(value = "/message/{msgFlag}", method = RequestMethod.GET)
	public String getMessage(Model model, @PathVariable String msgFlag, HttpSession session,
			@RequestParam(name = "mid", defaultValue = "", required = false) String mid,
			@RequestParam(name = "idx", defaultValue = "0", required = false) int idx,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "search", defaultValue = "", required = false) String search,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString,
			@RequestParam(name = "part", defaultValue = "전체", required = false) String part,
			@RequestParam(name = "mSw", defaultValue = "1", required = false) String mSw,
			@RequestParam(name = "tempFlag", defaultValue = "", required = false) String tempFlag) {
		
		if(msgFlag.equals("userBehaviorLogInputOk")) {
			model.addAttribute("message", "insert DB success");
			model.addAttribute("url", "rec/test");
		}
		else if(msgFlag.equals("userBehaviorLogInputNo")) {
			model.addAttribute("message", "insert DB failed");
			model.addAttribute("url", "rec/test");
		}
		else if(msgFlag.equals("deleteLogOk")) {
			model.addAttribute("message", "delete DB success");
			model.addAttribute("url", "rec/test");
		}
		else if(msgFlag.equals("deleteLogNo")) {
			model.addAttribute("message", "delete DB failed");
			model.addAttribute("url", "rec/test");
		}
		
		return "include/message";
	}
}
