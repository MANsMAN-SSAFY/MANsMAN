package com.msm.back.product.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.msm.back.product.dto.ProductCategoryDto;
import com.msm.back.product.dto.ProductDetailResponseDto;
import com.msm.back.product.dto.ProductListRequestDto;
import com.msm.back.product.dto.ProductListDto;
import com.msm.back.product.dto.ProductListResponseDto;
import com.msm.back.product.service.ProductService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/products")
@Tag(name = "상품", description = "상품 탐색과 관련한 API")
public class ProductController {

	private final ProductService productService;

	// 검색과 필터링을 동적쿼리로 함께 처리
	@GetMapping("")
	@Operation(summary = "상품 리스트 , 상품 검색",
		description = "상품 리스트와 검색을 한 번에 다루는 api, requestParam으로 검색어와 카테고리 여부를 확인한다. "
			+ "피부 타입별로 조회 시 skinType에 건성 (D), 지성(O), 복합성(C) 값을 주면 된다."
			+ "효능별로 조사 시 concern에 보습(M), 진정(S), 주름/미백(W) 값을 주면 된다. ")
	public ResponseEntity<ProductListResponseDto> getProductList(
		ProductListRequestDto productListRequestDto) {

		ProductListResponseDto productListResponseDtos = productService.findAll(productListRequestDto);
		return ResponseEntity.ok(productListResponseDtos);
	}

	@GetMapping("/{productId}")
	@Operation(summary = "상품 상세", description = "상품 번호로 상세 정보를 확인한다.")
	public ResponseEntity<ProductDetailResponseDto> getProductDetail(@PathVariable long productId) {
		ProductDetailResponseDto productDetailResponseDto = productService.findById(productId);
		return ResponseEntity.ok(productDetailResponseDto);
	}

	@PostMapping("/{productId}/favorites")
	@Operation(summary = "즐겨찾기 등록", description = "상품 번호로 해당 상품을 즐겨찾기에 등록한다.")
	public ResponseEntity<Long> addFavorite(@PathVariable long productId) {
		long favoriteId = productService.saveFavorite(productId);

		return ResponseEntity.status(HttpStatus.CREATED).body(favoriteId);
	}

	@DeleteMapping("/{productId}/favorites")
	@Operation(summary = "즐겨찾기 취소", description = "상품 번호로 해당 상품을 즐겨찾기에서 삭제한다.")
	public ResponseEntity<Void> deleteFavorite(@PathVariable long productId) {
		productService.deleteFavorite(productId);
		return ResponseEntity.noContent().build();
	}

	@GetMapping("/categories")
	@Operation(summary = "카테고리 코드", description = "클라이언트가 카테고리에 해당하는 코드를 알기 위해 카테고리를 코드와 함께 리턴한다.")
	public ResponseEntity<List<ProductCategoryDto>> getCategory(@RequestParam(required = false) Integer categoryCode) {
		List<ProductCategoryDto> data = productService.getCategory(categoryCode);

		return ResponseEntity.ok(data);
	}

	@GetMapping("/hot-products")
	@Operation(summary = "인기 상품", description = "인기 상품을 원하는 개수만큼 출력")
	public ResponseEntity<List<ProductListDto>> getHotProduct() {
		List<ProductListDto> data = productService.findByPopularity();

		return ResponseEntity.ok(data);
	}

	@GetMapping("/{productId}/similar")
	@Operation(summary = "유사한 상품", description = "현재 상품 번호를 기준으로 유사한 화장품 리스트 출력")
	public ResponseEntity<List<ProductListDto>> getSimilarProduct(@PathVariable Long productId) {
		List<ProductListDto> data = productService.findBySimilarity(productId);

		return ResponseEntity.ok().body(data);
	}

	@GetMapping("/favorites")
	public ResponseEntity<List<ProductListDto>> getFavorites() {
		List<ProductListDto> data = productService.getFavorites();

		return ResponseEntity.ok(data);
	}
}
