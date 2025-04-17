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