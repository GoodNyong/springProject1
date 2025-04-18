package com.spring.springProject1.rec;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ExerciseRecordListWrapper {

    private List<ExerciseRecordVo> exerciseRecordList = new ArrayList<>();

}