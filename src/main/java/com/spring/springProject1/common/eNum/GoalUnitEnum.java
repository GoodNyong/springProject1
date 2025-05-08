package com.spring.springProject1.common.eNum;

public enum GoalUnitEnum {
	
	/**
	 * GoalUnitEnum.java
	 *
	 * ✔ 목표 단위 코드 관리를 위한 Enum 클래스
	 * ✔ 운동 목표 및 식단 목표에서 공통으로 사용됨
	 * ✔ 코드값(int) → 단위명(label), 범주(category), 정수 여부, 적용 타입(goalType) 등 정보를 매핑함
	 *
	 * 사용 목적:
	 * - DB goal_unit 정수코드를 라벨로 출력
	 * - select 박스 렌더링에 사용
	 * - 정수/소수 유효성 판단에 활용
	 * - 운동/식단 목표를 구분하여 필요한 단위만 추출 가능
	 *
	 * goalType:
	 * 1 = 운동 목표 전용
	 * 2 = 식단 목표 전용
	 * 3 = 공통 (필요 시 추가)
	 */

	// 운동 목표용
	U01(1, "분", "시간", 1, true),
	U02(2, "시간", "시간", 1, true),
	U11(11, "kcal", "에너지", 1, false),
	U12(12, "J", "에너지", 1, false),
	U21(21, "회", "횟수", 1, true),
	U22(22, "세트", "횟수", 1, true),

	// 식단 목표용
	U31(31, "g", "질량", 2, false),
	U32(32, "ml", "부피", 2, false),
	U33(33, "개", "개수", 2, true),
	U34(34, "컵", "용량", 2, true),
	U35(35, "공기", "식사단위", 2, true),
	U36(36, "조각", "식사단위", 2, true),
	U37(37, "µg", "질량", 2, false), // 식단 목표용: 마이크로그램 단위
	U38(38, "mg", "질량", 2, false), // 식단 목표용 mg 단위



	// 공통 (식단/운동 양쪽에 걸쳐 사용 가능할 경우)
	// 필요 시 goalType = 3 지정

	;

	private final int code;
	private final String label; // 단위 문자열("분", "회" 등)
	private final String category;
	private final int goalType; // 1=운동, 2=식단
	private final boolean isInteger;

	GoalUnitEnum(int code, String label, String category, int goalType, boolean isInteger) {
		this.code = code;
		this.label = label;
		this.category = category;
		this.goalType = goalType;
		this.isInteger = isInteger;
	}

	public int getCode() {
		return code;
	}

	public String getLabel() {
		return label;
	}

	public String getCategory() {
		return category;
	}

	public int getGoalType() {
		return goalType;
	}

	public boolean isIntegerOnly() {
		return isInteger;
	}

	public static GoalUnitEnum findByCode(int code) {
		for (GoalUnitEnum g : values()) {
			if (g.code == code) return g;
		}
		return null;
	}
}
