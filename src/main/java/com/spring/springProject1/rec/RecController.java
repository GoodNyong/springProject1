package com.spring.springProject1.rec;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
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

//	운동 부분----------------------------------------------------------------

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

		List<ExerciseRecordVo> exerciseRecordList = recService.getExerciseRecordList(user.getUser_id());
		model.addAttribute("exerciseRecordList", exerciseRecordList);

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

	// 운동 기록 수정 페이지 호출
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
	
	// 운동 기록 수정 페이지에서 수정 처리
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

	// 운동 기록 목록에서 다중 수정하기
	@PostMapping("/exerciseRecordMultiUpdate")
	public String exerciseRecordMultiUpdatePost(@ModelAttribute ExerciseRecordListWrapper exerciseRecordListWrapper,
	                                            HttpSession session, RedirectAttributes ra) {
	    UserVo user = (UserVo) session.getAttribute("loginUser");

	    if (user == null) {
	        ra.addFlashAttribute("message", "로그인이 필요합니다.");
	        ra.addFlashAttribute("url", "/");
	        return "redirect:/message/error";
	    }

	    try {
	        List<ExerciseRecordVo> exerciseRecordList = exerciseRecordListWrapper.getExerciseRecordList();
	        for (ExerciseRecordVo vo : exerciseRecordList) {
	            vo.setUser_id(user.getUser_id());
	        }

	        recService.multiUpdateExerciseRecord(exerciseRecordList);
	        return "redirect:/message/exerciseRecordMultiUpdateOk";

	    } catch (Exception e) {
	        e.printStackTrace();
	        ra.addFlashAttribute("message", e.getMessage());
	        ra.addFlashAttribute("url", "/rec/exerciseRecordList");
	        return "redirect:/message/error";
	    }
	}

	// 운동 기록 목록에서 다중 삭제하기
	@PostMapping("/exerciseRecordMultiDelete")
	public String exerciseRecordMultiDeletePost(HttpServletRequest request, HttpSession session, RedirectAttributes ra) {
	    UserVo user = (UserVo) session.getAttribute("loginUser");

	    if (user == null) {
	        ra.addFlashAttribute("message", "로그인이 필요합니다.");
	        ra.addFlashAttribute("url", "/");
	        return "redirect:/message/error";
	    }

	    try {
	        recService.multiDeleteExerciseRecord(request, user.getUser_id());  // 요청 객체 통째로 위임
	        return "redirect:/message/exerciseRecordMultiDeleteOk";
	    } catch (Exception e) {
	        ra.addFlashAttribute("message", e.getMessage());
	        ra.addFlashAttribute("url", "/rec/exerciseRecordList");
	        return "redirect:/message/error";
	    }
	}

	@GetMapping("/exerciseRecordMultiInput")
	public String exerciseRecordMultiInputGet() {
		return "rec/exerciseRecordMultiInput";
	}

	// 다중 운동 기록 입력 처리
	@PostMapping("/exerciseRecordMultiInput")
	public String exerciseRecordMultiInputPost(@ModelAttribute ExerciseRecordListWrapper exerciseRecordListWrapper,
	                                           HttpSession session, RedirectAttributes ra) {
	    UserVo user = (UserVo) session.getAttribute("loginUser");
	    if (user == null) {
	        ra.addFlashAttribute("message", "로그인이 필요합니다.");
	        ra.addFlashAttribute("url", "/");
	        return "redirect:/message/error";
	    }

	    try {
	        List<ExerciseRecordVo> list = exerciseRecordListWrapper.getExerciseRecordList();
	        for (ExerciseRecordVo vo : list) {
	            vo.setUser_id(user.getUser_id());
	        }

	        recService.multiSetExerciseRecord(list);
	        return "redirect:/message/exerciseRecordMultiInputOk";
	    } catch (Exception e) {
	        ra.addFlashAttribute("message", e.getMessage());
	        ra.addFlashAttribute("url", "/rec/exerciseRecordMultiInput");
	        return "redirect:/message/error";
	    }
	}
	
// 식단 부분----------------------------------------------------------------
	
	// 식단 기록 단일 입력 페이지 호출
	@GetMapping("/mealRecordInput")
	public String mealRecordInputGet() {
	    return "rec/mealRecordInput";
	}
	
	// 식닥 기록 단일 입력 처리
	@PostMapping("/mealRecordInput")
	public String mealRecordInputPost(MealRecordVo vo, HttpSession session, RedirectAttributes ra) {
		try {
			// 로그인 사용자 ID 주입
			UserVo loginUser = (UserVo) session.getAttribute("loginUser");
			if (loginUser == null) throw new IllegalArgumentException("로그인이 필요합니다.");

			vo.setUser_id(loginUser.getUser_id());

			recService.setMealRecord(vo);
			return "redirect:/message/mealRecordInputOk";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/mealRecordInput");
			return "redirect:/message";
		}
	}

	// 식단 기록 목록 조회
	@GetMapping("/mealRecordList")
	public String mealRecordListGet(Model model, HttpSession session) {
		UserVo loginUser = (UserVo) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/user/login";
		}

		int userId = loginUser.getUser_id();
		List<MealRecordVo> mealRecordList = recService.getMealRecordList(userId);
		model.addAttribute("mealRecordList", mealRecordList);
		return "rec/mealRecordList";
	}

	// 식단 다중 입력 페이지 호출
	@GetMapping("/mealRecordMultiInput")
	public String mealRecordMultiInputGet(HttpSession session) {
		UserVo loginUser = (UserVo) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/user/login";
		}
		return "rec/mealRecordMultiInput";
	}

	// 다중 식단 입력 처리
	@PostMapping("/mealRecordMultiInput")
	public String mealRecordMultiInputPost(@ModelAttribute MealRecordListWrapper mealRecordListWrapper,
	                                       HttpSession session, RedirectAttributes ra) {
		UserVo loginUser = (UserVo) session.getAttribute("loginUser");
		if (loginUser == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/user/login");
			return "redirect:/message/error";
		}

		try {
			List<MealRecordVo> list = mealRecordListWrapper.getMealRecordList();
			for (MealRecordVo vo : list) {
				vo.setUser_id(loginUser.getUser_id());
			}
			recService.multiSetMealRecord(list);
			return "redirect:/message/mealRecordMultiInputOk";
		} catch (Exception e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/mealRecordMultiInput");
			return "redirect:/message/error";
		}
	}

	// 식단 기록 수정 페이지 호출
	@GetMapping("/mealRecordEdit")
	public String mealRecordEdit(@RequestParam("record_id") int meal_id, HttpSession session, Model model) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) return "redirect:/"; // 비로그인 접근 방지

		MealRecordVo vo = recService.getMealRecordById(meal_id, user.getUser_id());
		if (vo == null) {
			model.addAttribute("message", "해당 식단 기록을 찾을 수 없어요!");
			model.addAttribute("url", "/rec/mealRecordList");
			return "include/message";
		}
		
		model.addAttribute("record", vo);
		return "rec/mealRecordEdit"; // 수정 전용 폼 페이지
	}
	
	// 식단 기록 수정 처리
	@PostMapping("/mealRecordEdit")
	public String mealRecordEditPost(MealRecordVo vo, HttpSession session, RedirectAttributes ra) {
		try {
			// 세션에서 user_id 강제 주입 (보안 강화)
			vo.setUser_id(((UserVo) session.getAttribute("loginUser")).getUser_id());

			recService.updateMealRecord(vo);
			return "redirect:/message/mealRecordEditOk"; // 성공 메시지 리디렉션
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/mealRecordEdit?record_id=" + vo.getMeal_id());
			return "redirect:/message/error";
		}
	}

	// 식단 기록 단일 삭제
	@GetMapping("/mealRecordDelete")
	public String mealRecordDelete(@RequestParam("record_id") int mealId, HttpSession session, Model model) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) return "redirect:/"; // 비로그인 접근 방지

		try {
			recService.deleteMealRecord(mealId, user.getUser_id());
			return "redirect:/message/mealRecordDeleteOk";
		} catch (IllegalArgumentException e) {
			model.addAttribute("message", e.getMessage());
			model.addAttribute("url", "/rec/mealRecordList");
			return "include/message/error";
		}
	}
	
	// 식단 기록 단일 수정 처리
	@PostMapping("/mealRecordUpdate")
	public String mealRecordUpdatePost(MealRecordVo vo, HttpSession session, RedirectAttributes ra) {
		try {
			vo.setUser_id(((UserVo) session.getAttribute("loginUser")).getUser_id());
			recService.updateMealRecord(vo);
			return "redirect:/message/mealRecordUpdateOk";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/mealRecordList");
			return "redirect:/message/error";
		}
	}

	// 식단 기록 다중 수정 처리
	@PostMapping("/mealRecordMultiUpdate")
	public String mealRecordMultiUpdatePost(@ModelAttribute MealRecordListWrapper mealRecordListWrapper,
	                                        HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");

		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}

		try {
			List<MealRecordVo> list = mealRecordListWrapper.getMealRecordList();
			for (MealRecordVo vo : list) {
				vo.setUser_id(user.getUser_id());
			}

			recService.multiUpdateMealRecord(list);
			return "redirect:/message/mealRecordMultiUpdateOk";

		} catch (Exception e) {
			e.printStackTrace();
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/mealRecordList");
			return "redirect:/message/error";
		}
	}

	// 식단 기록 다중 삭제 처리
	@PostMapping("/mealRecordMultiDelete")
	public String mealRecordMultiDelete(HttpServletRequest request, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message";
		}

		try {
			recService.multiDeleteMealRecord(request, user.getUser_id());
			return "redirect:/message/mealRecordMultiDeleteOk";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/mealRecordList");
			return "redirect:/message/error";
		}
	}

// 목표 부분----------------------------------------------------------------
	
	// 목표 설정 허브 페이지 호출
	@GetMapping("/goalInput")
	public String goalInputPageGet(HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		return "rec/goalInput";
	}

	// 목표 목록 허브 페이지 호출
	@GetMapping("/goalList")
	public String goalListPageGet(HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		return "rec/goalList";
	}


}
