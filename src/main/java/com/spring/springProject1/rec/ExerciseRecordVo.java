package com.spring.springProject1.rec;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExerciseRecordVo {
	private int record_id;
    private int user_id;
    private int exercise_id;
    private int duration_minutes;
    private int calories_burned;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date activity_date;
    private String source_platform;
    private String exercise_name; // ← 추가 필드
}
