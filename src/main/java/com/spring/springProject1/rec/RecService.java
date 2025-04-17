package com.spring.springProject1.rec;

import java.util.List;

public interface RecService {

	int setExerciseRecord(ExerciseRecordVo vo);

	List<ExerciseRecordVo> getExerciseRecordList(int user_id);

	

}
