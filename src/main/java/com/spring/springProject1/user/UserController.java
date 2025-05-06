package com.spring.springProject1.user;

import java.util.Date;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.springProject1.rec.RecService;

@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	private RecService recService;
	
	@GetMapping("/main")
	public String mainPageGet(HttpSession session, Model model) {
	    UserVo loginUser = new UserVo();
	    loginUser.setUser_id(1); // 존재하는 더미 유저 ID
	    loginUser.setUsername("테스트유저");
	    loginUser.setEmail("test@example.com");
	    loginUser.setPassword("encryptedPw"); // 실제 비밀번호는 무관
	    loginUser.setPhone_number("01012345678");
	    loginUser.set_verified(true);
	    loginUser.setCreated_at(new Date());
	    loginUser.setUpdated_at(new Date());
	    loginUser.set_premium(false);

	    session.setAttribute("loginUser", loginUser);
	    
	    int userId = loginUser.getUser_id();
	    double exerciseRate = recService.getExerciseGoalAchievementRate(userId);
	    double mealRate = recService.getMealGoalAchievementRate(userId);
	    
	    model.addAttribute("exerciseRate", (int) exerciseRate);
	    model.addAttribute("mealRate", (int) mealRate);
	    
		return "user/main";
	}
	
	// user 등록폼
	@RequestMapping(value = "/userInput", method = RequestMethod.GET)
	public String userInputGet() {
		return "user/userInput";
	}
	
	@GetMapping("/logout")
	public String logoutGet(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
}
