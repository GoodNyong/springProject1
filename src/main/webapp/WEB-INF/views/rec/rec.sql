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
