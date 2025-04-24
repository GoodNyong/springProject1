package com.spring.springProject1.common;

import lombok.Data;

@Data
public class PageVo {
    private int pag;                // 현재 페이지 번호
    private int pageSize;           // 한 페이지 당 글 개수
    private int totRecCnt;          // 총 레코드 수
    private int totPage;            // 총 페이지 수
    private int startIndexNo;       // DB에서 사용할 시작 인덱스 번호
    private int curScrStartNo;      // 화면에 출력할 글번호
    private int blockSize;          // 블록 개수 (한 번에 보여줄 페이지 수)
    private int curBlock;           // 현재 페이지 블록
    private int lastBlock;          // 마지막 페이지 블록

    // 🔍 검색 관련 필드
//    private String part;            // 검색 필드 (ex: title, content, username 등)
//    private String searchString;    // 검색어
//    private String search;          // 내부 검색 키워드
//    private String searchStr;       // 사용자에게 보여줄 검색 타입 (ex: "제목", "내용")
}