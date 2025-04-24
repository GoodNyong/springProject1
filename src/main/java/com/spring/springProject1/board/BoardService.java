package com.spring.springProject1.board;

import java.util.List;

public interface BoardService {

	List<BoardVo> getBoardList(String category, Integer startIndexNo, Integer pageSize);

}
