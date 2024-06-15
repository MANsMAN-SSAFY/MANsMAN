package com.msm.back.comment.controller;

import com.msm.back.board.dto.BoardLikeDto;
import com.msm.back.board.dto.BoardRequestDto;
import com.msm.back.board.dto.BoardResponseDto;
import com.msm.back.comment.dto.CommentDto;
import com.msm.back.comment.dto.CommentRequestDto;
import com.msm.back.comment.dto.CommentResponseDto;
import com.msm.back.comment.service.CommentService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/boards/{boardId}/comments")
public class CommentController {
    private final CommentService commentService;


    @PostMapping("")
    @Operation(summary = "댓글 생성")
    public ResponseEntity<CommentResponseDto> createComment(@PathVariable Long boardId, @RequestBody CommentResponseDto content) {
        CommentResponseDto createdComment = commentService.createComment(boardId, content);
        if (createdComment != null) {
            return ResponseEntity.status(HttpStatus.CREATED).body(createdComment);
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    @PutMapping("/{commentId}")
    @Operation(summary = "댓글 수정")
    public ResponseEntity<CommentResponseDto> editComment(@PathVariable Long boardId, @PathVariable Long commentId, @RequestBody CommentRequestDto commentRequestDto) {
        CommentResponseDto editedBoard = commentService.editComment(boardId, commentId, commentRequestDto);
        if (editedBoard != null) {
            return ResponseEntity.ok(editedBoard);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{commentId}")
    @Operation(summary = "댓글 삭제")
    public ResponseEntity<Void> deleteComment(@PathVariable Long boardId, @PathVariable Long commentId) {
        commentService.deleteComment(commentId);
        return ResponseEntity.noContent().build();
    }


    @GetMapping("")
    @Operation(summary = "댓글목록 조회")
    public ResponseEntity<List<CommentResponseDto>> getAllComments(
            @PathVariable Long boardId
//            @RequestParam("lastId") Long lastId,
//            @RequestParam("pageSize") Long pageSize
    ) {
        List<CommentResponseDto> comments = commentService.getAllComments(boardId);
        return ResponseEntity.ok(comments);
    }






}