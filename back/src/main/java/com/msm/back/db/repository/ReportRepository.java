package com.msm.back.db.repository;

import com.msm.back.db.entity.Member;
import com.msm.back.db.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReportRepository extends JpaRepository<Report, Long> {
    List<Report> findByMemberOrderByCreatedAtDesc(Member member);
}