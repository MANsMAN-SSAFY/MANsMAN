package com.msm.back.product.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProductListRequestDto {

	private Integer categoryCode;

	private Long lastId;

	private int pageSize;

	private String searchWord;
}
