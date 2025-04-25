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

import com.spring.springProject1.common.eNum.NutrientEnum;
import com.spring.springProject1.common.vo.ExerciseGoalVo;
import com.spring.springProject1.common.vo.FoodInfoVo;
import com.spring.springProject1.common.vo.NutritionGoalVo;
import com.spring.springProject1.rec.vo.ExerciseRecordVo;
import com.spring.springProject1.rec.vo.MealRecordVo;
import com.spring.springProject1.rec.wrapper.ExerciseGoalListWrapper;
import com.spring.springProject1.rec.wrapper.ExerciseRecordListWrapper;
import com.spring.springProject1.rec.wrapper.MealRecordListWrapper;
import com.spring.springProject1.user.UserVo;

@Controller
@RequestMapping("/rec")
public class RecController {

	@Autowired
	private RecService recService;

//	운동 기록 부분----------------------------------------------------------------

	// 운동 기록 입력 페이지 호출
	@GetMapping("/exerciseRecordInput")
	public String exerciseRecordInputGet(HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		return "rec/exerciseRecordInput";
	}

	// 운동 기록 입력 처리
	@PostMapping("/exerciseRecordInput")
	public String exerciseRecordInputPost(ExerciseRecordVo vo, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			vo.setUser_id(user.getUser_id()); // 세션의 loginUser(vo)에서 유저아이디키 가져오기
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
	public String exerciseRecordListGet(HttpSession session, Model model, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			List<ExerciseRecordVo> exerciseRecordList = recService.getExerciseRecordList(user.getUser_id());
			model.addAttribute("exerciseRecordList", exerciseRecordList);
			return "rec/exerciseRecordList";
		} catch (Exception e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/user/main");
			return "redirect:/message/error";
		}
	}

	// 운동 기록 단일 수정 처리
	@PostMapping("/exerciseRecordUpdate")
	public String exerciseRecordUpdatePost(ExerciseRecordVo vo, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			// 세션에서 user_id 강제 주입 (보안용)
			vo.setUser_id(user.getUser_id());
			recService.updateExerciseRecord(vo);
			return "redirect:/message/exerciseRecordUpdateOk";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/exerciseRecordList");
			return "redirect:/message/error";
		}
	}

	// 운동 기록 수정 페이지 호출
	@GetMapping("/exerciseRecordEdit")
	public String exerciseRecordEdit(@RequestParam("record_id") int record_id, HttpSession session, Model model) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			model.addAttribute("message", "로그인이 필요합니다.");
			model.addAttribute("url", "/");
			return "redirect:/message/error";
		}

		ExerciseRecordVo vo = recService.getExerciseRecordById(record_id, user.getUser_id());
		if (vo == null) {
			model.addAttribute("message", "해당 기록을 찾을 수 없어요!");
			model.addAttribute("url", "/rec/exerciseRecordList");
			return "redirect:/message/error";
		}

		model.addAttribute("record", vo);
		return "rec/exerciseRecordEdit"; // 수정 전용 폼 페이지
	}

	// 운동 기록 수정 페이지에서 수정 처리
	@PostMapping("/exerciseRecordEdit")
	public String exerciseRecordEditPost(ExerciseRecordVo vo, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			// 세션에서 user_id 강제 주입 (보안용)
			vo.setUser_id(user.getUser_id());
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
	public String exerciseRecordDelete(@RequestParam("record_id") int record_id, HttpSession session,
			RedirectAttributes ra) {
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
	public String exerciseRecordMultiDeletePost(HttpServletRequest request, HttpSession session,
			RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");

		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}

		try {
			recService.multiDeleteExerciseRecord(request, user.getUser_id()); // 요청 객체 통째로 위임
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
	public String mealRecordInputGet(HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		return "rec/mealRecordInput";
	}

	// 식닥 기록 단일 입력 처리
	@PostMapping("/mealRecordInput")
	public String mealRecordInputPost(MealRecordVo vo, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			vo.setUser_id(user.getUser_id());
			recService.setMealRecord(vo);
			return "redirect:/message/mealRecordInputOk";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/mealRecordInput");
			return "redirect:/message/error";
		}
	}

	// 식단 기록 목록 조회
	@GetMapping("/mealRecordList")
	public String mealRecordListGet(Model model, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			int userId = user.getUser_id();
			List<MealRecordVo> mealRecordList = recService.getMealRecordList(userId);
			model.addAttribute("mealRecordList", mealRecordList);
			return "rec/mealRecordList";
		} catch (Exception e) {
			e.printStackTrace();
			ra.addFlashAttribute("message", "식단 기록을 불러오는 데 실패했어요! ");
			ra.addFlashAttribute("url", "/user/main");
			return "redirect:/message/error";
		}
	}

	// 식단 다중 입력 페이지 호출
	@GetMapping("/mealRecordMultiInput")
	public String mealRecordMultiInputGet(HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		return "rec/mealRecordMultiInput";
	}

	// 다중 식단 입력 처리
	@PostMapping("/mealRecordMultiInput")
	public String mealRecordMultiInputPost(@ModelAttribute MealRecordListWrapper mealRecordListWrapper,
			HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/user/login");
			return "redirect:/message/error";
		}

		try {
			List<MealRecordVo> list = mealRecordListWrapper.getMealRecordList();
			for (MealRecordVo vo : list) {
				vo.setUser_id(user.getUser_id());
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
		if (user == null) {
			model.addAttribute("message", "로그인이 필요합니다.");
			model.addAttribute("url", "/");
			return "redirect:/message/error";
		}

		MealRecordVo vo = recService.getMealRecordById(meal_id, user.getUser_id());
		if (vo == null) {
			model.addAttribute("message", "해당 식단 기록을 찾을 수 없어요!");
			model.addAttribute("url", "/rec/mealRecordList");
			return "redirect:/message/error";
		}

		model.addAttribute("record", vo);
		return "rec/mealRecordEdit"; // 수정 전용 폼 페이지
	}

	// 식단 기록 수정 처리
	@PostMapping("/mealRecordEdit")
	public String mealRecordEditPost(MealRecordVo vo, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			vo.setUser_id(user.getUser_id()); // 세션에서 user_id 강제 주입 (보안 강화)
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
		if (user == null) {
			model.addAttribute("message", "로그인이 필요합니다.");
			model.addAttribute("url", "/");
			return "redirect:/message/error";
		}

		try {
			recService.deleteMealRecord(mealId, user.getUser_id());
			return "redirect:/message/mealRecordDeleteOk";
		} catch (IllegalArgumentException e) {
			model.addAttribute("message", e.getMessage());
			model.addAttribute("url", "/rec/mealRecordList");
			return "redirect:/message/error";
		}
	}

	// 식단 기록 단일 수정 처리
	@PostMapping("/mealRecordUpdate")
	public String mealRecordUpdatePost(MealRecordVo vo, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			vo.setUser_id(user.getUser_id());
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
			return "redirect:/message/error";
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

// 운동 목표 부분----------------------------------------------------------------

	// 운동 목표 설정 페이지 호출
	@GetMapping("/goalInputExercise")
	public String goalInputExerciseGet(HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		return "rec/goalInputExercise";
	}

	// 운동 목표 설정 처리
	@PostMapping("/goalInputExerciseOk")
	public String goalInputExerciseOk(@ModelAttribute ExerciseGoalVo vo, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			// 로그인 유저 검증 및 ID 강제 주입
			vo.setUser_id(user.getUser_id());
			vo.setSet_by(1); // 직접 설정

			recService.setExerciseGoal(vo);
			return "redirect:/message/goalInputExerciseOk";

		} catch (Exception e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/goalInputExercise");
			return "redirect:/message/error";
		}
	}

	// 운동 목표 목록 조회
	@GetMapping("/goalListExercise")
	public String goalListExerciseGet(Model model, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			List<ExerciseGoalVo> list = recService.getExerciseGoalList(user.getUser_id());
			model.addAttribute("exerciseGoalList", list);

			return "rec/goalListExercise";
		} catch (Exception e) {
			ra.addFlashAttribute("message", "운동 목표 목록을 불러오는 데 실패했어요! " + e.getMessage());
			ra.addFlashAttribute("url", "/user/main");
			return "redirect:/message/error";
		}
	}

	// 운동 목표 수정 페이지 호출
	@GetMapping("/goalEditExercise")
	public String goalEditExerciseGet(@RequestParam("goal_id") int goal_id, HttpSession session, Model model,
			RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}

		try {
			ExerciseGoalVo vo = recService.getExerciseGoalById(goal_id, user.getUser_id());
			if (vo == null) {
				model.addAttribute("message", "해당 운동 목표를 찾을 수 없어요!");
				model.addAttribute("url", "/rec/goalListExercise");
				return "redirect:/message/error";
			}
			model.addAttribute("record", vo);
			return "rec/goalEditExercise";
		} catch (Exception e) {
			e.printStackTrace();
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/goalListExercise");
			return "redirect:/message/error";
		}
	}

	// 운동 목표 수정 페이지에서 수정 처리
	@PostMapping("/goalEditExercise")
	public String goalEditExercisePost(@ModelAttribute ExerciseGoalVo vo, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}

		try {
			vo.setUser_id(user.getUser_id()); // 사용자 ID 강제 주입
			recService.updateExerciseGoal(vo);
			return "redirect:/message/goalEditExerciseOk";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/goalEditExercise?goal_id=" + vo.getGoal_id());
			return "redirect:/message/error";
		}
	}

	// 운동 목표 목록 페이지 관리 - 삭제 처리
	@GetMapping("/goalDeleteExercise")
	public String goalDeleteExercise(@RequestParam("goal_id") int goal_id, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}

		try {
			recService.deleteExerciseGoal(goal_id, user.getUser_id());
			return "redirect:/message/goalDeleteExerciseOk";
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/goalListExercise");
			return "redirect:/message/error";
		}
	}

	// 운동 목표 목록 페이지 - 수정모드 - 단건 수정("개별저장" 버튼)
	@PostMapping("/goalUpdateExercise")
	public String goalUpdateExercisePost(@ModelAttribute ExerciseGoalVo vo, HttpSession session,
			RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			vo.setUser_id(user.getUser_id());
			recService.updateExerciseGoal(vo); // 기존 메서드 재사용
			return "redirect:/message/goalEditExerciseOk"; // 목록 리디렉션 포함
		} catch (IllegalArgumentException e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/goalListExercise");
			return "redirect:/message/error";
		}
	}

	// 운동 목표 목록 페이지 - 수정모드 - 다중 수정
	@PostMapping("/goalMultiUpdateExercise")
	public String goalMultiUpdateExercisePost(@ModelAttribute ExerciseGoalListWrapper wrapper, HttpSession session,
			RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			for (ExerciseGoalVo vo : wrapper.getGoalList()) {
				vo.setUser_id(user.getUser_id());
				System.out.println(vo);
			}
			recService.multiUpdateExerciseGoal(wrapper.getGoalList());
			return "redirect:/message/goalMultiUpdateExerciseOk";
		} catch (Exception e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/goalListExercise");
			return "redirect:/message/error";
		}
	}
	
	// 운동 목표 목록 페이지 - 수정모드 - 다중 삭제
	@PostMapping("/goalMultiDeleteExercise")
	public String goalMultiDeleteExercisePost(HttpServletRequest request, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}

		try {
			recService.multiDeleteExerciseGoal(request, user.getUser_id());
			return "redirect:/message/goalMultiDeleteExerciseOk";
		} catch (Exception e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/goalListExercise");
			return "redirect:/message/error";
		}
	}
	
// 식단 목표-------------------------------------------------------------------------------
	
	// 식단 목표 설정 페이지 호출
	@GetMapping("/goalInputNutrition")
	public String goalInputNutritionGet(HttpSession session, RedirectAttributes ra, Model model) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}

		// 식품 목록 전달 (선택)
		List<FoodInfoVo> foodList = recService.getAllFoodList(); // 식단 목표 select용
		model.addAttribute("nutrientList", NutrientEnum.values());
		model.addAttribute("foodList", foodList);

		return "rec/goalInputNutrition";
	}

	// 식단 목표 설정 처리
	@PostMapping("/goalInputNutritionOk")
	public String goalInputNutritionOk(@ModelAttribute NutritionGoalVo vo, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			vo.setUser_id(user.getUser_id());
			vo.setSet_by(1); // 사용자 직접 설정
			recService.setNutritionGoal(vo);
			return "redirect:/message/goalInputNutritionOk";

		} catch (Exception e) {
			ra.addFlashAttribute("message", e.getMessage());
			ra.addFlashAttribute("url", "/rec/goalInputNutrition");
			return "redirect:/message/error";
		}
	}

	// 식단 목표 목록 조회
	@GetMapping("/goalListNutrition")
	public String goalListNutritionGet(Model model, HttpSession session, RedirectAttributes ra) {
		UserVo user = (UserVo) session.getAttribute("loginUser");
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
		try {
			List<NutritionGoalVo> list = recService.getNutritionGoalList(user.getUser_id());
			model.addAttribute("nutritionGoalList", list);
			return "rec/goalListNutrition";
		} catch (Exception e) {
			ra.addFlashAttribute("message", "식단 목표 목록을 불러오는 데 실패했어요! " + e.getMessage());
			ra.addFlashAttribute("url", "/user/main");
			return "redirect:/message/error";
		}
	}
	





}
