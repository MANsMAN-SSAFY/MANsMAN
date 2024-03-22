package com.msm.back.board.repository;

import com.msm.back.board.entity.Scrap;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ScrapRepository extends JpaRepository<Scrap, Long> {
    List<Scrap> findByMemberId(Long memberId);
}