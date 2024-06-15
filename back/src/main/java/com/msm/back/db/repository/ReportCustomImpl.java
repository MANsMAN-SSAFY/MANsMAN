package com.msm.back.db.repository;


import com.msm.back.db.entity.*;
import com.msm.back.report.dto.ReportResponseDto;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class ReportCustomImpl implements ReportCustom {

    private final JPAQueryFactory query;
    private final QReport report = QReport.report;


    @Override
    public Slice<ReportResponseDto> findAll(Long lastId, int pageSize, Long currentMemberId) {
        Pageable pageable = PageRequest.of(1, pageSize);

        List<Report> reports = query.selectFrom(report)
                .where(report.member.id.eq(currentMemberId))
                .where(ltReportId(lastId))
                .orderBy(report.id.desc())
                .limit(pageSize + 1)
                .fetch();

        List<ReportResponseDto> dailyReportResponseDtos = new ArrayList<>();

        for (Report r: reports) {
            dailyReportResponseDtos.add(r.toReportResponseDto());
        }

        return checkLastPage(pageable, dailyReportResponseDtos);


    }

    private BooleanExpression ltReportId(Long reportId) {
        if (reportId == null) {
            return null;
        }
        return report.id.lt(reportId);
    }

    private Slice<ReportResponseDto> checkLastPage(Pageable pageable, List<ReportResponseDto> results) {

        boolean hasNext = false;

        // 조회한 결과 개수가 요청한 페이지 사이즈보다 크면 뒤에 더 있음, next = true
        if (results.size() > pageable.getPageSize()) {
            hasNext = true;
            results.remove(pageable.getPageSize());
        }

        return new SliceImpl<>(results, pageable, hasNext);
    }
}
