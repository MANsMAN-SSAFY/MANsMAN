package com.msm.back.recommend.service;

import com.msm.back.db.entity.Product;
import com.msm.back.db.repository.FavoriteRepository;
import com.msm.back.db.repository.ProductRepository;
import com.msm.back.exception.ProductNotFoundException;
import com.msm.back.recommend.dto.RecommendRequestDto;
import com.msm.back.recommend.dto.RecommendResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class RecommendService {

    private final ProductRepository productRepository;
    private final FavoriteRepository favoriterRepository;
    @Value("${fastapi.url}")
    private String fastApiUrl;

    // 모든 유저들을 사이에서의 추천
    public List<RecommendResponseDto> getRecommendationAll() {
        // 로그인된 나의 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long myMemberId = Long.parseLong(authentication.getName());

        WebClient webClient =
                WebClient
                        .builder()
                        .baseUrl(fastApiUrl)
                        .build();

        RecommendRequestDto recommendRequestDto = RecommendRequestDto.builder().myMemberId(myMemberId).build();


        // skin-diary api 요청 후 분석된 결과를 받는다
        Map<String, Object> recommendationMap =
                webClient
                        .post()
                        .uri("/recommendation/all")
                        .bodyValue(recommendRequestDto)
                        .retrieve()
                        .bodyToMono(Map.class)
                        .block();

        List<Long> recommendationList = (List<Long>) recommendationMap.get("data");

        List<RecommendResponseDto> recommendResponseDtoList = new ArrayList<>();

        for (Long l: recommendationList) {
            Product p = productRepository.findById(l).orElseThrow(ProductNotFoundException::new);
            RecommendResponseDto recommendResponseDto = p.toRecommendResponseDto();
            if (favoriterRepository.existsByMemberIdAndProductId(myMemberId, p.getId())) {
                recommendResponseDto.updateFavorite(true);
            } else {
                recommendResponseDto.updateFavorite(false);
            }

            recommendResponseDtoList.add(recommendResponseDto);
        }

        return recommendResponseDtoList;

    }

    // 피부 타입 별 추천: 지성, 건성, 정상
    public List<RecommendResponseDto> getRecommendationSkinType() {
        // 로그인된 나의 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long myMemberId = Long.parseLong(authentication.getName());

        WebClient webClient =
                WebClient
                        .builder()
                        .baseUrl(fastApiUrl)
                        .build();

        RecommendRequestDto recommendRequestDto = RecommendRequestDto.builder().myMemberId(myMemberId).build();


        // skin-diary api 요청 후 분석된 결과를 받는다
        Map<String, Object> recommendationMap =
                webClient
                        .post()
                        .uri("/recommendation/skin-type")
                        .bodyValue(recommendRequestDto)
                        .retrieve()
                        .bodyToMono(Map.class)
                        .block();

        List<Long> recommendationList = (List<Long>) recommendationMap.get("data");

        List<RecommendResponseDto> recommendResponseDtoList = new ArrayList<>();

        for (Long l: recommendationList) {
            Product p = productRepository.findById(l).orElseThrow(ProductNotFoundException::new);
            RecommendResponseDto recommendResponseDto = p.toRecommendResponseDto();
            if (favoriterRepository.existsByMemberIdAndProductId(myMemberId, p.getId())) {
                recommendResponseDto.updateFavorite(true);
            } else {
                recommendResponseDto.updateFavorite(false);
            }

            recommendResponseDtoList.add(recommendResponseDto);
        }

        return recommendResponseDtoList;

    }

    public List<RecommendResponseDto> getRecommendationAge() {
        // 로그인된 나의 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long myMemberId = Long.parseLong(authentication.getName());

        WebClient webClient =
                WebClient
                        .builder()
                        .baseUrl(fastApiUrl)
                        .build();

        RecommendRequestDto recommendRequestDto = RecommendRequestDto.builder().myMemberId(myMemberId).build();


        // skin-diary api 요청 후 분석된 결과를 받는다
        Map<String, Object> recommendationMap =
                webClient
                        .post()
                        .uri("/recommendation/age")
                        .bodyValue(recommendRequestDto)
                        .retrieve()
                        .bodyToMono(Map.class)
                        .block();

        List<Long> recommendationList = (List<Long>) recommendationMap.get("data");

        List<RecommendResponseDto> recommendResponseDtoList = new ArrayList<>();

        for (Long l: recommendationList) {
            Product p = productRepository.findById(l).orElseThrow(ProductNotFoundException::new);
            RecommendResponseDto recommendResponseDto = p.toRecommendResponseDto();
            if (favoriterRepository.existsByMemberIdAndProductId(myMemberId, p.getId())) {
                recommendResponseDto.updateFavorite(true);
            } else {
                recommendResponseDto.updateFavorite(false);
            }

            recommendResponseDtoList.add(recommendResponseDto);
        }

        return recommendResponseDtoList;
    }

}
