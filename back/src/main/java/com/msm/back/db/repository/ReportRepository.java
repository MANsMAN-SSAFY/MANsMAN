package com.msm.back.db.repository;

import com.msm.back.db.entity.Member;
import com.msm.back.db.entity.Report;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface ReportRepository extends JpaRepository<Report, Long>, ReportCustom {
    Optional<Report> findFirstByMemberOrderByCreatedAtDesc(Member member);

//    @Query("SELECT e FROM Report e " +
//            "WHERE DATE(e.createdAt) = :date " +
//            "AND e.member.id = :memberId " +
//            "ORDER BY e.createdAt ASC")
//    List<Report> findByCreatedAtAndCreatedByOrderByCreatedAtAsc(
//            @Param("date") LocalDate date,
//            @Param("memberId") Long memberId
//    );
    @Query("SELECT e FROM Report e " +
        "WHERE DATE(e.createdAt) = :date " +
        "AND e.member.id = :memberId")
    List<Report> findByCreatedAtAndCreatedBy(
        @Param("date") LocalDate date,
        @Param("memberId") Long memberId
    );


    @Query("SELECT e FROM Report e WHERE e.member.id = :currentMemberId ORDER BY e.createdAt DESC LIMIT :n")
    List<Report> getRecentReportsByMemberIdLimit(@Param("currentMemberId") Long currentMemberId, @Param("n") int n);


    Optional<Report> findFirstByMemberIdOrderByCreatedAtDesc(Long id);



}