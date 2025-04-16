package com.spring.springProject1.user;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Controller
@RequestMapping("/user")
public class UserController {
	
	@Autowired
	UserService userService;
	
	@Autowired
	private JavaMailSender mailSender;
	
	@GetMapping("/test")
	public String testPageGet() {
		return "user/test";
	}
	
	// user 등록폼
	@RequestMapping(value = "/userInput", method = RequestMethod.GET)
	public String userInputGet() {
		return "user/userInput";
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
		
		session.setAttribute("SEmailCode", emailCode);
		
		String title = "[Blinkos] 이메일 인증번호입니다.";
		String emailCodeFlag = "인증번호: <b>" + emailCode + "</b><br>3분 안에 입력해주세요.";
		
		mailSend(email, title, emailCodeFlag);
		
		return "1";
	}
	
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
	
	
	/*
	JavaMailSender mailSender 이 객체에는 이미 root-context.xml에 설정한 SMTP 정보(포트, 인증, 발신자 등)가 다 들어있음
	
	1. Spring이 시작되면 root-context.xml에 정의된 mailSender 객체 생성

	2. UserController가 생성될 때, @Autowired를 보고 Spring이 내가 만들어놓은 mailsender가 필요하다고 판단

	3. 이제 mailSender.send(...)로 바로 메일 전송 가능
	*/
}
