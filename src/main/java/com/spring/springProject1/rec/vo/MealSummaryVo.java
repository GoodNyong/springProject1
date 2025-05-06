package com.spring.springProject1.rec.vo;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class MealSummaryVo {
    private Date meal_date;      // yyyy‑MM‑dd
    private int  total_kcal;     // 하루 총 열량
}
