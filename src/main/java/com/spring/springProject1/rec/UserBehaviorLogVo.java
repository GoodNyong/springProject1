package com.spring.springProject1.rec;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UserBehaviorLogVo {
	private int behavior_id;
	private int user_id;
	private int content_id;
	private int event_type;
	private String occurred_at;
}
