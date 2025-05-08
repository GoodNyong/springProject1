show tables;

create table UserBehaviorLog (
	behavior_id		int			not null auto_increment,	/* 1. 고유번호 */
	user_id			int,									/* 2. 유저아이디 */
	content_id		int,									/* 3. 콘텐츠아이디 */
	event_type		int,									/* 4. 행동유형 코드(예시), 1:조회, 2:완독(스크롤), 3:좋아요, 4:운동 */
	occurred_at		datetime	default now(),				/* 5. 발생시각 */
	primary key (behavior_id)
);

desc UserBehaviorLog;

insert into UserBehaviorLog values (default, 1, 1, 1, default);

select * from UserBehaviorLog;


-- Users 테이블
INSERT INTO Users (user_id, username, email, password, is_verified, created_at, updated_at, is_premium)
VALUES (1, '테스트유저', 'test@example.com', 'encrypted', true, NOW(), NOW(), false);

select * from users;

-- ExerciseInfo 테이블
INSERT INTO ExerciseInfo (exercise_id, name, category, met_value)
VALUES (1, '걷기', '유산소', 3.5),
       (2, '러닝', '유산소', 8.0),
       (3, '사이클링', '유산소', 6.0),
       (4, '근력 운동', '무산소', 5.0);

select * form ExerciseInfo;

-- 운동 목표: 사용자 1이 직접 설정한 목표
INSERT INTO ExerciseGoal (user_id, exercise_id, set_by, expert_id, target_value, target_type, goal_unit, start_date, end_date)
VALUES
-- 1번 걷기: 300분 (7일간)
(1, 1, 1, NULL, 300, 1, 01, '2025-04-25', '2025-05-01'),
-- 2번 러닝: 800kcal (7일간)
(1, 2, 1, NULL, 800, 2, 11, '2025-04-25', '2025-05-01'),
-- 3번 사이클링: 180분
(1, 3, 1, NULL, 180, 1, 01, '2025-04-25', '2025-05-01');

-- 걷기 기록: 총 240분 (80% 달성)
INSERT INTO ExerciseRecord (user_id, exercise_id, duration_minutes, calories_burned, activity_date)
VALUES
(1, 1, 60, 200, '2025-04-25'),
(1, 1, 90, 300, '2025-04-27'),
(1, 1, 90, 280, '2025-04-30');

-- 러닝 기록: 총 950kcal (119% 달성)
INSERT INTO ExerciseRecord (user_id, exercise_id, duration_minutes, calories_burned, activity_date)
VALUES
(1, 2, 30, 300, '2025-04-25'),
(1, 2, 45, 400, '2025-04-28'),
(1, 2, 30, 250, '2025-04-30');

-- 사이클링 기록: 총 90분 (50% 달성)
INSERT INTO ExerciseRecord (user_id, exercise_id, duration_minutes, calories_burned, activity_date)
VALUES
(1, 3, 30, 150, '2025-04-26'),
(1, 3, 30, 150, '2025-04-28'),
(1, 3, 30, 140, '2025-04-30');

