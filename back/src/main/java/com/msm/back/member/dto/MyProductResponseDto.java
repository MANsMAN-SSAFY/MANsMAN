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
    private Long id;
    private String name;
    private String imgUrl;
    private String brand;
    private String category;
    private Integer price;

    private int cnt;
    private double rating;
    private String review;
}
