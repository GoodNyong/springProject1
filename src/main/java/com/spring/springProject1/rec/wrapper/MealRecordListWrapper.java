package com.spring.springProject1.rec.wrapper;

import java.util.ArrayList;
import java.util.List;

import com.spring.springProject1.rec.vo.MealRecordVo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MealRecordListWrapper {

    private List<MealRecordVo> mealRecordList = new ArrayList<>();

}
