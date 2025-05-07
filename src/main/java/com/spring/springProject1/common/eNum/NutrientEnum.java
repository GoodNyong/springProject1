package com.spring.springProject1.common.eNum;

/**
 * NutrientEnum.java
 * 
 * 영양소 nutrient_id 코드값을 enum으로 정리한 열거형 클래스입니다.
 * 
 * 사용 목적:
 * - NutritionGoal 테이블에서 nutrient_id(int) 값을 enum으로 관리
 * - 화면 표시용 영양소 이름(name)과 단위(unit) 정보를 함께 보관
 * - 다른 기능(예: 리포트, 추천, 피드백 등)에서도 재사용 가능
 * 
 * 주요 메서드:
 * - getId(): nutrient_id 반환
 * - getName(): 영양소 이름 반환 (예: 단백질)
 * - getUnit(): 단위 반환 (예: g, kcal)
 * - findById(int id): nutrient_id로 enum 객체 조회
 * 
 * 사용 예시:
 * NutrientEnum nutrient = NutrientEnum.findById(102);
 * String name = nutrient.getName();  // "단백질"
 * String unit = nutrient.getUnit();  // "g"
 * 
 * enum은 VO나 Mapper에서 직접 사용하는 것이 아니라,
 *     int → enum 변환을 통해 보조 데이터로 활용합니다.
 */

public enum NutrientEnum {
	N101(101, "탄수화물", "g", 31),
	N102(102, "단백질", "g", 31),
	N103(103, "지방", "g", 31),
	N104(104, "열량(칼로리)", "kcal", 11),
	N105(105, "식이섬유", "g", 31),
	N106(106, "나트륨", "mg", 32),
	N107(107, "당류(총합)", "g", 31),
	N108(108, "포도당", "g", 31),
	N109(109, "과당", "g", 31),
	N110(110, "비타민 A", "µg", 37),
	N111(111, "비타민 C", "mg", 32),
	N112(112, "비타민 D", "µg", 37),
	N113(113, "비타민 E", "mg", 32),
	N114(114, "비타민 B1", "mg", 32),
	N115(115, "비타민 B2", "mg", 32),
	N116(116, "비타민 B6", "mg", 32),
	N117(117, "비타민 B12", "µg", 37),
	N118(118, "엽산(비타민 B9)", "µg", 37),
	N119(119, "철분", "mg", 32);

	private final int id;
	private final String name;
	private final String unit;
	private final int goalUnitCode; // GoalUnitEnum.code 연결

	NutrientEnum(int id, String name, String unit, int goalUnitCode) {
		this.id = id;
		this.name = name;
		this.unit = unit;
		this.goalUnitCode = goalUnitCode;
	}

	public int getId() { return id; }

	public String getName() { return name; }

	public String getUnit() { return unit; }

	public int getGoalUnitCode() { return goalUnitCode; }

	public GoalUnitEnum getGoalUnitEnum() {
		return GoalUnitEnum.findByCode(goalUnitCode);
	}

	public static NutrientEnum findById(int id) {
		for (NutrientEnum n : values()) {
			if (n.id == id) return n;
		}
		return null;
	}
}
