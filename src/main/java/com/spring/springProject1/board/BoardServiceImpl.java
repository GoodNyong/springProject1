package com.spring.springProject1.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.springProject1.board.dao.BoardDao;
import com.spring.springProject1.common.DateTimeAgoFormatter;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	BoardDao boardDao;
	
	//여기서 처리하는 이유
	//Controller	"누구한테 뭘 시킬지" 결정만 함 (전달자 역할)
	//Controller는 단순히 "Model에 담아서 JSP로 넘기기"만 하는 곳 코드가 더러워지면 재사용 불가
	//ServiceImpl	"데이터를 어떻게 처리해서 쓸 것인가" 결정함 (가공 처리 담당)
	//DAO/Mapper	"DB에서 어떤 raw 데이터를 가져올지" 결정함 (데이터 접근 담당)
	@Override
	public List<BoardVo> getBoardList(String category, Integer startIndexNo, Integer pageSize) {
		 List<BoardVo> list = boardDao.getBoardList(category, startIndexNo, pageSize);
		 for (BoardVo vo : list) {
			 vo.setFormattedTime(DateTimeAgoFormatter.FormatDateTimeAgo(vo.getCreated_at()));
		 }
		 return list;
	}
//	boardDao.getBoardList(category, startIndexNo, pageSize)를 통해
//	dao로 보내고 mapper에서 select된 vo들, 즉 게시물 데이터들을
//	ServiceImpl에서 다시 list에 담는다.
//	그 안에 있는 vo들을 향상 반복문에서 BoardVo 타입의 vo 변수에 하나씩 넣는다.
//	그리고 그 vo의 created_at 값을 common 패키지의 DateTimeAgoFormatter 클래스 안의 FormatDateTimeAgo 메서드에 매개값으로 넣고,
//	그 리턴값을 setFormattedTime으로 저장해서
//	다시 list에 담아(담는게 아니라 정확히는 굳이 담지 않아도 그 list안의 vo들을 하나씩 꺼내 formattedTime값을 새로 저장한거) Controller에 리턴한다.
	
}
