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
			@RequestParam(name = "username", defaultValue = "", required = false) String username,
			@RequestParam(name = "category", defaultValue = "", required = false) String category,
			@RequestParam(name = "board_id", defaultValue = "", required = false) String board_id) {
			
		
		if(msgFlag.equals("exerciseRecordInputOk")) {
			model.addAttribute("message", "운동 기록 마법 성공!");
			model.addAttribute("url", "user/main");
		}
		else if(msgFlag.equals("exerciseRecordUpdateOk")) {
			model.addAttribute("message", "개별 운동 기록 수정 마법 성공!");
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
			model.addAttribute("message", "개별 식단 기록 수정 마법 성공!");
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
		else if(msgFlag.equals("goalEditExerciseOk")) {
			model.addAttribute("message", "개별 운동 목표 수정 마법 성공!");
			model.addAttribute("url", "rec/goalListExercise");
		}
		else if(msgFlag.equals("goalMultiUpdateExerciseOk")) {
			model.addAttribute("message", "다중 운동 목표 수정 마법 성공!");
			model.addAttribute("url", "rec/goalListExercise");
		}
		else if(msgFlag.equals("goalMultiDeleteExerciseOk")) {
			model.addAttribute("message", "다중 운동 목표 삭제 마법 성공!");
			model.addAttribute("url", "rec/goalListExercise");
		}
		else if(msgFlag.equals("goalInputNutritionOk")) {
			model.addAttribute("message", "식단 목표 설정 마법 성공!");
			model.addAttribute("url", "rec/goalListNutrition");
		}
		else if(msgFlag.equals("goalEditNutritionOk")) {
			model.addAttribute("message", "식단 목표 수정 마법 성공!");
			model.addAttribute("url", "rec/goalListNutrition");
		}
		else if(msgFlag.equals("goalDeleteNutritionOk")) {
			model.addAttribute("message", "식단 목표 삭제 마법 성공!");
			model.addAttribute("url", "rec/goalListNutrition");
		}
		else if(msgFlag.equals("goalUpdateNutritionOk")) {
			model.addAttribute("message", "개별 식단 목표 수정 마법 성공!");
			model.addAttribute("url", "rec/goalListNutrition");
		}
		else if(msgFlag.equals("goalMultiUpdateNutritionOk")) {
			model.addAttribute("message", "다중 식단 목표 수정 마법 성공!");
			model.addAttribute("url", "rec/goalListNutrition");
		}
		else if(msgFlag.equals("goalMultiDeleteNutritionOk")) {
			model.addAttribute("message", "다중 식단 목표 삭제 마법 성공!");
			model.addAttribute("url", "rec/goalListNutrition");
		}
		else if(msgFlag.equals("error")) {
			model.addAttribute("message", model.asMap().get("message")); // RedirectAttributes에서 받음
			model.addAttribute("url", model.asMap().get("url"));
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
		else if(msgFlag.equals("passwordEncryptNoJoin")) {
			model.addAttribute("message", "비밀번호 암호화 중 오류가 발생했습니다.");
			model.addAttribute("url", "user/userJoin");
		}
		else if(msgFlag.equals("passwordEncryptNoLogin")) {
			model.addAttribute("message", "비밀번호 암호화 중 오류가 발생했습니다.");
			model.addAttribute("url", "user/userLogin");
		}
		else if(msgFlag.equals("passwordEncryptNoMain")) {
			model.addAttribute("message", "비밀번호 암호화 중 오류가 발생했습니다.");
			model.addAttribute("url", "user/main");
		}
		else if(msgFlag.equals("userLoginOk")) {
		  model.addAttribute("message", username + " 님, 환영합니다! 로그인에 성공했습니다.");
		  model.addAttribute("url", "user/main");
		}
		else if(msgFlag.equals("increaseLoginFail")) {
		  model.addAttribute("message", "이메일 또는 비밀번호가 일치하지 않습니다.");
		  model.addAttribute("url", "user/userLogin");
		}
		else if(msgFlag.equals("LoginLocked")) {
		  model.addAttribute("message", "로그인 실패가 5회 이상입니다. 계정이 잠겼습니다.\\n비밀번호찾기를 통해 재설정하세요.");
		  model.addAttribute("url", "user/userLogin");
		}
		else if(msgFlag.equals("userLogoutOk")) {
			model.addAttribute("message", "로그아웃되었습니다.");
			model.addAttribute("url", "user/main");
		}
		else if(msgFlag.equals("reCaptchaNo")) {
		  model.addAttribute("message", "자동 인증(CAPTCHA)을 통과하지 못했습니다.");
		  model.addAttribute("url", "user/userLogin");
		}
		else if(msgFlag.equals("userEmailCheckNo")) {
		  model.addAttribute("message", "이메일을 찾지 못했습니다.");
		  model.addAttribute("url", "user/findPassword");
		}
		else if(msgFlag.equals("findPasswordOk")) {
			model.addAttribute("message", "임시비밀번호를 이메일로 전송했습니다.\\n확인 후 다시 로그인 해주세요.");
			model.addAttribute("url", "user/userLogin");
		}
		else if(msgFlag.equals("isTempPassword")) {
			model.addAttribute("message", "임시비밀번호로 로그인되어있습니다. 비밀번호를 변경해주세요.");
			model.addAttribute("url", "user/passwordReset");
		}
		else if(msgFlag.equals("passwordChangeOk")) {
			model.addAttribute("message", "비밀번호가 변경되었습니다. 다시 로그인 해주세요");
			model.addAttribute("url", "user/userLogin");
		}
		else if(msgFlag.equals("passwordChangeNo")) {
			model.addAttribute("message", "비밀번호 변경 실패.");
			model.addAttribute("url", "user/main");
		}
		else if(msgFlag.equals("passwordCheckNo")) {
			model.addAttribute("message", "비밀번호가 일치하지 않습니다.");
			model.addAttribute("url", "user/main");
		}
		else if(msgFlag.equals("userInvalidOk")) {
			model.addAttribute("message", "계정이 비활성화 되었습니다.\\n30일 동안 접속 없을 시 탈퇴처리됩니다");
			model.addAttribute("url", "user/main");
		}
		else if(msgFlag.equals("boardInputOk")) {
			model.addAttribute("message", "게시글 등록 완료");
			model.addAttribute("url", "board/boardList/" + category);
		}
		else if(msgFlag.equals("boardInputNo")) {
			model.addAttribute("message", "게시글 등록 실패");
			model.addAttribute("url", "board/boardList/all");
		}
		else if(msgFlag.equals("boardContentNo")) {
			model.addAttribute("message", "게시글 불러오기 실패");
			model.addAttribute("url", "board/boardList/all");
		}
		else if(msgFlag.equals("updateBoardLikeNo")) {
			model.addAttribute("message", "좋아요 업데이트 실패");
			model.addAttribute("url", "board/boardContent/" + board_id);
		}
		else if(msgFlag.equals("decreaseLikeCountOk")) {
			model.addAttribute("message", "추천 취소");
			model.addAttribute("url", "board/boardContent/" + board_id);
		}
		else if(msgFlag.equals("increaseLikeCountOk")) {
			model.addAttribute("message", "추천 완료");
			model.addAttribute("url", "board/boardContent/" + board_id);
		}
		else if(msgFlag.equals("deleteError")) {
			model.addAttribute("message", "삭제 실패");
			model.addAttribute("url", "board/boardContent/" + board_id);
		}
		else if(msgFlag.equals("boardDeleteOk")) {
			model.addAttribute("message", "게시글 삭제 완료");
			model.addAttribute("url", "board/boardList/all");
		}
		else if(msgFlag.equals("boardDeleteNo")) {
			model.addAttribute("message", "게시글 삭제 실패");
			model.addAttribute("url", "board/boardContent/" + board_id);
		}
		else if(msgFlag.equals("boardDeleteOk")) {
			model.addAttribute("message", "게시글 삭제 완료");
			model.addAttribute("url", "board/boardList/all");
		}
		else if(msgFlag.equals("boardDeleteNo")) {
			model.addAttribute("message", "게시글 삭제 실패");
			model.addAttribute("url", "board/boardContent/" + category + "/" + board_id);
		}
		else if(msgFlag.equals("boardCommentDeleteOk")) {
			model.addAttribute("message", "댓글 삭제 완료");
			model.addAttribute("url", "board/boardContent/" + category + "/" + board_id);
		}
		else if(msgFlag.equals("boardCommentDeleteNo")) {
			model.addAttribute("message", "댓글 삭제 실패");
			model.addAttribute("url", "board/boardContent/" + category + "/" + board_id);
		}
		else if(msgFlag.equals("boardCommentDeleteOk")) {
			model.addAttribute("message", "댓글 삭제 완료");
			model.addAttribute("url", "board/boardContent/" + category + "/" + board_id);
		}
		else if(msgFlag.equals("boardCommentDeleteNo")) {
			model.addAttribute("message", "댓글 삭제 실패");
			model.addAttribute("url", "board/boardContent/" + category + "/" + board_id);
		}
		else if(msgFlag.equals("boardReplyDeleteOk")) {
			model.addAttribute("message", "답글 삭제 완료");
			model.addAttribute("url", "board/boardContent/" + category + "/" + board_id);
		}
		else if(msgFlag.equals("boardReplyDeleteNo")) {
			model.addAttribute("message", "답글 삭제 실패");
			model.addAttribute("url", "board/boardContent/" + category + "/" + board_id);
		}
		
		return "include/message";
	}
}
