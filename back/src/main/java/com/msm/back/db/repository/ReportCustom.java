package com.msm.back.db.repository;

import com.msm.back.report.dto.ReportResponseDto;
import org.springframework.data.domain.Slice;

public interface ReportCustom {
    Slice<ReportResponseDto> findAll(Long lastId, int pageSize, Long currentMemberId);
}
