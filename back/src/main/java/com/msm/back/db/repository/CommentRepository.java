package com.msm.back.db.repository;

import com.msm.back.db.entity.Board;
import com.msm.back.db.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findAllByBoard(Board board);
}
