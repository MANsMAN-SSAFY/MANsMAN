package com.msm.back.member.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProfileResponseDto {
    private String email;
    private String nickname;
    private LocalDate birthday;
    private String imgUrl;
    private SkinTypeDto skinType;
    private String faceShape;
    private boolean isPrivate;
}
