package com.spring.springProject1.rec.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class NutritionProgressVo {
	/*---------- NutritionGoal 기본 컬럼 ----------*/
    private int    goal_id;         // PK
    private int    goal_type;       // 1=영양소, 2=식품
    private Integer nutrient_id;    // goal_type=1 일 때만 값 존재
    private Integer food_id;        // goal_type=2 일 때만 값 존재
    private double target_value;    // 목표 수치
    private int    goal_unit;       // 단위 코드
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date   end_date;        // 목표 종료일

    /*---------- 집계 결과 컬럼 ----------*/
    private String goal_name;       // 영양소 이름 또는 식품명
    private Double actual_value;    // 기간 내 실제 섭취량/열량
    private Double progress_rate;   // 달성률(%)

    /*---------- 화면 보조 필드 ----------*/
    private String goal_unit_label; // g, kcal, 개 …
    private boolean expired;        // 종료일 지난 목표 표시
}