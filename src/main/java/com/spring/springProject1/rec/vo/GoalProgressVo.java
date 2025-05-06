package com.spring.springProject1.rec.vo;

import java.math.BigDecimal;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/** 목표별 달성률 */
@Getter @Setter @ToString
public class GoalProgressVo {
    private int        goal_id;         // 목표 PK
    private String     exercise_name;   // 운동명
    private BigDecimal goal_value;      // 목표 수치
    private Integer    actual_value;    // 실제 기록(분) – null 허용
    private BigDecimal progress_rate;   // 달성률(%)
    private Date       end_date;        // 목표 종료일
    private boolean    expired;        // 종료 목표 여부(뷰용)
    private int        goal_unit;          // 코드 값
    private String     goal_unit_label;    // 한글 라벨
}
