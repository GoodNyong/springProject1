package com.spring.springProject1.rec.wrapper;

import java.util.List;

import com.spring.springProject1.common.vo.NutritionGoalVo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NutritionGoalListWrapper {
	private List<NutritionGoalVo> goalList;
}
