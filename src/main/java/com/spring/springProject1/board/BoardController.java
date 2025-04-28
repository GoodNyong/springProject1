package com.spring.springProject1.board;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
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

		vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/fileUpload/"));

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
	@RequestMapping(value = "/boardContent", method = RequestMethod.GET)
	public String boardContentGet(int board_id, HttpSession session, HttpServletRequest request, Model model) {
		

		int sUser_id = (int) session.getAttribute("sUser_id");
		System.out.println("sUser_id" + sUser_id);
		
		// 로그추가
		boardService.setBoardViewLog(board_id, sUser_id, request.getRemoteAddr());
		
		// 게시글 가져오기
		BoardVo boardVo = boardService.getBoardContent(board_id);
		
		if (boardVo == null || boardVo.getIs_deleted() == 1) {
			return "redirect:/message/boardContentNo"; // 🔥 삭제되었거나 없는 게시글
		}

		// 24시간 조회수 중복 방지
		boolean checkViewDuplicate = boardService.checkViewDuplicate(board_id, sUser_id);
		if (checkViewDuplicate) {
			boardService.updateReadCount(board_id);
		}

		// 좋아요 여부 조회
		boolean isLiked = boardService.checkUserLiked(board_id, sUser_id);

		// 이전글 / 다음글 가져오기
		BoardVo preVo = boardService.getPreNextBoardContent(board_id, "pre");
		BoardVo nextVo = boardService.getPreNextBoardContent(board_id, "next");

		// 댓글 + 대댓글 리스트 가져오기
		// List<CommentVo> commentList = boardService.getCommentReplyList(board_id);

		// 모델 담기
		model.addAttribute("boardVo", boardVo);
		model.addAttribute("isLiked", isLiked);
		model.addAttribute("preVo", preVo);
		model.addAttribute("nextVo", nextVo);
		//model.addAttribute("commentList", commentList);

		return "board/boardContent";
	}
	
	/*
	 * //좋아요 눌렀을 때
	 * 
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/updateBoardLike", method = RequestMethod.POST)
	 * public String updateBoardLikePost(int board_id, int like_count, HttpSession
	 * session, BoardVo vo) {
	 * 
	 * String res = "0"; int user_id = (int) session.getAttribute("sUser_id");
	 * 
	 * boolean isLiked = boardService.checkUserLiked(board_id, user_id);
	 * 
	 * if (isLiked) { boardService.deleteBoardLike(board_id, user_id);
	 * boardService.decreaseLikeCount(board_id); return
	 * "redirect:/message/decreaseLikeCountOk?board_id=" + vo.getBoard_id(); } else
	 * { boardService.setBoardLike(board_id, user_id);
	 * boardService.increaseLikeCount(board_id); return
	 * "redirect:/message/increaseLikeCountOk?board_id=" + vo.getBoard_id(); }
	 * return res; }
	 */

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
