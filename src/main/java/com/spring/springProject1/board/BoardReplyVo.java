package com.spring.springProject1.board;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class BoardReplyVo {
  private int reply_id;
  private int comment_id;
  private int user_id;
  private String username;
  private String content;
  private int is_deleted;
  private String host_ip;
  private LocalDateTime created_at;
  private LocalDateTime updated_at;
  private LocalDateTime deleted_at;
}
