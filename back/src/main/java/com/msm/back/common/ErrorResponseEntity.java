package com.msm.back.common;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ErrorResponseEntity {
    private String error;
}