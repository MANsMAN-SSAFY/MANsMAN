package com.msm.back.myProduct.service;

import com.msm.back.db.entity.Member;
import com.msm.back.db.entity.MyProduct;
import com.msm.back.db.entity.Product;
import com.msm.back.db.repository.MemberRepository;
import com.msm.back.db.repository.MyProductRepository;
import com.msm.back.db.repository.ProductRepository;
import com.msm.back.exception.MemberNotFoundException;
import com.msm.back.exception.ProductNotFoundException;
import com.msm.back.myProduct.dto.MyProductRequestDto;
import com.msm.back.myProduct.dto.MyProductResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.nio.channels.FileLockInterruptionException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MyProductService {

    private final MyProductRepository myProductRepository;
    private final ProductRepository productRepository;
    private final MemberRepository memberRepository;
    public MyProductResponseDto saveMyProduct(MyProductRequestDto myProductRequestDto) {
        // 로그인된 나의 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long myMemberId = Long.parseLong(authentication.getName());
        Member member = memberRepository.findById(myMemberId).orElseThrow(MemberNotFoundException::new);

        Long productId = myProductRequestDto.getProductId();
        Product product = productRepository.findById(productId).orElseThrow(ProductNotFoundException::new);

        MyProduct myProduct = myProductRepository.findByMemberIdAndProductId(myMemberId, productId).orElseThrow(() -> new IllegalArgumentException("이미 나의 상품에 추가한 상품입니다"));


        MyProduct toSaveMyProduct = MyProduct.builder()
                .member(member)
                .product(product)
                .cnt(myProductRequestDto.getCnt())
                .rating(myProductRequestDto.getRating())
                .review(myProductRequestDto.getReview())
                .isActive(myProductRequestDto.isActive())
                .build();

        myProductRepository.save(toSaveMyProduct);

        return toSaveMyProduct.toMyProductResponseDto();
    }

    public List<MyProductResponseDto> getMyProducts() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long myMemberId = Long.parseLong(authentication.getName());

        List<MyProduct> myProducts = myProductRepository.findByMemberId(myMemberId);

        List<MyProductResponseDto> myProductResponseDtos = new ArrayList<>();
        for (MyProduct myProduct: myProducts) {
            myProductResponseDtos.add(myProduct.toMyProductResponseDto());
        }

        return myProductResponseDtos;

    }
}
