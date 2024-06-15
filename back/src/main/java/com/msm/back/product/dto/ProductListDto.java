package com.msm.back.product.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.msm.back.db.entity.Product;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@Getter
@Setter
public class ProductListDto {

	private Long id;
	private String name;

	@JsonProperty("img_url")
	private String imgUrl;
	private String linkUrl;
	private String brand;

	@JsonProperty("avg_rating")
	private double avgRating;

	@JsonProperty("cnt_rating")
	private int cntRating;
	private boolean isFavorite;
	private int price;
	private String capacity;

	@Builder
	public ProductListDto(Product product, boolean isFavorite) {
		this.id = product.getId();
		this.name = product.getName();
		this.imgUrl = product.getImgUrl();
		this.brand = product.getBrand();
		this.avgRating = Math.round(product.getAvgRating()*10)/10.0;
		this.cntRating = product.getCntRating();
		this.isFavorite = isFavorite;
		this.price = product.getPrice();
		this.capacity = product.getCapacity();
		this.linkUrl = product.getLinkUrl();
	}

	public ProductListDto(Long id, String name, String imgUrl, String brand, float avgRating, int cntRating,
		boolean isFavorite, int price, String capacity, String linkUrl) {
		this.id = id;
		this.name = name;
		this.imgUrl = imgUrl;
		this.brand = brand;
		this.avgRating = Math.round(avgRating*10)/10.0;
		this.cntRating = cntRating;
		this.isFavorite = isFavorite;
		this.price = price;
		this.capacity = capacity;
		this.linkUrl = linkUrl;
	}
}
