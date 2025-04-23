package com.spring.springProject1.rec;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.springProject1.common.ExerciseGoalVo;
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
		if (record_id <= 0)
			throw new IllegalArgumentException("마법 시전 중 이상이 발생!");
		int result = recDao.deleteExerciseRecord(record_id, user_id);
		if (result == 0)
			throw new IllegalArgumentException("마법 주문이 어딘가 잘못됐어요!ㅠㅠ");
	}

	@Override
	@Transactional
	public void multiUpdateExerciseRecord(List<ExerciseRecordVo> exerciseRecordList) {
		if (exerciseRecordList == null || exerciseRecordList.isEmpty()) {
			System.out.println("exerciseRecordList : " + exerciseRecordList);
			throw new IllegalArgumentException("수정할 마법 기록이 아무것도 없어요! 먼저 마법진을 완성해볼까요?");
		}

		for (ExerciseRecordVo vo : exerciseRecordList) {
			if (!"true".equalsIgnoreCase(vo.getChanged()))
				continue; // 수정 여부 판단

			// 서버 유효성 검사
			if (vo.getRecord_id() <= 0)
				throw new IllegalArgumentException("이 마법 기록의 정체가 흐릿해요… 다시 선택해볼까요?");

			if (vo.getDuration_minutes() <= 0)
				throw new IllegalArgumentException("운동 시간이 1분 이상이어야 마법진이 작동해요!");

			if (vo.getCalories_burned() < 0)
				throw new IllegalArgumentException("마법 에너지는 마이너스로 흘러갈 수 없어요! 다시 입력해주세요.");

			if (vo.getActivity_date() == null || vo.getActivity_date().after(new Date()))
				throw new IllegalArgumentException("아직 오지 않은 시간에 마법을 쓸 수는 없어요. 날짜를 다시 설정해줘요!");

			if (vo.getSource_platform() != null && vo.getSource_platform().length() > 50)
				throw new IllegalArgumentException("연동 플랫폼 이름이 50자 이내여야 합니다!");

			// update 수행
			int result = recDao.updateExerciseRecord(vo);
			if (result == 0)
				throw new IllegalArgumentException("일부 마법 기록이 이미 사라졌거나, 당신의 힘으로는 수정할 수 없는 항목이 있어요. 다시 시도해보세요.");
		}

	}

	@Override
	@Transactional
	public void multiDeleteExerciseRecord(HttpServletRequest request, int userId) {
		List<Integer> recordIdList = new ArrayList<>();

		int index = 0;
		while (true) {
			String param = request.getParameter("recordIdList[" + index + "]");
			if (param == null)
				break;

			try {
				int recordId = Integer.parseInt(param);
				recordIdList.add(recordId);
			} catch (NumberFormatException e) {
				throw new IllegalArgumentException("마법 ID가 숫자가 아닌 것이 섞여 있어요!");
			}
			index++;
		}

		if (recordIdList.isEmpty())
			throw new IllegalArgumentException("삭제할 마법 기록이 선택되지 않았어요!");

		for (Integer recordId : recordIdList) {
			int result = recDao.deleteExerciseRecord(recordId, userId);
			if (result == 0)
				throw new IllegalArgumentException("삭제할 수 없는 마법 기록이 존재해요!");

		}
	}

	@Override
	@Transactional
	public void multiSetExerciseRecord(List<ExerciseRecordVo> exerciseRecordList) {
		if (exerciseRecordList == null || exerciseRecordList.isEmpty())
			throw new IllegalArgumentException("입력할 마법 기록이 없어요! 마법서를 펼쳐주세요.");

		for (ExerciseRecordVo vo : exerciseRecordList) {
			// 필수 검증 로직
			if (vo.getExercise_id() <= 0)
				throw new IllegalArgumentException("운동 종류가 선택되지 않았어요!");
			if (vo.getDuration_minutes() <= 0)
				throw new IllegalArgumentException("운동 시간은 1분 이상이어야 해요!");
			if (vo.getCalories_burned() < 0)
				throw new IllegalArgumentException("칼로리는 음수가 될 수 없어요!");
			if (vo.getActivity_date() == null || vo.getActivity_date().after(new Date()))
				throw new IllegalArgumentException("미래 날짜는 쓸 수 없어요!");
			if (vo.getSource_platform() != null && vo.getSource_platform().length() > 50)
				throw new IllegalArgumentException("플랫폼 이름이 너무 길어요!");

			recDao.setExerciseRecord(vo); // 반복 insert
		}
	}

	@Override
	@Transactional
	public void setMealRecord(MealRecordVo vo) {
		if (vo.getUser_id() <= 0)
			throw new IllegalArgumentException("누구의 마법 식사인지 모르겠어요! 마법사를 지정해 주세요.");

		if (vo.getFood_id() <= 0)
			throw new IllegalArgumentException("음식을 선택하지 않았어요! 마법 요리를 골라주세요.");

		if (vo.getMeal_time() <= 0 || vo.getMeal_time() > 4)
			throw new IllegalArgumentException("마법의 시간대가 이상해요. 아침, 점심, 저녁, 간식 중에서 골라주세요!");

		if (vo.getMeal_date() == null || vo.getMeal_date().after(new Date()))
			throw new IllegalArgumentException("미래의 식사는 아직 준비되지 않았어요. 오늘 또는 과거 날짜로 다시 시도해요!");

		if (vo.getQuantity() == null || vo.getQuantity().trim().isEmpty())
			throw new IllegalArgumentException("섭취량이 입력되지 않았어요! 마법 식사의 양은 중요하답니다.");

		if (vo.getQuantity().length() > 20)
			throw new IllegalArgumentException("섭취량 정보가 너무 길어요! 20자 이내로 써주세요.");

		recDao.setMealRecord(vo);
	}

	@Override
	public List<MealRecordVo> getMealRecordList(int user_id) {
		return recDao.getMealRecordList(user_id);
	}

	@Override
	@Transactional
	public void multiSetMealRecord(List<MealRecordVo> mealRecordList) {
		if (mealRecordList == null || mealRecordList.isEmpty())
			throw new IllegalArgumentException("기록할 마법 식단이 아무것도 없어요! 마법식을 준비해주세요.");

		for (MealRecordVo vo : mealRecordList) {
			// 식단 유효성 검사
			if (vo.getUser_id() <= 0)
				throw new IllegalArgumentException("누구의 식단인지 알 수 없어요. 마법사가 필요해요!");

			if (vo.getFood_id() <= 0)
				throw new IllegalArgumentException("음식이 선택되지 않았어요. 마법 요리를 골라주세요!");

			if (vo.getMeal_time() <= 0 || vo.getMeal_time() > 4)
				throw new IllegalArgumentException("식사 시간대를 다시 확인해 주세요! 아침, 점심, 저녁, 간식 중에서 골라야 해요.");

			if (vo.getMeal_date() == null || vo.getMeal_date().after(new Date()))
				throw new IllegalArgumentException("미래의 식사는 아직 못 먹어요! 날짜를 다시 선택해주세요.");

			if (vo.getQuantity() == null || vo.getQuantity().trim().isEmpty())
				throw new IllegalArgumentException("섭취량을 입력해주세요! 마법 식사의 양이 중요하답니다.");

			if (vo.getQuantity().length() > 20)
				throw new IllegalArgumentException("섭취량 정보가 너무 길어요! 20자 이내로 적어주세요.");

			// 저장
			recDao.setMealRecord(vo);
		}
	}

	@Override
	public MealRecordVo getMealRecordById(int mealId, int userId) {
		return recDao.getMealRecordById(mealId, userId);
	}

	@Override
	public void updateMealRecord(MealRecordVo vo) {
		if (vo.getMeal_id() <= 0)
			throw new IllegalArgumentException("수정할 식단 기록이 명확하지 않아요!");

		if (vo.getUser_id() <= 0)
			throw new IllegalArgumentException("누구의 식단인지 알 수 없어요! 마법사가 필요해요.");

		if (vo.getFood_id() <= 0)
			throw new IllegalArgumentException("음식이 선택되지 않았어요. 마법 요리를 골라주세요!");

		if (vo.getMeal_time() <= 0 || vo.getMeal_time() > 4)
			throw new IllegalArgumentException("식사 시간대를 다시 확인해 주세요!");

		if (vo.getMeal_date() == null || vo.getMeal_date().after(new Date()))
			throw new IllegalArgumentException("미래의 식사는 아직 못 먹어요! 날짜를 다시 선택해주세요.");

		if (vo.getQuantity() == null || vo.getQuantity().trim().isEmpty())
			throw new IllegalArgumentException("섭취량을 입력해주세요! 마법 식사의 양이 중요하답니다.");

		if (vo.getQuantity().length() > 20)
			throw new IllegalArgumentException("섭취량 정보가 너무 길어요! 20자 이내로 적어주세요.");

		int result = recDao.updateMealRecord(vo);
		if (result == 0)
			throw new IllegalArgumentException("해당 식단 기록이 존재하지 않거나 수정 권한이 없어요.");

	}

	@Override
	public void deleteMealRecord(int mealId, int userId) {
		if (mealId <= 0)
			throw new IllegalArgumentException("삭제할 마법 식단이 명확하지 않아요!");

		int result = recDao.deleteMealRecord(mealId, userId);
		if (result == 0)
			throw new IllegalArgumentException("해당 식단을 삭제할 수 없어요! 이미 사라졌거나 권한이 없어요.");

	}

	@Override
	@Transactional
	public void multiUpdateMealRecord(List<MealRecordVo> mealRecordList) {
		if (mealRecordList == null || mealRecordList.isEmpty())
			throw new IllegalArgumentException("수정할 마법 식단이 아무것도 없어요! 먼저 마법서를 펼쳐주세요.");

		for (MealRecordVo vo : mealRecordList) {
			if (!"true".equalsIgnoreCase(vo.getChanged()))
				continue;

			if (vo.getMeal_id() <= 0 || vo.getUser_id() <= 0)
				throw new IllegalArgumentException("이 마법 식사의 정체가 불분명해요! 기록 ID와 마법사를 다시 확인해 주세요.");

			if (vo.getFood_id() <= 0)
				throw new IllegalArgumentException("음식을 선택하지 않았어요! 마법 요리를 지정해 주세요.");

			if (vo.getMeal_time() < 1 || vo.getMeal_time() > 4)
				throw new IllegalArgumentException("식사 시간대가 잘못되었어요! 아침, 점심, 저녁, 간식 중에서 골라주세요.");

			if (vo.getMeal_date() == null || vo.getMeal_date().after(new Date()))
				throw new IllegalArgumentException("미래의 식사는 아직 준비되지 않았어요. 오늘 또는 과거로 돌아가 주세요!");

			if (vo.getQuantity() == null || vo.getQuantity().trim().isEmpty())
				throw new IllegalArgumentException("마법 식사의 양이 빠졌어요! 섭취량은 꼭 적어주세요.");

			if (vo.getQuantity().length() > 20)
				throw new IllegalArgumentException("섭취량 정보가 너무 길어요! 20자 이내로 마법을 간결하게 유지해 주세요.");

			int result = recDao.updateMealRecord(vo);
			if (result == 0) {
				throw new IllegalArgumentException("일부 마법 식사는 이미 사라졌거나, 당신의 마력으로는 수정할 수 없어요!");
			}
		}
	}

	@Override
	@Transactional
	public void multiDeleteMealRecord(HttpServletRequest request, int userId) {
		List<Integer> recordIdList = new ArrayList<>();
		int index = 0;

		while (true) {
			String param = request.getParameter("recordIdList[" + index + "]");
			if (param == null)
				break;

			try {
				int id = Integer.parseInt(param);
				recordIdList.add(id);
			} catch (NumberFormatException e) {
				throw new IllegalArgumentException("마법 식사 ID에 이상한 문자가 섞여 있어요! 숫자만 허용됩니다.");
			}
			index++;
		}

		if (recordIdList.isEmpty())
			throw new IllegalArgumentException("삭제할 마법 식단이 선택되지 않았어요!");

		int result = recDao.multiDeleteMealRecord(recordIdList, userId);
		if (result == 0)
			throw new IllegalArgumentException("삭제할 수 있는 마법 식단이 없어요! 다시 확인해 주세요.");

	}

	@Override
	public void setExerciseGoal(ExerciseGoalVo vo) {
		// 필수값 유효성 검사
		if (vo.getUser_id() <= 0 || vo.getExercise_id() <= 0)
			throw new IllegalArgumentException("마법 루틴을 기록할 대상이 누락됐어요! 사용자와 운동 종류를 정확히 선택해 주세요.");

		if (vo.getTarget_value() <= 0)
			throw new IllegalArgumentException("마법 목표 수치는 0보다 커야 해요! 작더라도 의지를 담아보세요.");

		if (vo.getStart_date() == null || vo.getEnd_date() == null)
			throw new IllegalArgumentException("마법 루틴의 시작과 끝이 정해지지 않았어요! 날짜를 반드시 지정해 주세요.");

		if (vo.getEnd_date().before(vo.getStart_date()))
			throw new IllegalArgumentException("시간 마법은 역행할 수 없어요! 종료일은 시작일보다 뒤에 있어야 해요.");

		if (vo.getGoal_unit() == 0 || vo.getTarget_type() == 0)
			throw new IllegalArgumentException("마법의 기준과 단위를 선택해 주세요! 그래야 루틴이 완성돼요.");

		recDao.insertExerciseGoal(vo);
	}

	@Override
	public List<ExerciseGoalVo> getExerciseGoalList(int user_id) {
		List<ExerciseGoalVo> list = recDao.getExerciseGoalList(user_id);

		// 단위 라벨 변환
		for (ExerciseGoalVo vo : list) {
			String label = "단위없음";
			switch (vo.getGoal_unit()) {
				case 1:
					label = "분";
					break;
				case 2:
					label = "시간";
					break;
				case 11:
					label = "kcal";
					break;
				case 12:
					label = "J";
					break;
				case 21:
					label = "회";
					break;
				case 22:
					label = "세트";
					break;
			}
			vo.setGoal_unit_label(label);
		}
		return list;
	}

	@Override
	public ExerciseGoalVo getExerciseGoalById(int goal_id, int user_id) {
		return recDao.getExerciseGoalById(goal_id, user_id);
	}

	@Override
	public void updateExerciseGoal(ExerciseGoalVo vo) {
		if (vo.getUser_id() <= 0 || vo.getGoal_id() <= 0)
			throw new IllegalArgumentException("마법 목표를 불러올 수 없어요! 사용자 정보를 다시 확인해주세요.");

		if (vo.getExercise_id() <= 0)
			throw new IllegalArgumentException("운동 종류를 선택해주세요!");

		if (vo.getTarget_value() <= 0)
			throw new IllegalArgumentException("목표 수치는 0보다 커야 해요!");

		if (vo.getStart_date() == null || vo.getEnd_date() == null)
			throw new IllegalArgumentException("마법 기간을 모두 입력해주세요!");

		if (vo.getEnd_date().before(vo.getStart_date()))
			throw new IllegalArgumentException("종료일은 시작일보다 늦어야 해요!");

		if (vo.getGoal_unit() == 0 || vo.getTarget_type() == 0)
			throw new IllegalArgumentException("목표 기준과 단위를 선택해주세요!");

		int result = recDao.updateExerciseGoal(vo);
		if (result == 0)
			throw new IllegalArgumentException("이 마법 목표는 이미 사라졌거나 수정할 수 없어요!");

	}
	
	@Override
	public void deleteExerciseGoal(int goal_id, int user_id) {
		if (goal_id <= 0) throw new IllegalArgumentException("마법 목표 ID가 유효하지 않아요!");
		int result = recDao.deleteExerciseGoal(goal_id, user_id);
		if (result == 0) throw new IllegalArgumentException("삭제할 수 없는 마법 목표입니다.");
	}



}
