desc board;

ALTER TABLE board
  DROP COLUMN open_sw,
  DROP COLUMN complaint_sw,
  ADD is_open TINYINT(1) NOT NULL DEFAULT 1 AFTER host_ip,
  ADD is_reported TINYINT(1) NOT NULL DEFAULT 0 AFTER comment_count,
  ADD is_deleted TINYINT(1) NOT NULL DEFAULT 0 AFTER is_notice;
--  MODIFY is_notice TINYINT(1) NOT NULL DEFAULT 0;