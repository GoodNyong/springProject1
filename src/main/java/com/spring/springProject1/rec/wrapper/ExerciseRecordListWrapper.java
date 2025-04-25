package com.spring.springProject1.rec.wrapper;

import java.util.ArrayList;
import java.util.List;

import com.spring.springProject1.rec.vo.ExerciseRecordVo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ExerciseRecordListWrapper {

    private List<ExerciseRecordVo> exerciseRecordList = new ArrayList<>();

}