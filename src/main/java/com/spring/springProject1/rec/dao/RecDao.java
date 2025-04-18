package com.spring.springProject1.rec.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.spring.springProject1.rec.ExerciseRecordVo;

@Repository
@Mapper
public interface RecDao {

	void setExerciseRecord(ExerciseRecordVo vo);
	
	List<ExerciseRecordVo> getExerciseRecordList(@Param("user_id") int user_id);
	
	int updateExerciseRecord(ExerciseRecordVo vo);

	ExerciseRecordVo getExerciseRecordById(@Param("record_id") int record_id, @Param("user_id") int user_id);
	
	int deleteExerciseRecord(@Param("record_id") int record_id, @Param("user_id") int user_id);

	int multiDeleteExerciseRecord(@Param("recordIdList") List<Integer> recordIdList, @Param("user_id") int user_id);

}
