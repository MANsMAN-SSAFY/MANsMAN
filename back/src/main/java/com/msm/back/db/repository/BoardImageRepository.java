package com.msm.back.db.repository;

import com.msm.back.db.entity.Board;
import com.msm.back.db.entity.BoardImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BoardImageRepository extends JpaRepository<BoardImage, Long> {
    // Additional methods for BoardImage entity if needed

}