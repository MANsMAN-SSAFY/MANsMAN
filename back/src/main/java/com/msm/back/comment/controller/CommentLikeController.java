package com.msm.back.comment.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.msm.back.comment.service.CommentService;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/comments/{commentId}/likes")
public class CommentLikeController {

	private final CommentService commentService;
	@PostMapping("")
	@Operation(summary = "댓글 좋아요")
	public ResponseEntity<Void> likeComment(@PathVariable Long commentId) {
		commentService.likeComment(commentId);
		return ResponseEntity.ok().build();
	}

	@DeleteMapping("")
	@Operation(summary = "댓글 좋아요 삭제")
	public ResponseEntity<Void> unlikeComment(@PathVariable Long commentId) {
		commentService.unlikeBoard(commentId);
		return ResponseEntity.ok().build();
	}

}
