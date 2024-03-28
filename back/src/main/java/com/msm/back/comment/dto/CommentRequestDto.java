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
public class CommentRequestDto {
    private Long boardId;
    private String content;
}