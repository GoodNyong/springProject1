package com.spring.springProject1.board;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class BoardLikeVo {
    private int like_id;
    private int board_id;
    private int user_id;
    private LocalDateTime liked_at;
}
