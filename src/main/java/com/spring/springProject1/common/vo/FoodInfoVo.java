package com.spring.springProject1.common.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class FoodInfoVo {
	private int food_id;
	private String name;
	private String category;
	private double calories;
	private double carbohydrates;
	private double protein;
	private double fat;
	private String source;
	private int is_active;
}