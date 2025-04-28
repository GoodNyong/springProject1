package com.spring.springProject1.board;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardFileVo {
    private int file_id;              // 파일 고유 ID
    private int board_id;         // 게시글 ID (null 허용)
    private String file_name;         // 원본 파일명
    private String file_url;          // 저장 경로 또는 URL
    private int file_size;            // 파일 크기 (bytes)
    private String file_type;         // MIME 타입 (예: image/png)
    private LocalDateTime created_at; // 업로드 시각
}