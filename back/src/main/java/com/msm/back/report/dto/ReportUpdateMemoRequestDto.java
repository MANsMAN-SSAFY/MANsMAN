package com.msm.back.report.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ReportUpdateMemoRequestDto {
    private Long reportId;
    private String memo;
}
