package com.msm.back.report.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ReportUpdateWaterRequestDto {
    private Long reportId;
    private int water;
}
