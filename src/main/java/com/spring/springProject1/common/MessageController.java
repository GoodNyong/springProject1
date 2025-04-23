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
		
		if(msgFlag.equals("exerciseRecordInputOk")) {
			model.addAttribute("message", "운동 기록 마법 성공!");
			model.addAttribute("url", "user/main");
		}
		else if(msgFlag.equals("exerciseRecordUpdateOk")) {
			model.addAttribute("message", "단일 운동 기록 수정 마법 성공!");
			model.addAttribute("url", "rec/exerciseRecordList");
		}
		else if(msgFlag.equals("exerciseRecordEditOk")) {
			model.addAttribute("message", "운동 기록 수정 마법 성공!");
			model.addAttribute("url", "rec/exerciseRecordList");
		}
		else if(msgFlag.equals("exerciseRecordDeleteOk")) {
			model.addAttribute("message", "운동 기록 삭제 마법 성공!");
			model.addAttribute("url", "rec/exerciseRecordList");
		}
		else if (msgFlag.equals("exerciseRecordMultiUpdateOk")) {
			model.addAttribute("message", "다중 운동 수정 마법 성공!");
			model.addAttribute("url", "rec/exerciseRecordList");
		}
		else if(msgFlag.equals("exerciseRecordMultiDeleteOk")) {
			model.addAttribute("message", "다중 운동 삭제 마법 성공!");
			model.addAttribute("url", "rec/exerciseRecordList");
		}
		else if(msgFlag.equals("exerciseRecordMultiInputOk")) {
			model.addAttribute("message", "다중 운동 기록 마법 성공!");
			model.addAttribute("url", "rec/exerciseRecordList");
		}
		else if(msgFlag.equals("mealRecordInputOk")) {
			model.addAttribute("message", "식단 기록 마법 성공!");
			model.addAttribute("url", "user/main");
		}
		else if(msgFlag.equals("mealRecordMultiInputOk")) {
			model.addAttribute("message", "다중 식단 기록 마법 성공!");
			model.addAttribute("url", "user/main");
		}
		else if(msgFlag.equals("mealRecordEditOk")) {
			model.addAttribute("message", "식단 기록 수정 마법 성공!");
			model.addAttribute("url", "rec/mealRecordList");
		}
		else if(msgFlag.equals("mealRecordDeleteOk")) {
			model.addAttribute("message", "식단 기록 삭제 마법 성공!");
			model.addAttribute("url", "rec/mealRecordList");
		}
		else if(msgFlag.equals("mealRecordUpdateOk")) {
			model.addAttribute("message", "단일 식단 기록 수정 마법 성공!");
			model.addAttribute("url", "rec/mealRecordList");
		}
		else if(msgFlag.equals("mealRecordMultiUpdateOk")) {
			model.addAttribute("message", "다중 식단 기록 수정 마법 성공!");
			model.addAttribute("url", "rec/mealRecordList");
		}
		else if(msgFlag.equals("mealRecordMultiDeleteOk")) {
			model.addAttribute("message", "다중 식단 기록 삭제 마법 성공!");
			model.addAttribute("url", "rec/mealRecordList");
		}
		else if(msgFlag.equals("goalInputExerciseOk")) {
			model.addAttribute("message", "운동 목표 설정 마법 성공!");
			model.addAttribute("url", "rec/goalListExercise");
		}
		else if(msgFlag.equals("goalEditExerciseOk")) {
			model.addAttribute("message", "운동 목표 수정 마법 성공!");
			model.addAttribute("url", "rec/goalListExercise");
		}
		else if(msgFlag.equals("goalDeleteExerciseOk")) {
			model.addAttribute("message", "운동 목표 삭제 마법 성공!");
			model.addAttribute("url", "rec/goalListExercise");
		}
		else if(msgFlag.equals("error")) {
			model.addAttribute("message", model.asMap().get("message")); // RedirectAttributes에서 받음
			model.addAttribute("url", model.asMap().get("url"));
		}

		
		
		return "include/message";
	}
}
