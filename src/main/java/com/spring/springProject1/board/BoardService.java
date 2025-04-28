package com.spring.springProject1.board;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public interface BoardService {

	List<BoardVo> getBoardList(String category, Integer startIndexNo, Integer pageSize);

	void imgCheck(String content);

	int setBoardInput(BoardVo vo);
	
	void setBoardFile(String content, int board_id);

	boolean checkViewDuplicate(int board_id, int sUser_id);

	void setBoardViewLog(int board_id, int sUser_id, String remoteAddr);

	BoardVo getBoardContent(int board_id);

	void updateReadCount(int board_id);

	boolean checkUserLiked(int board_id, int sUser_id);

	BoardVo getPreNextBoardContent(int board_id, String preNext);

	void deleteBoardLike(int board_id, int user_id);

	void decreaseLikeCount(int board_id);

	void setBoardLike(int board_id, int user_id);

	void increaseLikeCount(int board_id);

	/*
	 * int setBoardInput(BoardVo vo);
	 * 
	 * int setBoardFilesInput(int board_id, List<MultipartFile> files, String
	 * uploadPath);
	 */

}
