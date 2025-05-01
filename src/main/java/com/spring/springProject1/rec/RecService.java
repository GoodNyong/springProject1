package com.spring.springProject1.rec;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.spring.springProject1.common.vo.ExerciseGoalVo;
import com.spring.springProject1.common.vo.FoodInfoVo;
import com.spring.springProject1.common.vo.NutritionGoalVo;
import com.spring.springProject1.rec.vo.ExerciseRecordVo;
import com.spring.springProject1.rec.vo.MealRecordVo;

public interface RecService {

	void setExerciseRecord(ExerciseRecordVo vo);

	List<ExerciseRecordVo> getExerciseRecordList(int user_id);

	void updateExerciseRecord(ExerciseRecordVo vo);

	ExerciseRecordVo getExerciseRecordById(int record_id, int user_id);

	void deleteExerciseRecord(int record_id, int user_id);

	void multiUpdateExerciseRecord(List<ExerciseRecordVo> recordList);

	void multiDeleteExerciseRecord(HttpServletRequest request, int userId);

	void multiSetExerciseRecord(List<ExerciseRecordVo> exerciseRecordList);

	void setMealRecord(MealRecordVo vo);

	List<MealRecordVo> getMealRecordList(int user_id);

	void multiSetMealRecord(List<MealRecordVo> mealRecordList);

	MealRecordVo getMealRecordById(int mealId, int userId);

	void updateMealRecord(MealRecordVo vo);

	void deleteMealRecord(int mealId, int userId);

	void multiUpdateMealRecord(List<MealRecordVo> mealRecordList);

	void multiDeleteMealRecord(HttpServletRequest request, int userId);

	void setExerciseGoal(ExerciseGoalVo vo);

	List<ExerciseGoalVo> getExerciseGoalList(int user_id);

	ExerciseGoalVo getExerciseGoalById(int goal_id, int user_id); // 운동 목표 단건 조회

	void updateExerciseGoal(ExerciseGoalVo vo); // 운동 목표 수정 처리

	void deleteExerciseGoal(int goal_id, int user_id);

	void multiUpdateExerciseGoal(List<ExerciseGoalVo> goalList);

	void multiDeleteExerciseGoal(HttpServletRequest request, int user_id);
	
	void setNutritionGoal(NutritionGoalVo vo); // 식단 목표 등록
	
	List<FoodInfoVo> getAllFoodList(); // 식품 전체 목록 조회 (목표 설정용)
	
	List<NutritionGoalVo> getNutritionGoalList(int user_id);

	NutritionGoalVo getNutritionGoalById(int goal_id, int user_id);

	void updateNutritionGoal(NutritionGoalVo vo);

	void deleteNutritionGoal(int goal_id, int user_id);

	


}
