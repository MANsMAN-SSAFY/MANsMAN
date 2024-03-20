package com.msm.back.member.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SkinTypeDto {
    private int acne;
    private int freckles;
    private int wrinkle;
    private int sag;
    private int oiliness;
}
