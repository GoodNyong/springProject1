package com.spring.springProject1.common;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class NutritionGoalVo {
	private int goal_id;           // PK
	private int user_id;
	private int goal_type;         // 1=영양소, 2=식품

	private Integer nutrient_id;   // NutrientInfo 참조
	private Integer food_id;       // FoodInfo 참조
	private int set_by = 1;        // 1=사용자, 2=전문가
	private Integer expert_id;

	private String quantity;       // "200g", "1컵" 등 단위 포함

	private double target_value;   // 목표 수치 (단위별 해석 필요)
	private Integer goal_unit;     // 1=g, 2=kcal, 3=회 등

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date start_date;

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date end_date;
}
