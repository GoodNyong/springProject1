package com.spring.springProject1.common;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExerciseGoalVo {
	private int goal_id;           // PK
	private int user_id;           // 사용자 ID
	private int exercise_id;       // 운동 ID (ExerciseInfo 참조)
	private int set_by = 1;        // 1=사용자, 2=전문가
	private Integer expert_id;     // 전문가 ID (nullable)

	private double target_value;   // 목표 수치
	private int target_type;       // 1=시간, 2=칼로리
	private int goal_unit;         // 01=분, 11=kcal

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date start_date;

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date end_date;
}
