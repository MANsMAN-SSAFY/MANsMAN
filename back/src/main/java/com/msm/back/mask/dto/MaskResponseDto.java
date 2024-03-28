package com.msm.back.mask.dto;

import lombok.*;

import java.time.LocalDate;

@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class MaskResponseDto {
    private Long id; // 생성된 마스크 기록의 고유번호
    private LocalDate usedAt; // 마스크 기록의 날짜
}
