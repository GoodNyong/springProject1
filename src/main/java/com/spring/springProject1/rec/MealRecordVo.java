package com.spring.springProject1.rec;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MealRecordVo {
	private int meal_id;
	private int user_id;
	private int food_id;
	private int meal_time;
	private String quantity;

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date meal_date;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date recorded_at;
	
	private String changed;

	// (선택) 식품명 임시 조인 필드
	private String food_name;
	
	// quantity = amount + unit 용 파싱
	private String amount;
	private String unit;
	
	public void setQuantity(String quantity) {
		this.quantity = quantity;
		if (quantity != null) {
			this.amount = quantity.replaceAll("[^0-9.]", "");
			this.unit = quantity.replaceAll("[0-9.]", "");
		}
	}

}
