package com.msm.back.product.dto;

import java.util.List;

import org.springframework.data.domain.Slice;

import com.msm.back.db.entity.Product;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@NoArgsConstructor
public class ProductListResponseDto {
	private List<ProductListDto> data;
	private boolean hasNextPage;
	private Long lastId;

	public ProductListResponseDto(List<ProductListDto> productListDtos, boolean hasNextPage) {
		this.data = productListDtos;
		this.hasNextPage = hasNextPage;
		this.lastId = !productListDtos.isEmpty()?productListDtos.get(productListDtos.size()-1).getId():0;
	}

}
//