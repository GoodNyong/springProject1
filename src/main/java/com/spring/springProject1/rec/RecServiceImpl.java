package com.spring.springProject1.rec;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.springProject1.rec.dao.RecDao;

@Service
public class RecServiceImpl implements RecService {

	@Autowired
	private RecDao recDao;

	@Override
	public void setExerciseRecord(ExerciseRecordVo vo) {
		// 기본 검증
		if (vo.getExercise_id() <= 0)
			throw new IllegalArgumentException("운동 종류가 선택되지 않았어요! 마법의 준비가 부족해요.");

		if (vo.getDuration_minutes() <= 0)
			throw new IllegalArgumentException("1분도 안 움직인 건 마법으로 인정할 수 없어요!");

		if (vo.getCalories_burned() < 0)
			throw new IllegalArgumentException("마법의 칼로리는 음수가 될 수 없답니다!");

		if (vo.getActivity_date() == null || vo.getActivity_date().after(new Date()))
			throw new IllegalArgumentException("아직 오지 않은 미래에는 마법을 쓸 수 없어요.");

		if (vo.getSource_platform() != null && vo.getSource_platform().length() > 50)
			throw new IllegalArgumentException("연동 플랫폼 이름이 너무 깁니다! 마법서는 50자 이내로 써주세요.");

		recDao.setExerciseRecord(vo);
	}

	@Override
	public List<ExerciseRecordVo> getExerciseRecordList(int user_id) {
		return recDao.getExerciseRecordList(user_id);
	}

	
	@Override
	public void updateExerciseRecord(ExerciseRecordVo vo) {
	    if (vo.getRecord_id() <= 0)
	        throw new IllegalArgumentException("수정할 기록이 명확하지 않아요!");

	    if (vo.getDuration_minutes() <= 0)
	        throw new IllegalArgumentException("운동 시간은 최소 1분 이상이어야 해요!");

	    if (vo.getCalories_burned() < 0)
	        throw new IllegalArgumentException("소모 칼로리는 0 이상이어야 해요!");

	    if (vo.getActivity_date() == null || vo.getActivity_date().after(new Date()))
	        throw new IllegalArgumentException("미래의 날짜는 사용할 수 없어요!");

	    if (vo.getSource_platform() != null && vo.getSource_platform().length() > 50)
	        throw new IllegalArgumentException("연동 플랫폼 이름이 너무 깁니다. 50자 이내로 입력해주세요!");

	    int result = recDao.updateExerciseRecord(vo);
	    if (result == 0) {
	        throw new IllegalArgumentException("해당 기록이 존재하지 않거나 수정 권한이 없습니다.");
	    }
	}


	@Override
	public ExerciseRecordVo getExerciseRecordById(int record_id, int user_id) {
		return recDao.getExerciseRecordById(record_id, user_id);
	}
	
	@Override
	public void deleteExerciseRecord(int record_id, int user_id) {
	    if (record_id <= 0) throw new IllegalArgumentException("마법 시전 중 이상이 발생!");
	    int result = recDao.deleteExerciseRecord(record_id, user_id);
	    if (result == 0) throw new IllegalArgumentException("마법 주문이 어딘가 잘못됐어요!ㅠㅠ");
	}

	@Override
	@Transactional
	public void multiUpdateExerciseRecord(List<ExerciseRecordVo> exerciseRecordList ) {
	    if (exerciseRecordList  == null || exerciseRecordList .isEmpty()) {
	    	System.out.println("exerciseRecordList : " + exerciseRecordList);
	        throw new IllegalArgumentException("수정할 마법 기록이 아무것도 없어요! 먼저 마법진을 완성해볼까요?");
	    }

	    for (ExerciseRecordVo vo : exerciseRecordList ) {
	    	if (!"true".equalsIgnoreCase(vo.getChanged())) continue; // 수정 여부 판단
	    	
	        // 서버 유효성 검사
	        if (vo.getRecord_id() <= 0) {
	            throw new IllegalArgumentException("이 마법 기록의 정체가 흐릿해요… 다시 선택해볼까요?");
	        }

	        if (vo.getDuration_minutes() <= 0) {
	            throw new IllegalArgumentException("운동 시간이 1분 이상이어야 마법진이 작동해요!");
	        }

	        if (vo.getCalories_burned() < 0) {
	            throw new IllegalArgumentException("마법 에너지는 마이너스로 흘러갈 수 없어요! 다시 입력해주세요.");
	        }

	        if (vo.getActivity_date() == null || vo.getActivity_date().after(new Date())) {
	            throw new IllegalArgumentException("아직 오지 않은 시간에 마법을 쓸 수는 없어요. 날짜를 다시 설정해줘요!");
	        }

	        if (vo.getSource_platform() != null && vo.getSource_platform().length() > 50) {
	            throw new IllegalArgumentException("연동 플랫폼 이름이 50자 이내여야 합니다!");
	        }

	        // update 수행
	        int result = recDao.updateExerciseRecord(vo);
	        if (result == 0) {
	            throw new IllegalArgumentException("일부 마법 기록이 이미 사라졌거나, 당신의 힘으로는 수정할 수 없는 항목이 있어요. 다시 시도해보세요.");
	        }
	    }
	}


	@Override
	@Transactional
	public void multiDeleteExerciseRecord(HttpServletRequest request, int userId) {
	    List<Integer> recordIdList = new ArrayList<>();

	    int index = 0;
	    while (true) {
	        String param = request.getParameter("recordIdList[" + index + "]");
	        if (param == null) break;

	        try {
	            int recordId = Integer.parseInt(param);
	            recordIdList.add(recordId);
	        } catch (NumberFormatException e) {
	            throw new IllegalArgumentException("마법 ID가 숫자가 아닌 것이 섞여 있어요!");
	        }
	        index++;
	    }

	    if (recordIdList.isEmpty()) {
	        throw new IllegalArgumentException("삭제할 마법 기록이 선택되지 않았어요!");
	    }

	    for (Integer recordId : recordIdList) {
	        int result = recDao.deleteExerciseRecord(recordId, userId);
	        if (result == 0) {
	            throw new IllegalArgumentException("삭제할 수 없는 마법 기록이 존재해요!");
	        }
	    }
	}





}
