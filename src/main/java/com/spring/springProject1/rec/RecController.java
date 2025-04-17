package com.spring.springProject1.rec;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.springProject1.user.UserVo;

@Controller
@RequestMapping("/rec")
public class RecController {

	@Autowired
	private RecService recService;

//	운동 부분

	// 운동 기록 입력 페이지 호출
	@GetMapping("/exerciseRecordInput")
	public String exerciseRecordInputGet() {

		return "rec/exerciseRecordInput";
	}

	// 운동 기록 입력 처리
	@PostMapping("/exerciseRecordInput")
	public String exerciseRecordInputPost(ExerciseRecordVo vo, HttpSession session, RedirectAttributes ra) {
		try {
			vo.setUser_id(((UserVo) session.getAttribute("loginUser")).getUser_id()); // 세션의 loginUser(vo)에서 유저아이디키 가져오기
			recService.setExerciseRecord(vo);
			return "redirect:/message/exerciseRecordInputOk";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "rec/exerciseRecordInput");
			return "redirect:/message/exerciseRecordInputNo";
		}
	}

	// 운동 기록 목록 페이지 호출
	@GetMapping("/exerciseRecordList")
	public String exerciseRecordListGet(HttpSession session, Model model) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null)
			return "redirect:/"; // 비로그인 시 홈으로 이동

		List<ExerciseRecordVo> recordList = recService.getExerciseRecordList(user.getUser_id());
		model.addAttribute("recordList", recordList);

		return "rec/exerciseRecordList";
	}
	



}
