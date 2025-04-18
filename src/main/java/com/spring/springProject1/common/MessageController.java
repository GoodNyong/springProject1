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
			@RequestParam(name = "tempFlag", defaultValue = "", required = false) String tempFlag,
			@RequestParam(name = "username", defaultValue = "", required = false) String username) {
			
		
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
		else if(msgFlag.equals("updateLogOk")) {
			model.addAttribute("message", "update DB success");
			model.addAttribute("url", "rec/test");
		}
		else if(msgFlag.equals("updateLogNo")) {
			model.addAttribute("message", "update DB failed");
			model.addAttribute("url", "rec/test");
		}
		
		if(msgFlag.equals("userJoinOk")) {
		  model.addAttribute("message", "회원가입이 완료되었습니다. 로그인 해주세요.");
		  model.addAttribute("url", "user/userLogin");
		}
		else if(msgFlag.equals("userJoinNo")) {
		  model.addAttribute("message", "회원가입에 실패했습니다.");
		  model.addAttribute("url", "user/userJoin");
		}
		else if(msgFlag.equals("usernameCheckNo")) {
		  model.addAttribute("message", "이미 사용 중인 닉네임입니다.");
		  model.addAttribute("url", "user/userJoin");
		}
		else if(msgFlag.equals("emailCheckNo")) {
		  model.addAttribute("message", "이메일 인증을 먼저 완료해주세요.");
		  model.addAttribute("url", "user/userJoin");
		}
		else if(msgFlag.equals("passwordEncryptNo")) {
		  model.addAttribute("message", "비밀번호 암호화 중 오류가 발생했습니다.");
		  model.addAttribute("url", "user/userJoin");
		}
		else if(msgFlag.equals("userLoginOk")) {
		  model.addAttribute("message", username + "님, 환영합니다! 로그인에 성공했습니다.");
		  model.addAttribute("url", "user/main");
		}
		else if(msgFlag.equals("increaseLoginFail")) {
		  model.addAttribute("message", "이메일 또는 비밀번호가 일치하지 않습니다.");
		  model.addAttribute("url", "user/userLogin");
		}
		else if(msgFlag.equals("LoginLocked")) {
		  model.addAttribute("message", "로그인 실패가 5회 이상입니다. 계정이 잠겼습니다.\n비밀번호찾기를 통해 재설정하세요.");
		  model.addAttribute("url", "user/userLogin");
		}
		else if(msgFlag.equals("reCaptchaNo")) {
		  model.addAttribute("message", "자동 인증(CAPTCHA)을 통과하지 못했습니다.");
		  model.addAttribute("url", "user/userLogin");
		}
		
		return "include/message";
	}
}
