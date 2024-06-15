package com.msm.back.db.repository;

import com.msm.back.db.entity.Mask;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;


public interface MaskRepository extends JpaRepository<Mask, Long> {
    // 특정 달과 연도에 멤버에 의해 기록된 모든 마스크들 가져오기
    @Query("SELECT e FROM Mask e WHERE MONTH(e.usedAt) = :month AND YEAR(e.usedAt) = :year AND e.member.id = :currentMemberId ORDER BY e.usedAt ASC")
    List<Mask> findAllByCreatedAtMonthAndYearAndMember(@Param("month") int month, @Param("year") int year, @Param("currentMemberId") Long currentMemberId);

    // 특정 일에 멤버에 의해 기록된 모든 마스크들 가져오기
    @Query("SELECT e FROM Mask e WHERE e.usedAt = :date")
    List<Mask> findAllByCreatedAtDate(@Param("date") LocalDate date);

}
