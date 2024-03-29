package com.msm.back.db.repository;

import com.msm.back.db.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentLikeRepository extends JpaRepository<CommentLike, Long> {
    CommentLike findByCommentAndMember(Comment comment, Member member);
}