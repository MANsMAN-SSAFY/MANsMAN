package com.msm.back.db.entity;

import com.msm.back.recommend.dto.RecommendResponseDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Product {

    @Id
    private Long id;

    @ManyToOne
    @JoinColumn(name="category_code")
    private CommonCode category;

    @Column(name="avg_rating")
    @ColumnDefault("0.0")
    private Double avgRating;

    @Column(name = "cnt_rating")
    @ColumnDefault("0")
    private Integer cntRating;

    private String goodsNo;

    private String name;

    private String imgUrl;

    private String brand;

    private Integer price;

    private String capacity;

    private String mainPoint;

    private String useDate;
    @Column(columnDefinition = "text")
    private String howUse;

    @Column(columnDefinition = "text")
    private String material;

    @Column(columnDefinition = "text")
    private String linkUrl;

    private Integer skinTypeDry;

    private Integer skinTypeCombination;

    private Integer skinTypeOily;

    private Integer skinConcernsMoisturizing;

    private Integer skinConcernsSoothing;

    private Integer skinConcernsWrinkleWhitening;

    private Integer stimulationMild;

    private Integer stimulationCommon;

    private Integer stimulationHard;

    private Boolean isQuasiDrug;

    @OneToMany(mappedBy = "product")
    @OrderColumn(name="imgSeq")
    @Builder.Default
    private List<ProductImage> imgList = new ArrayList<>();

    public void evaluate(double oldRating, double newRating) {
        if (oldRating == 0.0) {
            if (cntRating == 0) {
                this.avgRating = newRating;
            } else {
                this.avgRating = ((avgRating * cntRating) + newRating) / (cntRating + 1);
            }
            this.cntRating++;
        } else {
            if (cntRating > 1) {
                this.avgRating = ((avgRating * cntRating) - oldRating + newRating) / cntRating;
            } else {
                this.avgRating = newRating; // cntRating이 1일 때 이전 평점을 새 평점으로 대체
            }
        }
    }

    public void cancleEvaluate(double rating) {
        if (cntRating > 1) {
            this.avgRating = ((avgRating * cntRating) - rating) / (cntRating - 1);
            this.cntRating--;
        } else {
            // 마지막 평점을 취소할 때는 avgRating을 0으로 초기화
            this.avgRating = 0.0;
            this.cntRating = 0;
        }
    }

    public RecommendResponseDto toRecommendResponseDto() {
        return RecommendResponseDto.builder()
                .id(id)
                .name(name)
                .brand(brand)
                .price(price)
                .capacity(capacity)
                .img_url(imgUrl)
                .avg_rating(avgRating)
                .cnt_rating(cntRating)
                .build();
    }



}
