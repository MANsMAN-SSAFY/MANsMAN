package com.msm.back.comment.dto;


import com.msm.back.member.dto.ProfileResponseDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CommentDto {
    private Long id;
    private String content;
    private ProfileResponseDto writer;
    private Long likeCnt;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}