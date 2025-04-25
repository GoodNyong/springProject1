package com.spring.springProject1.common.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.spring.springProject1.common.eNum.NutrientEnum;

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

	private Double target_value; // double → Double 로 변경(null허용, 백엑드 유효성 검사 필요)
	private Integer goal_unit;     // 1=g, 2=kcal, 3=회 등

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date start_date;

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date end_date;
	
	private String nutrient_name;       // Enum 기반 name 출력용
	private String food_name;           // Mapper에서 조인된 값
	private String goal_unit_label;     // 단위명 표시용

	
	
    /*
     * nutrient_id 필드의 정수 값을 기반으로 NutrientEnum 객체를 반환합니다.
     * 
     * 사용 목적:
     * - nutrient_id는 DB에 저장된 코드(int) 값이므로, 이를 사람이 이해하기 쉬운 이름(name)과 단위(unit)로 변환할 때 사용합니다.
     * - 예: "102" → "단백질", 단위는 "g"
     * 
     * 사용 예시:
     * NutrientEnum nutrient = vo.getNutrientEnum();
     * String label = nutrient.getName();   // "단백질"
     * String unit = nutrient.getUnit();    // "g"
     * 
     * 주의:
     * - null이거나 유효하지 않은 nutrient_id일 경우 null을 반환하므로 null 체크 필수입니다.
     * - 이 메서드는 View 렌더링 또는 로직 해석용 보조 도구이며, DB 저장/조회에는 영향을 주지 않습니다.
     */
	public NutrientEnum getNutrientEnum() {
		if (this.nutrient_id == null) return null;
		return NutrientEnum.findById(this.nutrient_id);
	}

}
