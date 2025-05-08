package com.spring.springProject1.rec.wrapper;

import java.util.List;

import com.spring.springProject1.common.vo.ExerciseGoalVo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ExerciseGoalListWrapper {
	private List<ExerciseGoalVo> goalList;
}
