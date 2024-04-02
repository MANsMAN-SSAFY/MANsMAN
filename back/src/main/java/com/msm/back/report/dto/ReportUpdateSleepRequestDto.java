package com.msm.back.report.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalTime;

@Getter
@NoArgsConstructor
public class ReportUpdateSleepRequestDto {
    private Long reportId;
    private double sleep;
}
