package com.spring.springProject1.user;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UserVo {
	private int user_id;
	private String username;
	private String email;
	private String password;
	private String phone_number;
	private int is_verified;
	private int created_at;
	private int updated_at;
	private int is_premium;
}
