package com.spring.springProject1.rec;

import java.util.List;

public interface RecService {

	void setExerciseRecord(ExerciseRecordVo vo);

	List<ExerciseRecordVo> getExerciseRecordList(int user_id);

	void updateExerciseRecord(ExerciseRecordVo vo);

	ExerciseRecordVo getExerciseRecordById(int record_id, int user_id);

	void deleteExerciseRecord(int record_id, int user_id);

}
