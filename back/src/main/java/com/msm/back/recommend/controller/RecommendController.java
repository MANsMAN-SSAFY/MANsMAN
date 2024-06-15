package com.msm.back.recommend.controller;

import com.msm.back.recommend.dto.RecommendResponseDto;
import com.msm.back.recommend.service.RecommendService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/recommendation")
public class RecommendController {
//    /api/recommendation/all 전체
///api/recommendation/age 나이별
///api/recommendation/skin
    private final RecommendService recommendService;
    @GetMapping("/all")
    public ResponseEntity<List<RecommendResponseDto>> getRecommendationAll() {
        List<RecommendResponseDto> recommendResponseDtoList = recommendService.getRecommendationAll();
        return ResponseEntity.ok(recommendResponseDtoList);
    }

    @GetMapping("/age")
    public ResponseEntity<List<RecommendResponseDto>> getRecommendationAge() {
        List<RecommendResponseDto> recommendResponseDtoList = recommendService.getRecommendationAge();
        return ResponseEntity.ok(recommendResponseDtoList);
    }

    @GetMapping("/skinType")
    public ResponseEntity<List<RecommendResponseDto>> getRecommendationSkinType() {
        List<RecommendResponseDto> recommendResponseDtoList = recommendService.getRecommendationSkinType();
        return ResponseEntity.ok(recommendResponseDtoList);
    }


}
