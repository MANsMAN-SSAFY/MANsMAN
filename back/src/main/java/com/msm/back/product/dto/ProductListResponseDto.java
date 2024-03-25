package com.msm.back.product.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ProductListResponseDto {

	private Long id;
	private String name;
	private String imgUrl;
	private String brand;
	private String cat1;
	private String cat2;
	private String cat3;
	private int avgRating;
	private boolean isFavorite;
	private int price;
	private String capacity;
}
