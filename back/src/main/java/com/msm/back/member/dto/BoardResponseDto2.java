package com.msm.back.member.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardResponseDto2 {
    private Long id;
    private String title;
    private String content;
    private Long viewCnt;
    private Long commentCnt;
    private Long likeCnt;
    private ProfileResponseDto writer; // 게시글 작성자 정보
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}