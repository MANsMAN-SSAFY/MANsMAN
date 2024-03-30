package com.msm.back.report.dto;


import lombok.Getter;

import java.util.List;

@Getter
public class DailyReportScrollReponseDto {
    private List<DailyReportResponseDto> data;
    private boolean hasNext;
    private Long lastId;

    public DailyReportScrollReponseDto(List<DailyReportResponseDto> data, boolean hasNext) {
        this.data = data;
        this.hasNext = hasNext;
        this.lastId = !data.isEmpty()?data.get(data.size()-1).getReportId():0;
    }
}
