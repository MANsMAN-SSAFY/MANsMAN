package com.msm.back.myProduct.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class MyProductRequestDto {
    private Long memberId;
    private Long productId;
    private int cnt;
    private double rating;
    private String review;
    private boolean isActive;
}
