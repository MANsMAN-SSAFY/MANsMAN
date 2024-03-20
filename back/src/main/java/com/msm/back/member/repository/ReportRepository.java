package com.msm.back.member.repository;

import com.msm.back.member.entity.Member;
import com.msm.back.member.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReportRepository extends JpaRepository<Report, Long> {
    List<Report> findByMemberOrderByCreatedAtDesc(Member member);
}