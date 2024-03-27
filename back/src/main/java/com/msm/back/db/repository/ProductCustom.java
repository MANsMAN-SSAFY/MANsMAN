package com.msm.back.db.repository;

import java.util.List;

import com.msm.back.db.entity.Product;
import com.msm.back.product.dto.ProductListRequestDto;

public interface ProductCustom {

	List<Product> findAll(ProductListRequestDto requestDto);

}
