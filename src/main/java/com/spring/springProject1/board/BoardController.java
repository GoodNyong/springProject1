package com.spring.springProject1.board;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

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
	public String boardListGet(Model model, @PathVariable String category,
			@RequestParam(name = "pag", defaultValue = "1", required = false) Integer pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) Integer pageSize) {

		// 1. 페이징 처리
		PageVo pageVo = pagination.getTotRecCnt(pag, pageSize, "board");
//   		, "", "/"
//		);
		// 2. 게시글 목록 조회
		List<BoardVo> vos = boardService.getBoardList(category, pageVo.getStartIndexNo(), pageVo.getPageSize());

		// 3. model에 담기
		model.addAttribute("vos", vos);
		model.addAttribute("pageVo", pageVo);
		model.addAttribute("category", category);

		return "board/boardList";
	}

	// 게시글 입력폼 보기
	@RequestMapping(value = "/boardInput", method = RequestMethod.GET)
	public String boardInputGet() {
		return "board/boardInput";
	}

	// 게시글 입력 처리
	@RequestMapping(value = "/boardInput", method = RequestMethod.POST)
	public String boardInputPost(BoardVo vo, HttpSession session) {
		if (vo.getContent().indexOf("src=\"/") != -1)
			boardService.imgCheck(vo.getContent());

		vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/board/"));

		int res = boardService.setBoardInput(vo);

		if (res != 0) {
			boardService.setBoardFile(vo.getContent(), vo.getBoard_id());
			return "redirect:/message/boardInputOk?category=" + vo.getCategory();
		} else
			return "redirect:/message/boardInputNo";
	}

	@RequestMapping(value = "/imageUpload")
	public void imageUploadGet(MultipartFile upload, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");

		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/ckeditor/");
		String oFileName = upload.getOriginalFilename();

		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
		oFileName = sdf.format(date) + "_" + oFileName;

		byte[] bytes = upload.getBytes();
		FileOutputStream fos = new FileOutputStream(new File(realPath + oFileName));
		fos.write(bytes);

		PrintWriter out = response.getWriter();
		String fileUrl = request.getContextPath() + "/data/ckeditor/" + oFileName;
		out.println("{\"originalFilename\":\"" + oFileName + "\",\"uploaded\":1,\"url\":\"" + fileUrl + "\"}");
		out.flush();

		fos.close();
	}

	//게시글 상세 보기
	@RequestMapping(value = "/boardContent/{category}/{board_id}", method = RequestMethod.GET)
	public String boardContentGet(@PathVariable int board_id, @PathVariable String category, HttpSession session, HttpServletRequest request, Model model) {
		

		Integer sUser_id = (Integer) session.getAttribute("loginUser");
		if (sUser_id == null) {
	    return "redirect:/user/userLogin"; // 🔥 로그인 페이지로 리다이렉트
		}

		// 24시간 조회수 중복 방지, 조회수 증가
		boolean checkViewDuplicate = boardService.checkViewDuplicate(board_id, sUser_id);
		
		if (checkViewDuplicate) {
			boardService.increaseReadCount(board_id);
		}
		
		// 조회수 증가 한 이후(중복되면 안되니 이전 로그와 비교) 이번 로그 추가
		boardService.setBoardViewLog(board_id, sUser_id, request.getRemoteAddr());

		// 로그인 된 사용자 좋아요 여부 조회
//		boolean isLiked = boardService.checkIsLiked(board_id, sUser_id);

		
		System.out.println("category" + category);
		// 이전글 / 다음글 가져오기
		BoardVo preVo = boardService.getPreNextBoardContent(board_id, "pre", category);
		BoardVo nextVo = boardService.getPreNextBoardContent(board_id, "next", category);

		// 댓글 + 대댓글 리스트 가져오기
		// List<CommentVo> commentList = boardService.getCommentReplyList(board_id);
		
		// 게시글 가져오기
		BoardVo vo = boardService.getBoardContent(board_id);
		
		
		if (vo == null || vo.getIs_deleted() == 1) {
			return "redirect:/message/boardContentNo"; // 🔥 삭제되었거나 없는 게시글
		}
		
		//댓글 리스트 가져오기
		List<BoardCommentVo> commentVos = boardService.getBoardCommentList(board_id);
			
		// 모델 담기
		model.addAttribute("vo", vo);
		model.addAttribute("commentVos", commentVos);
//		model.addAttribute("isLiked", isLiked);
		model.addAttribute("preVo", preVo);
		model.addAttribute("nextVo", nextVo);
		//model.addAttribute("commentList", commentList);

		return "board/boardContent";
	}
	
	
	// 좋아요 눌렀을 때
	@ResponseBody
	@RequestMapping(value = "/updateBoardLike", method = RequestMethod.POST)
	public String updateBoardLikePost(Integer board_id, HttpSession session) {
	  Integer user_id = (Integer) session.getAttribute("loginUser");
	  if (user_id == null) {
	    return "nologin";
	  }

	  boolean isLiked = boardService.checkIsLiked(board_id, user_id);

	  if (isLiked) {
	    boardService.deleteBoardLike(board_id, user_id);
	    boardService.decreaseLikeCount(board_id);
	  } else {
	    boardService.setBoardLike(board_id, user_id);
	    boardService.increaseLikeCount(board_id);
	  }
	  return "updateLikeOk";
	}
	
	@SuppressWarnings("unchecked")
	// 좋아요 눌렀을 때
	@ResponseBody
	@RequestMapping(value = "/updateCommentLike", method = RequestMethod.POST)
	public String updateCommentLikePost(Integer comment_id, HttpSession session) {
		// 중복방지
		List<String> likeNum = (List<String>) session.getAttribute("sCommentLike");
		if(likeNum == null) likeNum = new ArrayList<String>();
		String imsiNum = "CommentLike" + comment_id;
		if(!likeNum.contains(imsiNum)) {
			boardService.increaseCommentLikeCount(comment_id);
			likeNum.add(imsiNum);
			session.setAttribute("sCommentLiker", imsiNum);
			return "updateCommentLikeOk";
		}
		return "alreadyCommentLike";
	}
	
	//댓글 등록
	@ResponseBody
	@RequestMapping(value = "/commentInput", method = RequestMethod.POST)
	public String commentInputPost(Integer board_id, String content, HttpSession session, HttpServletRequest request) {
	  Integer user_id = (Integer) session.getAttribute("loginUser");
	  String username = (String) session.getAttribute("sUsername");

	  if (user_id == null || username == null) {
	    return "nologin";
	  }

	  boardService.setBoardComment(board_id, user_id, username, content, request.getRemoteAddr());
	  boardService.increaseBoardCommentCount(board_id);
	  return "setCommentOk";
	}
	
	//답글 등록
	@ResponseBody
	@RequestMapping(value = "/replyInput", method = RequestMethod.POST)
	public String replyInputPost(Integer comment_id, String content, HttpSession session, HttpServletRequest request) {
		Integer user_id = (Integer) session.getAttribute("loginUser");
		String username = (String) session.getAttribute("sUsername");
		
		if (user_id == null || username == null) {
			return "nologin";
		}
		
		boardService.setBoardReply(comment_id, user_id, username, content, request.getRemoteAddr());
		return "setReplyOk";
	}
	
	@ResponseBody
	@RequestMapping(value = "/replyload", method = RequestMethod.GET)
	public List<BoardReplyVo> replyloadGet(Integer comment_id) {
	  List<BoardReplyVo> replyVos = boardService.getBoardReplyList(comment_id);
	  System.out.println("replyVos" + replyVos);
	  return replyVos;
	}
	
	//신고 처리
	@ResponseBody
	@RequestMapping(value = "/reportInput", method = RequestMethod.POST)
	public String reportInputPost(HttpSession session, String part, Integer board_id, Integer comment_id, Integer reply_id, String reason) {
		Integer user_id = (Integer) session.getAttribute("loginUser");
		
		if (user_id == null) {
			return "nologin";
		}
		System.out.println(part);
		
		boardService.setBoardReport(part, board_id, comment_id, reply_id, user_id, reason);
		return "setReportOk";
	}
	
	//삭제 처리
	@RequestMapping(value = "/boardDelete", method = RequestMethod.POST)
	public String boardDeletePOST(HttpSession session, Integer board_id, Integer comment_id, Integer reply_id, String part, String category) {
		Integer user_id = (Integer) session.getAttribute("loginUser");
		
		if(part.equals("boardContent")) {
			//본인이나 관리자인지 한번 더 확인
		  BoardVo vo = boardService.getBoardContent(board_id);
		  if (user_id == null || (!user_id.equals(vo.getUser_id()) && !session.getAttribute("sRole_id").equals(1))) {
		  	return "redirect:/message/deleteError?category="+category+"&board_id="+board_id;
		  }
		  
		  int res = boardService.setBoardDelete(board_id);
		  
			if(res != 0) return "redirect:/message/boardDeleteOk";
			else return "redirect:/message/boardDeleteNo?category="+category+"&board_id="+board_id;
		}
		
		else if(part.equals("boardComment")) {
			//본인이나 관리자인지 한번 더 확인
		  BoardCommentVo commentVo = boardService.getBoardComment(comment_id);
		  if (user_id == null || (!user_id.equals(commentVo.getUser_id()) && !session.getAttribute("sRole_id").equals(1))) {
		  	return "redirect:/message/deleteError?category="+category+"&board_id="+board_id;
		  }
		  
		  int res = boardService.setBoardCommentDelete(comment_id);
		  
			if(res != 0) return "redirect:/message/boardCommentDeleteOk?category="+category+"&board_id="+board_id;
			else return "redirect:/message/boardCommentDeleteNo?category="+category+"&board_id="+board_id;
		}
		
		else if(part.equals("boardReply")) {
			//본인이나 관리자인지 한번 더 확인
		  BoardReplyVo replyVo = boardService.getBoardReply(reply_id);
		  if (user_id == null || (!user_id.equals(replyVo.getUser_id()) && !session.getAttribute("sRole_id").equals(1))) {
		  	return "redirect:/message/deleteError?category="+category+"&board_id="+board_id;
		  }
		  
		  int res = boardService.setBoardReplyDelete(reply_id);
		  
			if(res != 0) return "redirect:/message/boardReplyDeleteOk?category="+category+"&board_id="+board_id;
			else return "redirect:/message/boardReplyDeleteNo?category="+category+"&board_id="+board_id;
		}
		
		
		else return "redirect:/message/deleteError?board_id="+board_id;
	}
	
	@RequestMapping(value = "/boardListByUser/{user_id}", method = RequestMethod.GET)
	public String boardListByUserGet(@PathVariable int user_id, Model model,
	                                 @RequestParam(name="pag", defaultValue = "1") int pag
	    ) {
	    int pageSize = 10; // 무조건 10개 고정

	    int totRecCnt = boardService.getBoardtotRecCntByUser(user_id);
	    PageVo pageVo = pagination.getPageVo(pag, pageSize, totRecCnt);

	    List<BoardVo> vos = boardService.getBoardListByUser(user_id, pageVo.getStartIndexNo(), pageSize);

	    model.addAttribute("vos", vos);
	    model.addAttribute("pageVo", pageVo);
	    model.addAttribute("category", "작성자글");
	    model.addAttribute("listTitle", "작성자 게시글 목록");

	    return "board/boardListByUser";
	}
	
	 

	/*
	 * //게시글 입력 처리
	 * 
	 * @RequestMapping(value = "/boardInput", method = RequestMethod.POST) public
	 * String boardInputPost(BoardVo vo, //MultipartFile은 Vo로 자동 바인딩되지 않음. 무조건 따로
	 * 받아야 함. List<MultipartFile> files ) { int res =
	 * boardService.setBoardInput(vo);
	 * 
	 * if(res != 0) { if(files != null && !files.isEmpty()) { //files 객체 자체가 아예 없는
	 * 경우 (null 포인터 방지용) && files 객체는 있지만 안에 실제 파일이 없는 경우 //그래서 두 조건을 모두 검사해야 **“파일이
	 * 전송되었고, 그 안에 최소한 하나 이상 실제 파일이 있다”**는 걸 확신할 수 있음.
	 * 
	 * <form method="post" enctype="multipart/form-data"> └── input type="file"
	 * name="files" multiple └─ 없음 → 서버엔 files 파라미터 자체가 안 감 → files == null └─ 0개
	 * 선택하고 전송 → 대부분 null로 간주됨 └─ 파일 선택함 → Spring이 files = new ArrayList<>(...) 자동
	 * 바인딩
	 * 
	 * HttpServletRequest request = ((ServletRequestAttributes)
	 * RequestContextHolder.currentRequestAttributes()).getRequest(); String
	 * uploadPath = request.getSession().getServletContext().getRealPath(
	 * "/resources/data/board/upload/");
	 * 
	 * RequestContextHolder.currentRequestAttributes() 지금 사용자 요청을 스프링에서 꺼내와
	 * (ServletRequestAttributes) 그걸 서블릿 요청으로 강제로 바꿔줘 .getRequest() 실제
	 * HttpServletRequest 객체 꺼냄 .getSession() 요청에서 세션 꺼냄 .getServletContext() 세션에서
	 * 전체 웹 애플리케이션 환경 가져옴 .getRealPath(...) 웹 경로 → 진짜 디스크 경로로 변환
	 * 
	 * int res2 = boardService.setBoardFilesInput(vo.getBoard_id(), files,
	 * uploadPath); if(res2 != 0) { return
	 * "redirect:/message/boardInputOkboardFilesInputOk"; //게시물은 Ok 파일 Ok } else
	 * return "redirect:/message/boardInputOkboardFilesInputNo"; //게시물 Ok 파일 No }
	 * return "rediret:/message/boardInputOk"; //파일 없음 게시물 저장 완료 } else return
	 * "redirect:/message/boardInputNo"; //애초에 게시물 저장 실패 }
	 */

}
