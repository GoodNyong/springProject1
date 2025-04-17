package com.spring.springProject1.user;

import java.util.Date;

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
	private boolean is_verified;
	private Date created_at;
	private Date updated_at;
	private boolean is_premium;
}
