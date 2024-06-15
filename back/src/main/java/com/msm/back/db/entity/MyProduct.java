package com.msm.back.db.entity;

import com.msm.back.common.BaseEntity;
import com.msm.back.myProduct.dto.MyProductResponseDto;
import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MyProduct extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    private int cnt;

    private double rating;

    private String review;

    private boolean isActive;

    public MyProductResponseDto toMyProductResponseDto() {
        return MyProductResponseDto.builder().
                id(id).
                memberId(member.getId()).
                productId(product.getId()).
                cnt(cnt).
                rating(rating)
                .review(review)
                .isActive(isActive)
                .build();

    }
}
