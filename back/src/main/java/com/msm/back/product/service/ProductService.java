package com.msm.back.product.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import com.msm.back.config.RedisConfig;
import com.msm.back.db.entity.CommonCode;
import com.msm.back.db.entity.Favorite;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Slice;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.client.WebClient;

import com.msm.back.common.SecurityUtil;
import com.msm.back.db.entity.Member;
import com.msm.back.db.entity.Product;
import com.msm.back.db.entity.ProductImage;
import com.msm.back.db.repository.CommonCodeRepository;
import com.msm.back.db.repository.FavoriteRepository;
import com.msm.back.db.repository.MemberRepository;
import com.msm.back.db.repository.ProductRepository;
import com.msm.back.exception.MemberNotFoundException;
import com.msm.back.exception.ProductNotFoundException;
import com.msm.back.product.dto.ProductCategoryDto;
import com.msm.back.product.dto.ProductDetailResponseDto;
import com.msm.back.product.dto.ProductListRequestDto;
import com.msm.back.product.dto.ProductListDto;
import com.msm.back.product.dto.ProductListResponseDto;

import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
public class ProductService {

	private final ProductRepository productRepository;
	private final FavoriteRepository favoriteRepository;
	private final MemberRepository memberRepository;
	private final CommonCodeRepository commonCodeRepository;

	@Value("${fastapi.url}")
	private String fastApiUrl;


	public ProductListResponseDto findAll(ProductListRequestDto productListRequestDto) {

		Member member = getMember();
		//slice로 페이지에 맞는 화장품 데이터 및 추가 페이지 존재 여부 반환
		Slice<ProductListDto> products = productRepository.findAll(productListRequestDto, member.getId());

		return new ProductListResponseDto(new ArrayList<>(products.getContent()), products.hasNext());
	}


	@Transactional
	public ProductDetailResponseDto findById(long productId) {
		//로그인한 사용자
		Member member = getMember();

		Product product = productRepository.findById(productId)
			.orElseThrow(ProductNotFoundException::new);

		boolean isFavorite = favoriteRepository.existsByMemberAndProduct(member, product);

		//entity 형식의 이미지 주소를 string으로 변환
		List<String> imgList = new ArrayList<>();

		// orderColumn 설정때문에 seq가 0인 값을 찾음. -> 없어서 0번째 인덱스가 null... 고로 지워줘야 한다.
		product.getImgList().remove(0);

		System.out.println("이미지 개수: "+product.getImgList().size());
		for (ProductImage img : product.getImgList()) {
			imgList.add(img.getImgUrl());
		}

		ProductDetailResponseDto productDto = ProductDetailResponseDto.builder()
			.product(product)
			.isFavorite(isFavorite)
			.imgList(imgList)
			.build();

		return productDto;
	}



	@Transactional
	public long saveFavorite(long productId) {

		Member member = getMember();
		Product product = productRepository.findById(productId)
			.orElseThrow(ProductNotFoundException::new);
		Favorite favorite = Favorite.builder()
			.product(product)
			.member(member)
			.build();
		return favoriteRepository.save(favorite).getProduct().getId();
	}

	@Transactional
	public void deleteFavorite(long productId) {
		Member member = getMember();
		Product product = productRepository.findById(productId)
			.orElseThrow(ProductNotFoundException::new);
		Favorite favorite = Favorite.builder()
			.product(product)
			.member(member)
			.build();
		favoriteRepository.delete(favorite);
	}


	public List<ProductCategoryDto> getCategory(Integer categoryCode) {
		List<ProductCategoryDto> categoryList = new ArrayList<>();
		List<CommonCode> codeEntityList = commonCodeRepository.findByParentCode(categoryCode);
		for (CommonCode commonCode : codeEntityList) {
			categoryList.add(ProductCategoryDto.builder()
				.commonCodeEntity(commonCode)
				.build());
		}
		return categoryList;
	}

	@Transactional
	@Cacheable(value = "hotProduct", key="@securityUtil.getCurrentMemberId()", cacheManager = "contentCacheManager")
	public List<ProductListDto> findByPopularity() {
		// 인기순위기준으로 출력하고 즐겨찾기 여부를 함께 보여준다.
		Member member = getMember();

		return  productRepository.findByPopularity(member.getId());

	}



	@Cacheable(value = "similarProduct", key="#productId", cacheManager = "contentCacheManager")
	public List<ProductListDto> findBySimilarity(Long productId) {
		WebClient webClient =
			WebClient
				.builder()
				.baseUrl(fastApiUrl)
				.build();

		Mono<List<ProductListDto>> similarList =
			webClient
				.get()
				.uri("/similar-product/" + productId)
				.retrieve()
				.bodyToFlux(ProductListDto.class)
				.collectList();

		Member member = getMember();

		// Mono는 nonBlocking 환경에 사용되는 자료형이다.
		// block형태로 사용하는 것은 권장되지 않으나 현재 서비스가 동기식 프로그래밍이기에 사용할 것임.
		List<ProductListDto> resultList = Objects.requireNonNull(similarList.block());
		resultList.forEach(productListDto -> {
			boolean isFavorite = favoriteRepository.existsByMemberIdAndProductId(member.getId(), productListDto.getId());
			productListDto.setFavorite(isFavorite);
		});

		return resultList;
	}
	public List<ProductListDto> getFavorites() {
		Member member = getMember();
		List<Favorite> favorites = favoriteRepository.findByMember(member);

		List<ProductListDto> favoriteProducts = new ArrayList<>();
		for (Favorite favorite : favorites) {
			favoriteProducts.add(ProductListDto.builder()
				.product(favorite.getProduct())
				.isFavorite(true)
				.build());
		}
		return favoriteProducts;
	}


	private Member getMember() {
		//토큰에서 멤버 정보 가져오기
		Long memberId = SecurityUtil.getCurrentMemberId();

		//사용자의 id를 가지고 사용자 정보 가져옴

		return memberRepository.findById(memberId)
			.orElseThrow(MemberNotFoundException::new);
	}


}
