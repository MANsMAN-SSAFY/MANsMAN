package com.msm.back.db.repository;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Repository;

import com.msm.back.db.entity.Product;
import com.msm.back.db.entity.QFavorite;
import com.msm.back.db.entity.QProduct;
import com.msm.back.product.dto.ProductListDto;
import com.msm.back.product.dto.ProductListRequestDto;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ProductCustomImpl implements ProductCustom {
	private final JPAQueryFactory query;
	private final QProduct product = QProduct.product;
	private final QFavorite favorite = QFavorite.favorite;

	@Override
	public Slice<ProductListDto> findAll(ProductListRequestDto requestDto, Long id) {
		Pageable pageable = PageRequest.of(1, requestDto.getPageSize());
		List<Tuple> results = query.select(product, favorite.member.id)
			.from(product)
			.leftJoin(favorite)
			.on(product.id.eq(favorite.product.id).and(favorite.member.id.eq(id)))
			.where(ltProductId(requestDto.getLastId()))
			.where(catCode(requestDto.getCategoryCode()))
			.where(hasSearchWord(requestDto.getSearchWord()))
			.where(checkFilter(requestDto.getSkinType(), requestDto.getConcern()))
			.orderBy(product.id.desc())
			.limit(requestDto.getPageSize() + 1)
			.fetch();

		List<ProductListDto> list = new ArrayList<>();
		for (Tuple result : results) {
			list.add(ProductListDto.builder()
				.product(result.get(product))
				.isFavorite(result.get(favorite.member.id)!=null)
				.build());
		}

		return checkLastPage(pageable, list);
	}

	@Override
	public List<ProductListDto> findByPopularity(Long id) {
		// SELECT *
		// 	FROM product
		// ORDER BY ((cnt_rating / (cnt_rating + 20))
		// 	* avg_rating + (20 / (cnt_rating + 20))
		// 	* (SELECT AVG(avg_rating) FROM product))
		// ;
		// 평균 평점과 평점 수를 기준으로 인기 순위를 판단하는 식을 세워 그 식을 기준으로 인기 순 출력

		List<Tuple> results = query
			.select(product, favorite.member.id)
			.from(product)
			.leftJoin(favorite)
			.on(product.id.eq(favorite.product.id).and(favorite.member.id.eq(id)))
			.orderBy(product.cntRating.
				divide(product.cntRating.
					add(20))
				.multiply(product.avgRating)
				.add(product.cntRating.add(20).divide(20))
				.multiply(JPAExpressions.select(
					product.avgRating.avg()).from(product)).desc())
			.limit(20)
			.fetch();

		List<ProductListDto> list = new ArrayList<>();
		for (Tuple result : results) {
			list.add(ProductListDto.builder()
				.product(result.get(product))
				.isFavorite(result.get(favorite.member.id)!=null)
				.build());
		}
		return list;
	}

	@Override
	public List<Product> findByIdIn(List<Long> idList) {

		return query
			.selectFrom(product)
			.where(product.id.in(idList))
			.fetch();
	}

	// 다음 페이지 있는지 확인
	private BooleanExpression ltProductId(Long productId) {
		if (productId == null) {
			return null;
		}
		return product.id.lt(productId);
	}

	// categoryCode 있는지 확인
	private BooleanExpression catCode(Integer categoryCode) {
		if (categoryCode == null) {
			return product.category.code.between(10000000,20000000);
		}
		if(categoryCode<1000){
			return product.category.code.between(categoryCode*100000,(categoryCode+100)*100000);
		}else if(categoryCode<1000000){
			return product.category.code.between(categoryCode*100,(categoryCode+100)*100);
		}else{
			if(categoryCode%10==0){
				return product.category.code.between(categoryCode,categoryCode+100);
			}else{
				return product.category.code.eq(categoryCode);
			}

		}
	}

	private BooleanExpression checkFilter(String skinType, String concern) {
		if(skinType!=null&& !skinType.isEmpty()){
			if(concern!=null&& !concern.isEmpty()){
				return skinType(skinType).and(concern(concern));
			}else{
				return skinType(skinType);
			}
		}else{
			if(concern!=null&& !concern.isEmpty()){
				return concern(concern);
			}
		}
		return null;
	}

	private BooleanExpression skinType(String skinType) {
		if (skinType == null) {
			return null;
		}
		switch(skinType){
			case "D":
				// 건성
				return product.skinTypeDry.ne(0).and(product.skinTypeDry.goe(product.skinTypeCombination).and(product.skinTypeDry.goe(product.skinTypeOily)));
			case "O":
				// 지성
				return product.skinTypeOily.ne(0).and(product.skinTypeOily.goe(product.skinTypeCombination).and(product.skinTypeOily.goe(product.skinTypeDry)));
			case "C":
				// 복합성
				return product.skinTypeCombination.ne(0).and(product.skinTypeCombination.goe(product.skinTypeDry).and(product.skinTypeCombination.goe(product.skinTypeOily)));
			default:
				return null;
		}
	}

	private BooleanExpression concern(String concern) {
		if (concern == null) {
			return null;
		}
		switch(concern){
			case "M":
				// 보습
				return product.skinConcernsMoisturizing.ne(0).and(product.skinConcernsMoisturizing.goe(product.skinConcernsSoothing).and(product.skinConcernsMoisturizing.goe(product.skinConcernsWrinkleWhitening)));
			case "S":
				// 진정
				return product.skinConcernsSoothing.ne(0).and(product.skinConcernsSoothing.goe(product.skinConcernsMoisturizing).and(product.skinConcernsSoothing.goe(product.skinConcernsWrinkleWhitening)));
			case "W":
				// 주름/미백
				return product.skinConcernsWrinkleWhitening.ne(0).and(product.skinConcernsWrinkleWhitening.goe(product.skinConcernsMoisturizing).and(product.skinConcernsWrinkleWhitening.goe(product.skinConcernsSoothing)));
			default:
				return null;
		}
	}

	// categoryCode 있는지 확인
	private BooleanExpression hasSearchWord(String searchWord) {
		if (searchWord == null) {
			return null;
		}
		return product.name.contains(searchWord);
	}

	// 무한 스크롤 방식 처리하는 메서드
	private Slice<ProductListDto> checkLastPage(Pageable pageable, List<ProductListDto> results) {

		boolean hasNext = false;

		// 조회한 결과 개수가 요청한 페이지 사이즈보다 크면 뒤에 더 있음, next = true
		if (results.size() > pageable.getPageSize()) {
			hasNext = true;
			results.remove(pageable.getPageSize());
		}

		return new SliceImpl<>(results, pageable, hasNext);
	}
}
