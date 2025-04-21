package com.spring.springProject1.rec;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
}
