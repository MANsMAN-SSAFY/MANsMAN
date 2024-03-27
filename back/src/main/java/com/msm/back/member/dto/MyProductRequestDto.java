package com.msm.back.member.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MyProductRequestDto {
    private Long productId;
    private int cnt;
    private double rating;
    private String review;
}