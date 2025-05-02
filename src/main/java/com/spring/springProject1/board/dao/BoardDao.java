package com.spring.springProject1.board.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.springProject1.board.BoardCommentVo;
import com.spring.springProject1.board.BoardFileVo;
import com.spring.springProject1.board.BoardLikeVo;
import com.spring.springProject1.board.BoardReplyVo;
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

	BoardVo getPreNextBoardContent(@Param("board_id") int board_id, @Param("preNext") String preNext, @Param("category") String category);

	BoardLikeVo getBoardLike(@Param("board_id") Integer board_id, @Param("sUser_id") Integer sUser_id);
	
	void deleteBoardLike(@Param("board_id") Integer board_id, @Param("user_id") Integer user_id);

	void decreaseLikeCount(@Param("board_id") Integer board_id);

	void setBoardLike(@Param("board_id") Integer board_id, @Param("user_id") Integer user_id);

	void increaseLikeCount(@Param("board_id") Integer board_id);

	List<BoardCommentVo> getBoardCommentList(@Param("board_id") Integer board_id);
	BoardCommentVo getBoardComment(@Param("comment_id") Integer comment_id);
	
	int setBoardComment(@Param("board_id") Integer board_id, @Param("user_id") Integer user_id, @Param("username") String username, @Param("content") String content, @Param("host_ip") String host_ip);

	void increaseBoardCommentCount(@Param("board_id") Integer board_id);

	void setBoardReply(@Param("comment_id") Integer comment_id, @Param("user_id") Integer user_id, @Param("username") String username, @Param("content") String content, @Param("host_ip") String host_ip);

	List<BoardReplyVo> getBoardReplyList(@Param("comment_id") Integer comment_id);
	BoardReplyVo getBoardReply(@Param("reply_id") Integer reply_id);

	void increaseCommentLikeCount(@Param("comment_id") Integer comment_id);

	void setBoardReport(@Param("part") String part, @Param("board_id") Integer board_id, @Param("comment_id") Integer comment_id, @Param("reply_id") Integer reply_id,
				@Param("user_id") Integer user_id, @Param("reason") String reason);

	int setBoardDelete(@Param("board_id") int board_id);

	int setBoardCommentDelete(@Param("comment_id") Integer comment_id);

	int setBoardReplyDelete(@Param("reply_id") Integer reply_id);

	int getBoardtotRecCntByUser(@Param("user_id") int user_id);

	List<BoardVo> getBoardListByUser(@Param("user_id") int user_id, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);


}
