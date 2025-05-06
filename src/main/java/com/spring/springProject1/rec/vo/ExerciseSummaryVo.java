package com.spring.springProject1.rec.vo;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/** 날짜별 운동 요약 */
@Getter @Setter @ToString
public class ExerciseSummaryVo {
	private Date activity_date;      // 운동 일자
    private int  total_minutes;      // 총 운동 시간(분)
    private int  total_calories;     // 총 소모 칼로리(kcal)
}
