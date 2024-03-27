package com.msm.back.exception;

public class ProductNotFoundException extends RuntimeException {
    public ProductNotFoundException() {
        super("제품을 찾을 수 없습니다.");
    }
}
