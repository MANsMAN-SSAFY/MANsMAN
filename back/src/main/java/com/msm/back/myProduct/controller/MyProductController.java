package com.msm.back.myProduct.controller;

import com.msm.back.myProduct.dto.MyProductRequestDto;
import com.msm.back.myProduct.dto.MyProductResponseDto;
import com.msm.back.myProduct.service.MyProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/my-products")
public class MyProductController {

    private final MyProductService myProductService;
    @PostMapping("")
    public ResponseEntity<MyProductResponseDto> saveMyProduct(@RequestBody MyProductRequestDto myProductRequestDto) {
        MyProductResponseDto myProductResponseDto = myProductService.saveMyProduct(myProductRequestDto);

        return ResponseEntity.status(HttpStatus.CREATED).body(myProductResponseDto);
    }

    @GetMapping("")
    public ResponseEntity<List<MyProductResponseDto>> getMyProducts() {
        List<MyProductResponseDto> myProductResponseDtos = myProductService.getMyProducts();

        return ResponseEntity.ok().body(myProductResponseDtos);
    }
}
