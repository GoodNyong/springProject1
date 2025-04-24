package com.spring.springProject1.board.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.springProject1.board.BoardVo;

public interface BoardDao {

	int getBoardTotRecCnt();

	List<BoardVo> getBoardList(@Param("category") String category, @Param("startIndexNo") Integer startIndexNo, @Param("pageSize") Integer pageSize);


}
