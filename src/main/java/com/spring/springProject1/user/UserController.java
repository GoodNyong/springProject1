package com.spring.springProject1.user;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.InvalidKeyException;
import java.util.List;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.springProject1.common.ARIAUtil;
import com.spring.springProject1.common.SecurityUtil;

@Controller
@RequestMapping("/user")
public class UserController {
	
	@Autowired
	UserService userService;
	
	@Autowired
	private JavaMailSender mailSender;
	
	@GetMapping("/main")
	public String testPageGet() {
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
	  String shaPwd = security.encryptSHA256(vo.getPassword());
	  try {
	    String encPwd = ARIAUtil.ariaEncrypt(shaPwd);
	    vo.setPassword(encPwd); // DB에는 암호화된 비밀번호 저장
	  } catch (Exception e) {
	    e.printStackTrace();
	    return "redirect:/message/passwordEncryptNo";
	  }
	  
	  // 4. 최종 회원정보 저장
	  int res = userService.setUserJoinOk(vo);
	  
	  // 5. 역할 부여
	  //userService.getRoleToUser(vo.getUser_id(), 4);
	  
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
	public String userLoginPost(String email, String password, String gRecaptchaResponse,
      HttpSession session, HttpServletRequest request, HttpServletResponse response,
      String idSave, Model model) {
		
	  // ✅ 여기가 캡차 값 들어오는지 확인하는 위치!
	  System.out.println("reCaptcha token: " + gRecaptchaResponse);
	  
	  //ReCaptcha검증
	  boolean captchaSuccess = verifyRecaptcha(gRecaptchaResponse);
	  if (!captchaSuccess) {
	    return "redirect:/message/reCaptchaNo";
	  }
	  
	  //비밀번호 암호화
	  SecurityUtil security = new SecurityUtil();
	  String shaPassword = security.encryptSHA256(password);
	  String encPassword;
		try {
			encPassword = ARIAUtil.ariaEncrypt(shaPassword);
		} catch (InvalidKeyException | UnsupportedEncodingException e) {
			e.printStackTrace();
			return "redirect:/message/passwordEncryptNo";
		}
	  
		//사용자 정보 조회 (로그인 실패 횟수 및 차단)
	  UserVo vo = userService.getUserLoginCheck(email, encPassword);
	  //수업에서 mid 값으로 vo를 가져와서 비밀번호를 비교하지만 보안 중심으로 로그인 전용 기능 구현
	  //(비밀번호까지 가져가서 비교 후 vo 가져옴)
	  if (vo == null) {
	  	userService.increaseLoginFail(email);
	  	return "redirect:/message/increaseLoginFail";
	  }
	  
	  if (vo.getLogin_fail_count() >= 5) {
	  	return "redirect:/message/LoginLocked";
	  }
	  
	  userService.resetLoginFail(email);
	  
	  //로그인 성공 처리
	  session.setAttribute("sUser", vo);
	  session.setMaxInactiveInterval(1800);
		
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
		return "redirect:/message/userLoginOk?username="+vo.getUsername();
	}
	
	
	
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
		String emailCodeFlag = "인증번호: <b>" + emailCode + "</b><br>3분 안에 입력해주세요.";
		
		mailSend(email, title, emailCodeFlag);
		
		return "1";
	}
	/*
	JavaMailSender mailSender 이 객체에는 이미 root-context.xml에 설정한 SMTP 정보(포트, 인증, 발신자 등)가 다 들어있음
	
	1. Spring이 시작되면 root-context.xml에 정의된 mailSender 객체 생성

	2. UserController가 생성될 때, @Autowired를 보고 Spring이 내가 만들어놓은 mailsender가 필요하다고 판단

	3. 이제 mailSender.send(...)로 바로 메일 전송 가능
	*/
	
	//메일 전송하기(인증번호, 아이디찾기, 비밀번호 찾기)
	public void mailSend(String toMail, String title, String emailCodeFlag) throws MessagingException {
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
		content += "<br><hr><h3>"+emailCodeFlag+"</h3><br>";
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
	
	

}
