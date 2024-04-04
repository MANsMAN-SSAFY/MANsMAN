package com.msm.back.recommend.dto;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RecommendResponseDto {
    private Long id; // 상품 id
    private String name;
    private String brand;
    private int price;
    private String capacity;
    private String img_url;
    private double avg_rating;
    private int cnt_rating;
    private boolean favorite;

    public void updateFavorite(boolean favorite) {
           this.favorite = favorite;
    }
}
