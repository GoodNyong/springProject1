package com.spring.springProject1.rec.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.spring.springProject1.rec.ExerciseRecordVo;

@Repository
@Mapper
public interface RecDao {

	int setExerciseRecord(ExerciseRecordVo vo);
	
	List<ExerciseRecordVo> getExerciseRecordList(@Param("user_id") int user_id);

	
}
