package com.msm.back.product.dto;

import java.util.List;

import com.msm.back.db.entity.Product;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ProductDetailResponseDto {
	private Long id;
	private String name;
	private String imgUrl;
	private int price;
	private double avgRating;
	private int cntRating;
	private String capacity;
	private String mainPoint;
	private String useDate;
	private String material;
	private String linkUrl;
	private boolean isFavorite;
	private List<String> imgList;

	@Builder
	public ProductDetailResponseDto(Product product, boolean isFavorite, List<String> imgList) {
		this.id = product.getId();
		this.name = product.getName();
		this.imgUrl = product.getImgUrl();
		this.price = product.getPrice();
		this.avgRating = Math.round(product.getAvgRating()*10)/10.0;
		this.cntRating = product.getCntRating();
		this.capacity = product.getCapacity();
		this.mainPoint = product.getMainPoint();
		this.linkUrl = product.getLinkUrl();
		this.useDate = product.getUseDate();
		this.material = product.getMaterial();
		this.isFavorite = isFavorite;
		this.imgList = imgList;
	}


}
