package com.spring.springProject1.board;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class BoardReportVo {
	private int report_id;
	private String part;
	private int board_id;
	private int comment_id;
	private int reply_id;
	private int reporter_id;
	private String reason;
	private String status;
	private LocalDateTime created_at;
}
