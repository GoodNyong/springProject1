desc board;

CREATE TABLE boardlike (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    board_id INT NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_like (board_id, user_id),
    FOREIGN KEY (board_id) REFERENCES board(board_id)
);

ALTER TABLE board
  DROP COLUMN open_sw,
  DROP COLUMN complaint_sw,
  ADD is_open TINYINT(1) NOT NULL DEFAULT 1 AFTER host_ip,
  ADD is_reported TINYINT(1) NOT NULL DEFAULT 0 AFTER comment_count,
  ADD is_deleted TINYINT(1) NOT NULL DEFAULT 0 AFTER is_notice;
--  MODIFY is_notice TINYINT(1) NOT NULL DEFAULT 0;

select * from board;
select * from boardreply;
select * from boardcomment;
select * from BoardViewLog;

SHOW CREATE TABLE BoardViewLog;
 
INSERT INTO board (user_id, username, category, title, content, host_ip, is_open, read_count, like_count, comment_count, is_reported, is_notice, is_deleted, created_at) VALUES
(11, 'hong', 'free', '첫 번째 게시글입니다', '이건 테스트 게시글 내용입니다.', '127.0.0.1', 1, 3, 1, 0, 0, 0, 0, NOW()),
(12, 'kim', 'free', '두 번째 게시글', '내용은 아무거나', '127.0.0.1', 1, 10, 0, 1, 0, 0, 0, NOW() - INTERVAL 1 DAY),
(13, 'park', 'exercise', '운동 추천 부탁드립니다', '오늘 헬스장 추천 좀', '127.0.0.1', 1, 5, 2, 0, 0, 0, 0, NOW() - INTERVAL 2 DAY),
(14, 'choi', 'meal', '식단 공유해요', '저녁 식단 이렇게 짜요', '127.0.0.1', 1, 2, 1, 0, 0, 0, 0, NOW() - INTERVAL 3 DAY),
(15, 'lee', 'free', '다섯 번째 테스트', '내용 없음', '127.0.0.1', 1, 0, 0, 0, 0, 0, 0, NOW()),
(16, 'yoon', 'exercise', '하체 루틴 공유 좀요', '진짜 힘들어요', '127.0.0.1', 1, 7, 2, 3, 0, 0, 0, NOW() - INTERVAL 5 DAY),
(17, 'kang', 'meal', '점심 뭐 드셨어요?', '저는 고구마요', '127.0.0.1', 1, 11, 3, 1, 0, 0, 0, NOW() - INTERVAL 4 DAY),
(18, 'jang', 'free', '자유롭게 글 씁니다', '뭐라도 적기', '127.0.0.1', 1, 4, 0, 0, 0, 0, 0, NOW()),
(19, 'moon', 'free', '오전 출석합니다', '좋은 하루 되세요', '127.0.0.1', 1, 6, 1, 0, 0, 0, 0, NOW() - INTERVAL 1 HOUR),
(12, 'kim', 'exercise', 'PT 어디서 받으세요?', '헬린이입니다', '127.0.0.1', 1, 5, 1, 2, 0, 0, 0, NOW() - INTERVAL 10 HOUR),
(11, 'hong', 'meal', '간식으로 뭐 드세요?', '저는 아몬드요', '127.0.0.1', 1, 3, 0, 0, 0, 0, 0, NOW() - INTERVAL 6 HOUR),
(15, 'lee', 'free', '열두 번째 제목', '복붙 테스트', '127.0.0.1', 1, 1, 0, 0, 0, 0, 0, NOW()),
(13, 'park', 'meal', '야식 뭐 먹지?', '매운 떡볶이?', '127.0.0.1', 1, 9, 2, 1, 0, 0, 0, NOW() - INTERVAL 1 DAY),
(14, 'choi', 'exercise', '운동 루틴 정리해봄', '하루 3부위 분할', '127.0.0.1', 1, 2, 1, 0, 0, 0, 0, NOW()),
(17, 'kang', 'free', '마지막 테스트 글', '이걸로 15개 채움', '127.0.0.1', 1, 0, 0, 0, 0, 0, 0, NOW());

INSERT INTO BoardComment (board_id, user_id, username, content, created_at) VALUES
(16, 12, 'kim', '새 글 잘 봤습니다.', NOW()),
(16, 13, 'park', '이 게시물 좋네요!', NOW() - INTERVAL 10 MINUTE),
(18, 15, 'lee', '운동 루틴 참고할게요.', NOW() - INTERVAL 1 HOUR),
(18, 13, 'park', '운동 오늘도 했습니다.', NOW() - INTERVAL 2 HOUR),
(20, 12, 'kim', '하체 루틴은 힘들죠', NOW() - INTERVAL 4 HOUR),
(20, 16, 'yoon', '공감합니다.', NOW() - INTERVAL 1 DAY),
(24, 11, 'hong', 'PT에 도움 됐어요!', NOW() - INTERVAL 3 HOUR),
(27, 15, 'lee', '떡볶이 좋아요.', NOW() - INTERVAL 20 MINUTE),
(27, 18, 'jang', '이 조합 찬성합니다 ㅋㅋ', NOW()),
(30, 17, 'kang', '좋은 루틴입니다.', NOW());

ALTER TABLE boardcomment
ADD COLUMN is_deleted TINYINT(1) NOT NULL DEFAULT 0 AFTER content;

ALTER TABLE boardreply
ADD COLUMN is_deleted TINYINT(1) NOT NULL DEFAULT 0 AFTER content;

ALTER TABLE boardreport
ADD COLUMN part VARCHAR(20) NOT NULL AFTER report_id;

ALTER TABLE BoardViewLog
DROP FOREIGN KEY boardviewlog_ibfk_2;

ALTER TABLE BoardViewLog
CHANGE COLUMN viewer_id user_id VARCHAR(50) NOT NULL;





