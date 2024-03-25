package com.msm.back.product.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.msm.back.db.repository.ProductRepository;
import com.msm.back.product.dto.ProductListResponseDto;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProductService {

	private final ProductRepository productRepository;

	public static List<ProductListResponseDto> findAll() {

		return null;
	}
}
