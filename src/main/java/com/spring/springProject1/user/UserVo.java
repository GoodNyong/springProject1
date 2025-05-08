package com.spring.springProject1.user;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString(exclude = "password") //비밀번호는 로그 등에서 출력 제외
public class UserVo {
	private int user_id;
	private String username;
	private String email;
	private String password;
	private String phone_number;
	private int is_verified;
	private LocalDateTime created_at;
	private LocalDateTime updated_at;
	private int is_premium;
	private int login_fail;
}
