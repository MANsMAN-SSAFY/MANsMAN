package com.msm.back.myProduct.dto;

import lombok.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MyProductResponseDto {
    private Long memberId;
    private Long productId;
    private int cnt;
    private double rating;
    private String review;
    private boolean isActive;
}