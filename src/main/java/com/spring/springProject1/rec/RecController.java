package com.spring.springProject1.rec;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
	
	// 운동 기록 단일 수정 처리
	@PostMapping("/exerciseRecordUpdate")
	public String exerciseRecordUpdatePost(ExerciseRecordVo vo, HttpSession session, RedirectAttributes ra) {
		try {
			// 세션에서 user_id 강제 주입 (보안용)
			vo.setUser_id(((UserVo) session.getAttribute("loginUser")).getUser_id());

			recService.updateExerciseRecord(vo);
			return "redirect:/message/exerciseRecordUpdateOk";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/exerciseRecordList");
			return "redirect:/message";
		}
	}

	// 수정 페이지 호출
	@GetMapping("/exerciseRecordEdit")
	public String exerciseRecordEdit(@RequestParam("record_id") int record_id, HttpSession session, Model model) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) return "redirect:/"; // 비로그인 접근 방지

		ExerciseRecordVo vo = recService.getExerciseRecordById(record_id, user.getUser_id());
		if (vo == null) {
			model.addAttribute("message", "해당 기록을 찾을 수 없어요!");
			model.addAttribute("url", "/rec/exerciseRecordList");
			return "include/message";
		}

		model.addAttribute("record", vo);
		return "rec/exerciseRecordEdit"; // 수정 전용 폼 페이지
	}
	
	// 수정 페이지에서 수정 처리
	@PostMapping("/exerciseRecordEdit")
	public String exerciseRecordEditPost(ExerciseRecordVo vo, HttpSession session, RedirectAttributes ra) {
		try {
			// 세션에서 user_id 강제 주입 (보안용)
			vo.setUser_id(((UserVo) session.getAttribute("loginUser")).getUser_id());

			recService.updateExerciseRecord(vo);
			return "redirect:/message/exerciseRecordEditOk";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/exerciseRecordEdit?record_id=" + vo.getRecord_id());
			return "redirect:/message/error";
		}
	}
	
	// 운동 기록 목록에서 삭제 처리
	@GetMapping("/exerciseRecordDelete")
	public String exerciseRecordDelete(@RequestParam("record_id") int record_id,
	                                   HttpSession session, RedirectAttributes ra) {
	    UserVo user = (UserVo) session.getAttribute("loginUser");
	    if (user == null) {
	        ra.addFlashAttribute("message", "로그인이 필요합니다.");
	        ra.addFlashAttribute("url", "/");
	        return "redirect:/message/error";
	    }

	    try {
	        recService.deleteExerciseRecord(record_id, user.getUser_id());
	        return "redirect:/message/exerciseRecordDeleteOk";
	    } catch (IllegalArgumentException e) {
	        ra.addFlashAttribute("message", e.getMessage());
	        ra.addFlashAttribute("url", "/rec/exerciseRecordList");
	        return "redirect:/message/error";
	    }
	}




}
