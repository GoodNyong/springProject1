package com.spring.springProject1.user;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.InvalidKeyException;
import java.util.List;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.springProject1.common.ARIAUtil;
import com.spring.springProject1.common.SecurityUtil;
import com.spring.springProject1.rec.RecService;

@Controller
@RequestMapping("/user")
public class UserController {
	
	@Autowired
	UserService userService;
	
	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	private RecService recService;
	
	@GetMapping("/main")
	public String mainPageGet(HttpSession session, Model model, RedirectAttributes ra) {
		Integer userId = (Integer) session.getAttribute("loginUser"); UserVo user = userService.getUserByUser_id(userId);
		if (user == null) {
			ra.addFlashAttribute("message", "로그인이 필요합니다.");
			ra.addFlashAttribute("url", "/");
			return "redirect:/message/error";
		}
	    System.out.println("userId : " + userId);
	    double exerciseRate = recService.getExerciseGoalAchievementRate(userId);
	    System.out.println("exerciseRate : " + exerciseRate);
	    double mealRate = recService.getMealGoalAchievementRate(userId);
	    System.out.println("mealRate : " + mealRate);
	    
	    model.addAttribute("exerciseRate", (int) exerciseRate);
	    model.addAttribute("mealRate", (int) mealRate);
	    
		return "user/main";
	}
	
	// user 등록폼
		@RequestMapping(value = "/userJoin", method = RequestMethod.GET)
		public String userJoinGet() {
			return "user/userJoin";
		}
	
	// user 회원가입 처리
	@RequestMapping(value = "/userJoin", method = RequestMethod.POST)
	public String userJoinPost(UserVo vo, HttpSession session) {
		
		System.out.println("vo : " + vo);
		
	  // 1. 이메일 인증 여부 확인
	  String sessionCode = (String) session.getAttribute("sEmailCode");
	  if (sessionCode == null || sessionCode.equals("")) {
	    return "redirect:/message/emailCheckNo";
	  }
	  session.removeAttribute("sEmailCode");
	  session.removeAttribute("sEmail");
	  
	  // 2. 닉네임 중복 확인 다시 서버에서 체크
	  if (userService.getUsernameCheck(vo.getUsername()) != null) {
	    return "redirect:/message/usernameCheckNo";
	  }
	  
	  
	  // 3. 비밀번호 암호화 (SHA-256 + ARIA)
	  SecurityUtil security = new SecurityUtil();
	  String shaPassword = security.encryptSHA256(vo.getPassword());
	  String encPassword;
	  try {
	    encPassword = ARIAUtil.ariaEncrypt(shaPassword);
	    vo.setPassword(encPassword); // DB에는 암호화된 비밀번호 저장
	  } catch (Exception e) {
	    e.printStackTrace();
	    return "redirect:/message/passwordEncryptNoJoin";
	  }
	  
	  // 4. 최종 회원정보 저장
	  int res = userService.setUserJoinOk(vo);
	  vo = userService.getUserEmailCheck(vo.getEmail());
	  
	  // 5. 역할 부여
	  userService.setUserRole(vo.getUser_id(), 4);
	  
	  session.removeAttribute("sEmailCode");
	  
	  if(res != 0) return "redirect:/message/userJoinOk";
	  else return "redirect:/message/userJoinNo";
	}
	
	// 로그인 폼 보기
	@RequestMapping(value = "/userLogin", method = RequestMethod.GET)
	public String userLoginGet(HttpServletRequest request) {
		// 쿠키처리로 저장된 아이디를 가져와서 view에 보내주기
	  Cookie[] cookies = request.getCookies();

		if(cookies != null) {
			for(int i=0; i<cookies.length; i++) {
				if(cookies[i].getName().equals("cEmail")) {
					request.setAttribute("Email", cookies[i].getValue());
					break;
				}
			}
		}
		
		return "user/userLogin";
	}
	
	//로그인 처리
	@RequestMapping(value = "/userLogin", method = RequestMethod.POST)
	public String userLoginPost(String email, String password, String username,
      HttpSession session, HttpServletRequest request, HttpServletResponse response,
      String idSave, Model model, String gRecaptchaResponse) throws UnsupportedEncodingException {
		
		/*
		 * //여기가 캡차 값 들어오는지 확인하는 위치 System.out.println("reCaptcha token: " +
		 * gRecaptchaResponse);
		 */
	  
		/*
		 * //ReCaptcha검증 boolean captchaSuccess = verifyRecaptcha(gRecaptchaResponse);
		 * if (!captchaSuccess) { return "redirect:/message/reCaptchaNo"; }
		 */
	  
	  //비밀번호 암호화
	  SecurityUtil security = new SecurityUtil();
	  String shaPassword = security.encryptSHA256(password);
	  String encPassword;
		try {
			encPassword = ARIAUtil.ariaEncrypt(shaPassword);
		} catch (InvalidKeyException | UnsupportedEncodingException e) {
			e.printStackTrace();
			return "redirect:/message/passwordEncryptNoLogin";
		}
	  
		//사용자 정보 조회 (로그인 실패 횟수 및 차단)
	  UserVo vo = userService.getUserLoginCheck(email, encPassword);
	  //수업에서 mid 값으로 vo를 가져와서 비밀번호를 비교하지만 보안 중심으로 로그인 전용 기능 구현
	  //(비밀번호까지 가져가서 비교 후 vo 가져옴)
	  if (vo == null) {
	  	userService.increaseLoginFail(email);
	  	return "redirect:/message/increaseLoginFail";
	  }
	  
	  if (vo.getLogin_fail() >= 5) {
	  	return "redirect:/message/LoginLocked";
	  }
	  
	  userService.resetLoginFail(email); //로그인 되면 실패횟수 초기화
	  
	  //해당 user_id의 역할(들)을 리스트로 가져옴
	  List<String> roles = userService.getUserRoles(vo.getUser_id());
	  
	  
	  //로그인 성공 처리
	  session.setAttribute("sUser", vo);
	  session.setAttribute("loginUser", vo.getUser_id());
	  session.setAttribute("sEmail", vo.getEmail());
	  session.setAttribute("sUsername", vo.getUsername());
	  session.setAttribute("sRoles", roles);
	  session.setMaxInactiveInterval(1800);
	  
	  //임시비밀 번호로 로그인 하면 강제로 비밀번호 변경
	  if(session.getAttribute("isTempPassword") != null) {
	  	return "redirect:/message/isTempPassword";
	  }
		
	  //역할(role) 세션 저장
	  //List<String> roles = userService.getUserRoles(vo.getUser_id());
	  //session.setAttribute("sRoles", roles);
	  
		// 2. 쿠키
		if(idSave != null && idSave.equals("on")) {	// 쿠키 저장 처리
			Cookie cookieEmail = new Cookie("cEmail", email);
			cookieEmail.setPath("/");
			cookieEmail.setMaxAge(60*60*24*7);	// 단위:초... 쿠키 만료시간을 7일로 지정
			response.addCookie(cookieEmail);
		}
		else {	// 쿠키 삭제처리
		  Cookie[] cookies = request.getCookies();
			if(cookies != null) {
				for(int i=0; i<cookies.length; i++) {
					if(cookies[i].getName().equals("cEmail")) {
						cookies[i].setPath("/");
						cookies[i].setMaxAge(0);
						response.addCookie(cookies[i]);
						break;
					}
				}
			}	  
		}
		return "redirect:/message/userLoginOk?username=" + URLEncoder.encode(vo.getUsername(), "UTF-8");
		//한글값을 넘길 거라 encode 및 throws 필수
	}
	
	// 로그아웃 처리
	@RequestMapping(value = "/userLogout", method = RequestMethod.GET)
	public String userLogoutGet(HttpSession session) {
		session.invalidate();
		return "redirect:/message/userLogoutOk";
	}
	
	
	/*
	public boolean verifyRecaptcha(String token) {
	  String secretKey = "6LccsBwrAAAAACNU8SQDxsZFv5brs4rwKRHsG7To";
	  String apiUrl = "https://www.google.com/recaptcha/api/siteverify";

	  try {
	    URL url = new URL(apiUrl);
	    HttpURLConnection con = (HttpURLConnection) url.openConnection();
	    con.setRequestMethod("POST");
	    con.setDoOutput(true);

	    String postData = "secret=" + secretKey + "&response=" + token;
	    OutputStream os = con.getOutputStream();
	    os.write(postData.getBytes());
	    os.flush();
	    os.close();

	    BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
	    StringBuilder res = new StringBuilder();
	    String input;
	    while ((input = in.readLine()) != null) res.append(input);
	    in.close();

	    JSONObject json = new JSONObject(res.toString());
	    return json.getBoolean("success");
	  } catch (Exception e) {
	    e.printStackTrace();
	    return false;
	  }
	}
	*/

	// username 중복체크
	@ResponseBody
	@RequestMapping(value = "/usernameCheck", method = RequestMethod.GET)
	public String UsernameCheckGet(String username) {
		UserVo vo = userService.getUsernameCheck(username);
		if(vo != null) return "1";
		else return "0";
	}
	/*
	1. 사용자 → JS에서 AJAX 호출 (/user/userIdCheck?username=hojin)
	↓
	2. 컨트롤러 UserIdCheckGet("hojin") 실행
	↓
	3. Service → Impl → DAO의 getUserIdCheck("hojin")
	↓
	4. DAO 메서드 이름 = MyBatis XML의 <select id="getUserIdCheck">
	↓
	5. Mapper SQL 실행 → SELECT * FROM user WHERE username = 'hojin'
	↓
	6. 결과가 있으면 UserVo 객체로 반환
	↓
	7. 컨트롤러에서 "1" 또는 "0" 문자열 응답
	↓
	8. JS가 그 값을 받아서 메시지 출력
	*/
	
	//이메일 인증(회원가입시) 확인하기
	@ResponseBody
	@RequestMapping(value = "/userEmailCheck", method = RequestMethod.POST)
	public String userEmailCheck(String email, HttpSession session) throws MessagingException {
		int randomCode = (int)(Math.random()*900000) + 100000;
		String emailCode = String.valueOf(randomCode);
		
		session.setAttribute("sEmailCode", emailCode);
		session.setAttribute("sEmail", email);
		
		String title = "[Blinkos] 이메일 인증번호입니다.";
		String emailFlag = "인증번호: <b>" + emailCode + "</b><br>3분 안에 입력해주세요.";
		
		mailSend(email, title, emailFlag);
		
		return "1";
	}
	/*
	JavaMailSender mailSender 이 객체에는 이미 root-context.xml에 설정한 SMTP 정보(포트, 인증, 발신자 등)가 다 들어있음
	
	1. Spring이 시작되면 root-context.xml에 정의된 mailSender 객체 생성

	2. UserController가 생성될 때, @Autowired를 보고 Spring이 내가 만들어놓은 mailsender가 필요하다고 판단

	3. 이제 mailSender.send(...)로 바로 메일 전송 가능
	*/
	
	//메일 전송하기(인증번호, 아이디찾기, 비밀번호 찾기)
	public void mailSend(String toMail, String title, String emailFlag) throws MessagingException {
		//HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String content = "";		
		
		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
		
		// 메일보관함에 메세지 내용 저장...후... 처리
		messageHelper.setTo(toMail);
		messageHelper.setSubject(title);
		messageHelper.setText(content);
		
		// 메세지에 추가로 필요한 사항을 messageHelper에 추가로 넣어준다.
		content = content.replace("\n", "<br>");
		content += "<br><hr><h3>"+emailFlag+"</h3><br>";
		//content += "<p><img src=\"cid:main.jpg\" width='550px'></p>";
		//content += "<p>방문하기 : <a href='http://49.142.157.251:9090/cjgreen'>Green Project</a></p>";
		content += "<hr>";
		messageHelper.setText(content, true);
		
		// 본문에 기재된 그림파일의 경로
		//FileSystemResource file = new FileSystemResource("D:\\springProject\\springframework\\works\\JspringProject\\src\\main\\webapp\\resources\\images\\main.jpg");
		
		//FileSystemResource file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/main.jpg"));
		//messageHelper.addInline("main.jpg", file);
		
		// 메일 전송하기
		mailSender.send(message);
	}
	
	//메일 인증번호 확인
	@ResponseBody
	@RequestMapping(value = "/emailCodeConfirm", method = RequestMethod.POST)
	public String emailCodeConfirmPost(String code, HttpSession session) {
		String sessionCode = (String) session.getAttribute("sEmailCode");
		
		if(sessionCode != null && sessionCode.equals(code)) return "1";
		else return "0";
	}
	
	//비밀번호 찾기 입력폼
	@RequestMapping(value = "/findPassword", method = RequestMethod.GET)
	public String findPasswordGet() {
	  return "user/userFindPassword";
	}
	
	//비밀번호 찾기 처리
	@RequestMapping(value = "/findPassword", method = RequestMethod.POST)
	public String findPasswordPost(String email, HttpSession session) throws MessagingException {
		UserVo vo = userService.getUserEmailCheck(email);
		
		if(vo == null) return "redirect:/message/userEmailCheckNo";
		
		String tempPassword = UUID.randomUUID().toString().substring(0,8);
		
	  String title = "[Blinkos] 임시 비밀번호 안내";
	  String emailFlag = "임시 비밀번호: <b>" + tempPassword + "</b><br>로그인 후 반드시 비밀번호를 변경해주세요.";
	  mailSend(email, title, emailFlag);
		
		SecurityUtil security = new SecurityUtil();
		
		String shaPassword = security.encryptSHA256(tempPassword);
	  try {
	    String encPassword = ARIAUtil.ariaEncrypt(shaPassword);
	    vo.setPassword(encPassword);
	  } catch (Exception e) {
	    e.printStackTrace();
	    return "redirect:/message/passwordEncryptNoLogin";
	  }
	  
	  userService.updatePassword(vo);
	  
	  //임시 비밀번호인지 세션에 저장
	  session.setAttribute("isTempPassword", true);
		
	  return "redirect:/message/findPasswordOk";
	}
	
	//비밀번호 변경 폼
	@RequestMapping(value = "/passwordReset", method = RequestMethod.GET)
	public String PasswordResetGet() {
	  return "user/userPasswordReset";
	}
	
	// 비밀번호 변경처리
	@RequestMapping(value = "/passwordReset", method = RequestMethod.POST)
	public String passwordResetPost(HttpSession session, String newPassword) {
		
		String email = (String) (session.getAttribute("sEmail"));
		
		System.out.println("session:" + session.getAttribute("sEmail"));
		
		UserVo vo = userService.getUserEmailCheck(email);
		
		System.out.println("newPassword = " + newPassword);
		
		SecurityUtil security = new SecurityUtil();
		
		String shaPassword = security.encryptSHA256(newPassword);
		System.out.println("SHA 암호화 결과: " + shaPassword);
		if (shaPassword == null || shaPassword.isEmpty()) {
		  System.out.println("SHA 암호화 실패");
		  return "redirect:/message/passwordEncryptNoMain";
		}

		String encPassword = null;
		try {
		  encPassword = ARIAUtil.ariaEncrypt(shaPassword);
		  System.out.println("ARIA 암호화 결과: " + encPassword);
		  vo.setPassword(encPassword);
		} catch (Exception e) {
		  e.printStackTrace();
		  System.out.println("ARIA 암호화 중 예외 발생");
		  return "redirect:/message/passwordEncryptNoMain";
		}
	  
	  //바뀐 비밀번호 DB 저장
	  int res = userService.updatePassword(vo);
	  System.out.println("updatePassword 결과: " + res);
		if(res != 0) {
			//임시비밀번호로 로그인 하여 강제로 여기 온 경우 세션 제거
			if(session.getAttribute("isTempPassword") != null){
				session.removeAttribute("isTempPassword");
			}
			return "redirect:/message/passwordChangeOk";
		}
		else return "redirect:/message/passwordChangeNo";
	}
	
	//비밀번호 확인 폼
	@RequestMapping(value = "/passwordCheck/{passwordFlag}", method = RequestMethod.GET)
	public String passwordCheckGet(Model model, @PathVariable String passwordFlag) {
	    model.addAttribute("passwordFlag", passwordFlag);
	    return "include/passwordCheckForm"; //include 폴더 아래
	}
	
	//비밀번호 확인 후 보내기 처리
	@RequestMapping(value = "/passwordCheck/{passwordFlag}", method = RequestMethod.POST)
	public String passwordCheckPost(HttpSession session, String checkPassword, @PathVariable String passwordFlag) {
		Integer user_id = (Integer) session.getAttribute("loginUser");
		UserVo vo = userService.getUserByUser_id(user_id);
	
		// 암호화된 비밀번호와 비교
    SecurityUtil security = new SecurityUtil();
    String shaPassword = security.encryptSHA256(checkPassword);
    try {
        String encPassword = ARIAUtil.ariaEncrypt(shaPassword);
        if (!encPassword.equals(vo.getPassword())) {
            // 비밀번호 불일치 시 message 처리
            return "redirect:/message/passwordCheckNo";
        }
    } catch (Exception e) {
        e.printStackTrace();
        return "redirect:/message/passwordEncryptNoMain";
    }
    
    // 비밀번호 일치 → 플래그에 따라 이동 처리
    if (passwordFlag.equals("d")) {
    		userService.setUserInvalid(user_id); //회원 비활성화 처리
    		session.invalidate(); //세션 삭제
        return "redirect:/message/userInvalidOk";
    }
    else if (passwordFlag.equals("p")) {
        return "user/userPasswordReset"; //바로 jsp로
    }
    else if (passwordFlag.equals("u")) {
        return "redirect:/user/userUpdate"; //controller로 다시 요청 왜? 값 가져가야지
        //POST 요청이 필요하다면 redirect는 못 쓰고 forward나 form으로 넘겨야 함.
    }
    
    return "redirect:/user/main";
    //return "${ctp}/";
	    
	}
	
	//회원정보수정 폼 보기
	@RequestMapping(value = "/userUpdate", method = RequestMethod.GET)
	public String userUpdateGet(Model model, HttpSession session) {
		
		Integer user_id = (Integer) session.getAttribute("loginUser");
		UserVo vo = userService.getUserByUser_id(user_id);
		
		model.addAttribute("vo", vo);
		return "user/userUpdate";
	}
	
	//회원정보 수정 처리
	@RequestMapping(value = "/userUpdate", method = RequestMethod.POST)
	public String userUpdatePost(HttpSession session, String username, String phone_number) {
	   Integer user_id = (Integer) session.getAttribute("loginUser");
	
	   //기존 사용자 정보 가져오기
	   UserVo vo = userService.getUserByUser_id(user_id);
	
	   //vo에 담기
	   vo.setUsername(username);
	   vo.setPhone_number(phone_number);
	   System.out.println("vo : " + vo);
	   //DB 업데이트
	   int res = userService.updateUser(vo);
	
	   // 세션도 최신값으로 반영
	   session.setAttribute("sUsername", username);
	   session.setAttribute("sPhone_number", phone_number);
	
	   if (res != 0) return "redirect:/message/userUpdateOk";
	   else return "redirect:/message/userUpdateNo";
	}
	
	@RequestMapping(value = "/userPage", method = RequestMethod.GET)
	public String userPageGet(HttpSession session, Model model) {
	    Integer user_id = (Integer) session.getAttribute("loginUser");
	    UserVo vo = userService.getUserByUser_id(user_id);
	    model.addAttribute("vo", vo);
	    return "user/userPage";
	}

}
