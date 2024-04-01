package com.msm.back.myProduct.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

@Getter
@NoArgsConstructor
@RequiredArgsConstructor
public class MyProductRequestDto {
    private Long memberId;
    private Long productId;
    private int cnt;
    private double rating;
    private String review;
    private boolean isActive;
}
