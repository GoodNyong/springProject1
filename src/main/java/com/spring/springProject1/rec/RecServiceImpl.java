package com.spring.springProject1.rec;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
		// 기본 검증 로직 (입력과 거의 동일)
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

		recDao.updateExerciseRecord(vo);
	}

	@Override
	public ExerciseRecordVo getExerciseRecordById(int record_id, int user_id) {
		return recDao.getExerciseRecordById(record_id, user_id);
	}
	
	@Override
	public void deleteExerciseRecord(int record_id, int user_id) {
	    if (record_id <= 0) throw new IllegalArgumentException("잘못된 요청입니다.");
	    int result = recDao.deleteExerciseRecord(record_id, user_id);
	    if (result == 0) throw new IllegalArgumentException("삭제할 기록이 존재하지 않거나 권한이 없습니다.");
	}



}
