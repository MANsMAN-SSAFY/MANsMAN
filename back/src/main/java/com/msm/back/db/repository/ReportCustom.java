package com.msm.back.db.repository;

import com.msm.back.report.dto.DailyReportResponseDto;
import org.springframework.data.domain.Slice;

public interface ReportCustom {
    Slice<DailyReportResponseDto> findAll(Long lastId, int pageSize, Long currentMemberId);
}
