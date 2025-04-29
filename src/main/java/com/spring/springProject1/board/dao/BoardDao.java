package com.spring.springProject1.board.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.springProject1.board.BoardCommentVo;
import com.spring.springProject1.board.BoardFileVo;
import com.spring.springProject1.board.BoardLikeVo;
import com.spring.springProject1.board.BoardViewLogVo;
import com.spring.springProject1.board.BoardVo;

public interface BoardDao {

	int getBoardTotRecCnt();

	List<BoardVo> getBoardList(@Param("category") String category, @Param("startIndexNo") Integer startIndexNo, @Param("pageSize") Integer pageSize);

	int setBoardInput(@Param("vo") BoardVo vo);

	void setBoardFile(@Param("fileVo") BoardFileVo fileVo);

	void setBoardViewLog(@Param("board_id") int board_id, @Param("sUser_id") int sUser_id, @Param("host_ip") String host_ip);

	BoardViewLogVo getBoardViewLog(@Param("board_id") int board_id, @Param("user_id") int user_id);

	BoardVo getBoardContent(@Param("board_id") int board_id);

	void increaseReadCount(@Param("board_id") int board_id);

	BoardVo getPreNextBoardContent(@Param("board_id") int board_id, @Param("preNext") String preNext);

	BoardLikeVo getBoardLike(@Param("board_id") Integer board_id, @Param("sUser_id") Integer sUser_id);
	
	void deleteBoardLike(@Param("board_id") Integer board_id, @Param("user_id") Integer user_id);

	void decreaseLikeCount(@Param("board_id") Integer board_id);

	void setBoardLike(@Param("board_id") Integer board_id, @Param("user_id") Integer user_id);

	void increaseLikeCount(@Param("board_id") Integer board_id);

	List<BoardCommentVo> getBoardCommentList(@Param("board_id") Integer board_id);

	int setBoardComment(@Param("board_id") Integer board_id, @Param("user_id") Integer user_id, @Param("username") String username, @Param("content") String content, @Param("host_ip") String host_ip);

	void increaseBoardCommentCount(@Param("board_id") Integer board_id);

	


}
