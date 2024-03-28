package com.msm.back.product.dto;

import com.msm.back.db.entity.CommonCode;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ProductCategoryDto {
	private int categoryCode;
	private String categoryName;

	@Builder
	public ProductCategoryDto(CommonCode commonCodeEntity) {
		this.categoryCode = commonCodeEntity.getCode();
		this.categoryName = commonCodeEntity.getCodeName();
	}
}
