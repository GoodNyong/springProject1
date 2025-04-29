package com.spring.springProject1.board;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class BoardCommentVo {
  private int comment_id;
  private int board_id;
  private int user_id;
  private String username;
  private String content;
  private String host_ip;
  private int like_count;
  private LocalDateTime created_at;
  private LocalDateTime updated_at;
  private LocalDateTime deleted_at;
  private int is_deleted;
}
