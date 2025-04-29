package com.spring.springProject1.board;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public interface BoardService {

	List<BoardVo> getBoardList(String category, Integer startIndexNo, Integer pageSize);

	void imgCheck(String content);

	int setBoardInput(BoardVo vo);
	
	void setBoardFile(String content, int board_id);

	boolean checkViewDuplicate(int board_id, int sUser_id);

	void setBoardViewLog(int board_id, int sUser_id, String host_ip);

	BoardVo getBoardContent(int board_id);

	void increaseReadCount(int board_id);

	BoardVo getPreNextBoardContent(int board_id, String preNext);
	
	boolean checkIsLiked(Integer board_id, Integer sUser_id);

	void deleteBoardLike(Integer board_id, Integer user_id);

	void decreaseLikeCount(Integer board_id);

	void setBoardLike(Integer board_id, Integer user_id);

	void increaseLikeCount(Integer board_id);

	List<BoardCommentVo> getBoardCommentList(Integer board_id);

	void setBoardComment(Integer board_id, Integer user_id, String username, String content, String host_ip);

	void increaseBoardCommentCount(Integer board_id);

	/*
	 * int setBoardInput(BoardVo vo);
	 * 
	 * int setBoardFilesInput(int board_id, List<MultipartFile> files, String
	 * uploadPath);
	 */

}
