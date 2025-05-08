package com.spring.springProject1.board;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class BoardViewLogVo {
  private int view_id;
  private int board_id;
  private int user_id;
  private String viewer_ip;
  private LocalDateTime viewed_at;
}
