package com.spring.springProject1.board;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardVo {
  private int board_id;              // 게시글 고유 ID (PK)
  private int user_id;               // 작성자 회원번호 (FK)
  private String username;           // 작성자 이름 (nickname → username 통일)
  private String category;           // 게시글 분류
  private String title;              // 제목
  private String content;            // 내용
  private String host_ip;            // 작성자 IP 주소
  private String is_open;            // 공개 여부
  private int read_count;            // 조회수
  private int like_count;            // 좋아요 수
  private int comment_count;         // 댓글 수
  private String is_reported;        // 신고 여부
  private boolean is_notice;         // 공지글 여부
  private int is_deleted;						 // 삭제 여부
  private LocalDateTime created_at;  // 작성일시
  private LocalDateTime updated_at;  // 수정일시
  private LocalDateTime deleted_at;  // 삭제일시
  
  private String formattedTime; //출력용 시간
}
