package com.msm.back.auth.dto;

import com.msm.back.db.entity.Member;
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
    private TokenDto tokenDto;
    private ProfileResponseDto ProfileResponseDto;
}
