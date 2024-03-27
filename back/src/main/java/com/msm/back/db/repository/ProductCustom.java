package com.msm.back.db.repository;

import java.util.List;

import org.springframework.data.domain.Slice;

import com.msm.back.db.entity.Product;
import com.msm.back.product.dto.ProductListRequestDto;

public interface ProductCustom {

	Slice<Product> findAll(ProductListRequestDto requestDto);

}
