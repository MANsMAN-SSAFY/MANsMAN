package com.msm.back.db.repository;

import com.msm.back.db.entity.Board;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BoardRepository extends JpaRepository<Board, Long> , BoardCustom{
    // 사용자 ID로 게시글 리스트 조회 (삭제되지 않은 게시글만)
    List<Board> findByMemberIdOrderByCreatedAtDesc(Long memberId);

}
