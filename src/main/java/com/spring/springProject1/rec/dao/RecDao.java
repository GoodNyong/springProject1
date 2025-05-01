package com.spring.springProject1.rec.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.spring.springProject1.common.vo.ExerciseGoalVo;
import com.spring.springProject1.common.vo.FoodInfoVo;
import com.spring.springProject1.common.vo.NutritionGoalVo;
import com.spring.springProject1.rec.vo.ExerciseRecordVo;
import com.spring.springProject1.rec.vo.MealRecordVo;

@Repository
@Mapper
public interface RecDao {

	void setExerciseRecord(ExerciseRecordVo vo);

	List<ExerciseRecordVo> getExerciseRecordList(@Param("user_id") int user_id);

	int updateExerciseRecord(ExerciseRecordVo vo);

	ExerciseRecordVo getExerciseRecordById(@Param("record_id") int record_id, @Param("user_id") int user_id);

	int deleteExerciseRecord(@Param("record_id") int record_id, @Param("user_id") int user_id);

	int multiDeleteExerciseRecord(@Param("recordIdList") List<Integer> recordIdList, @Param("user_id") int user_id);

	void setMealRecord(MealRecordVo vo);

	List<MealRecordVo> getMealRecordList(@Param("user_id") int user_id);

	MealRecordVo getMealRecordById(@Param("meal_id") int meal_id, @Param("user_id") int user_id);

	int updateMealRecord(@Param("vo") MealRecordVo vo);

	int deleteMealRecord(@Param("meal_id") int meal_id, @Param("user_id") int user_id);

	int multiDeleteMealRecord(@Param("recordIdList") List<Integer> recordIdList, @Param("user_id") int user_id);

	void insertExerciseGoal(ExerciseGoalVo vo);

	List<ExerciseGoalVo> getExerciseGoalList(int user_id);

	ExerciseGoalVo getExerciseGoalById(@Param("goal_id") int goal_id, @Param("user_id") int user_id); // 운동 목표 단건 조회

	int updateExerciseGoal(ExerciseGoalVo vo); // 운동 목표 수정 처리

	int deleteExerciseGoal(@Param("goal_id") int goal_id, @Param("user_id") int user_id);

	int deleteExerciseGoals(@Param("goalIds") List<Integer> goalIds, @Param("user_id") int user_id);

	void insertNutritionGoal(NutritionGoalVo vo); // 식단 목표 등록

	List<FoodInfoVo> getAllFoodList(); // 식품 목록 조회

	List<NutritionGoalVo> getNutritionGoalList(int user_id);

	NutritionGoalVo getNutritionGoalById(@Param("goal_id") int goal_id, @Param("user_id") int user_id);

	int updateNutritionGoal(NutritionGoalVo vo);
	
	int deleteNutritionGoal(@Param("goal_id") int goal_id, @Param("user_id") int user_id);

	public FoodInfoVo getFoodById(int foodId);
}
