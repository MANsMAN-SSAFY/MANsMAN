package com.msm.back.db.repository;

import com.msm.back.db.entity.Board;
import com.msm.back.db.entity.BoardLike;
import com.msm.back.db.entity.Member;
import com.msm.back.db.entity.Scrap;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BoardLikeRepository extends JpaRepository<BoardLike, Long> {
    BoardLike findByBoardAndMember(Board board, Member member);
}