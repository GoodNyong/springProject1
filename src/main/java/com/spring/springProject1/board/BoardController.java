package com.spring.springProject1.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.springProject1.common.PageVo;
import com.spring.springProject1.common.Pagination;

@Controller
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	Pagination pagination;
	
	@RequestMapping(value = "/boardList/{category}", method = RequestMethod.GET)
	public String boardListGet(Model model,
			@PathVariable String category,
			@RequestParam(name="pag", defaultValue = "1", required = false) Integer pag,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) Integer pageSize
		) {
		
		// 1. 페이징 처리
    PageVo pageVo = pagination.getTotRecCnt(pag, pageSize, "board"
//   		, "", "/"
    		);
    // 2. 게시글 목록 조회 
    List<BoardVo> boardList = boardService.getBoardList(category, pageVo.getStartIndexNo(), pageVo.getPageSize());    

    // 3. model에 담기
    model.addAttribute("boardList", boardList);
    model.addAttribute("pageVo", pageVo);
    model.addAttribute("category", category);

    return "board/boardList";
	}
}
