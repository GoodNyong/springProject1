/*
 * package com.spring.springProject1.common;
 * 
 * import java.text.SimpleDateFormat; import java.util.Date;
 * 
 * import javax.mail.MessagingException; import javax.mail.internet.MimeMessage;
 * 
 * import org.springframework.beans.factory.annotation.Autowired; import
 * org.springframework.core.io.FileSystemResource; import
 * org.springframework.mail.javamail.JavaMailSender; import
 * org.springframework.mail.javamail.MimeMessageHelper; import
 * org.springframework.scheduling.annotation.Scheduled; import
 * org.springframework.stereotype.Component;
 * 
 * @Component public class SpringScheduler {
 * 
 * @Autowired private JavaMailSender mailSender;
 * 
 * // @Scheduled(cron = "0/10 * * * * *") // crom = 초 분 시 일 월 요일 - 기본값 '*' //
 * public void scheduleRun1() { // Date today = new Date(); // SimpleDateFormat
 * sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // String strToday =
 * sdf.format(today); // System.out.println("10초에 한번식 메세지 출력.. : " + strToday);
 * // } // // @Scheduled(cron = "0 0/1 * * * *") // crom = 초 분 시 일 월 요일 - 기본값
 * '*' // public void scheduleRun2() { // Date today = new Date(); //
 * SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // String
 * strToday = sdf.format(today); // System.out.println("1분에 한번식 메세지 출력.. : " +
 * strToday); // } // // @Scheduled(cron = "0 8 17 * * *") // crom = 초 분 시 일 월
 * 요일 - 기본값 '*' // public void scheduleRun3() { // Date today = new Date(); //
 * SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // String
 * strToday = sdf.format(today); // System.out.println("17시 8분에 메세지 출력.. : " +
 * strToday); // }
 * 
 * @Scheduled(cron = "0 29 17 * * *") // crom = 초 분 시 일 월 요일 - 기본값 '*' public
 * void scheduleRun4() throws MessagingException { Date today = new Date();
 * SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); String
 * strToday = sdf.format(today); System.out.println("17시 29분에 광고 메일 전송.. : " +
 * strToday);
 * 
 * String email = "gy990213@naver.com"; String title = "신제품 안내 메일(광고)"; String
 * content = "봄맞이 신상품 안내 메일입니다.";
 * 
 * // MimeMessage(), MideMessageHelper() MimeMessage message =
 * mailSender.createMimeMessage(); MimeMessageHelper messageHelper = new
 * MimeMessageHelper(message, true, "UTF-8");
 * 
 * // 메일보관함에 메세지 내용 저장...후... 처리 messageHelper.setTo(email);
 * messageHelper.setSubject(title); messageHelper.setText(content);
 * 
 * // 메세지에 추가로 필요한 사항을 messageHelper에 추가로 넣어준다. content = content.replace("\n",
 * "<br>"); content += "<br><hr><h3>새봄맞이 신상품 페스티벌</h3><br>"; // content +=
 * "<p><img src=\"cid:main.jpg\" width='550px'></p>"; content +=
 * "<p>방문하기 : <a href='http://49.142.157.251:9090/cjgreen'>Green Project</a></p>"
 * ; content += "<hr>"; messageHelper.setText(content, true);
 * 
 * // HttpServletRequest request =
 * ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).
 * getRequest();
 * 
 * // FileSystemResource file = new FileSystemResource(
 * "C:\\Users\\gy990\\OneDrive\\GYP\\Spring\\springProject\\springframework\\works\\JspringProject\\src\\main\\webapp\\resources\\images"
 * ); // messageHelper.addInline("main.jpg", file);
 * 
 * 
 * // 메일 전송하기 mailSender.send(message); }
 * 
 * }
 */
