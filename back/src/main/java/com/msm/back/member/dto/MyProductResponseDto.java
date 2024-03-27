package com.msm.back.member.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MyProductResponseDto {
    private Long memberId;
    private Long productId;
    private int cnt;
    private double rating;
    private String review;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}