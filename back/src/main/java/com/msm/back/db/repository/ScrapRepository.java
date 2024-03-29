package com.msm.back.db.repository;

import com.msm.back.db.entity.Board;
import com.msm.back.db.entity.Member;
import com.msm.back.db.entity.Scrap;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ScrapRepository extends JpaRepository<Scrap, Long> {
    List<Scrap> findByMemberId(Long memberId);
    boolean existsByBoardAndMember(Board board, Member member);
    Scrap findByBoardAndMember(Board board, Member member);
}