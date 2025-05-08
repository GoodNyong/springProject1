package com.spring.springProject1.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.springProject1.board.dao.BoardDao;

@Service
public class Pagination {
	
	@Autowired
	BoardDao boardDao;
//		
//	@Autowired
//	PdsDao pdsDao;
//	
//	@Autowired
//	WebMessageDao webMessageDao;
//
	public PageVo getTotRecCnt(int pag, int pageSize, String section
//			, String part, String searchString
			) {
		PageVo vo = new PageVo();
//		
		int totRecCnt = 0;
//		String search = "";
//		String searchStr = "";
//		
//		검색어가 넘어왔을경우 처리하는 부분
//		if(!searchString.equals("/")) {	// searchString : 'title/공지'
//			search = searchString.split("/")[0];
//			searchString = searchString.split("/")[1];
//		}
//		
		if(section.equals("board")) {
//      if (part == null || part.isEmpty()) {
        totRecCnt = boardDao.getBoardTotRecCnt(); // 전체 게시글 수
//      }
//			else totRecCnt = boardDao.getBoardTotRecCntSearch(part, searchString); //검색 적용된 경우
		}
//		else if(section.equals("pds")) {
//			totRecCnt = pdsDao.getPdsTotRecCnt(part);
//		}
//		else if(section.equals("webMessage")) {
//			String mid = part;
//			int mSw = Integer.parseInt(searchString);
//			totRecCnt = webMessageDao.getTotRecCnt(mid, mSw);
//		}
//		
//		 검색기(search(part)와 searchString)를 통한 리스트를 구현하기위한 처리
//		if(section.equals("pds") && !searchString.equals("")) {
//			search = part;
//			if(totRecCnt != 0) pageSize = totRecCnt;
//			if(part.equals("title")) searchStr = "글제목";
//			else if(part.equals("nickName")) searchStr = "닉네임";
//			else searchStr = "글내용";
//		}
//		
		int totPage = (totRecCnt % pageSize) == 0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStartNo = totRecCnt - startIndexNo;
		
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage - 1) / blockSize;

    vo.setPag(pag);
    vo.setPageSize(pageSize);
    vo.setTotRecCnt(totRecCnt);
    vo.setTotPage(totPage);
    vo.setStartIndexNo(startIndexNo);
    vo.setCurScrStartNo(curScrStartNo);
    vo.setBlockSize(blockSize);
    vo.setCurBlock(curBlock);
    vo.setLastBlock(lastBlock);
//    vo.setSearchString(searchString);
//    vo.setPart(part);
		
		return vo;
	}
	
	public PageVo getPageVo(int pag, int pageSize, int totRecCnt) {
    PageVo vo = new PageVo();

    int totPage = (totRecCnt % pageSize == 0) ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
    int startIndexNo = (pag - 1) * pageSize;
    int curScrStartNo = totRecCnt - startIndexNo;

    int blockSize = 3;
    int curBlock = (pag - 1) / blockSize;
    int lastBlock = (totPage - 1) / blockSize;

    vo.setPag(pag);
    vo.setPageSize(pageSize);
    vo.setTotRecCnt(totRecCnt);
    vo.setTotPage(totPage);
    vo.setStartIndexNo(startIndexNo);
    vo.setCurScrStartNo(curScrStartNo);
    vo.setBlockSize(blockSize);
    vo.setCurBlock(curBlock);
    vo.setLastBlock(lastBlock);

    return vo;
	}
	
	
	
}
