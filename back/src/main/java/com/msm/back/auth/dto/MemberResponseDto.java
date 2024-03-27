package com.msm.back.auth.dto;

import com.msm.back.member.dto.ProfileResponseDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MemberResponseDto {
    private TokenResponseDto tokenResponseDto;
    private ProfileResponseDto ProfileResponseDto;
}
