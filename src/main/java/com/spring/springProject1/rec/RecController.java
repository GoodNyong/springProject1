package com.spring.springProject1.rec;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/rec")
public class RecController {

	@Autowired
	private RecService recService;

	@GetMapping("/test")
	public String testPageGet(Model model) {
		List<UserBehaviorLogVo> logList = recService.getUserBehaviorLogList();
		model.addAttribute("logList", logList);
		return "rec/test";
	}

	// user 등록 처리
	@RequestMapping(value = "/test", method = RequestMethod.POST)
	public String testPost(UserBehaviorLogVo vo) {
		// 회원가입 처리
		int res = recService.setUserBehaviorLogInput(vo);
		if (res != 0) return "redirect:/message/userBehaviorLogInputOk";
		else return "redirect:/message/userBehaviorLogInputNo";
	}
	
//	@GetMapping("/updateForm")
//	public String updateForm(@RequestParam("behavior_id") int id, Model model) {
//	    UserBehaviorLogVo vo = recService.getLogById(id);
//	    model.addAttribute("vo", vo);
//	    return "rec/updateForm";
//	}

	@GetMapping("/delete")
	public String deleteLog(@RequestParam("behavior_id") int id) {
		// 회원가입 처리
		int res = recService.deleteLog(id);
		if (res != 0) return "redirect:/message/deleteLogOk";
		else return "redirect:/message/deleteLogNo";
	}


}
