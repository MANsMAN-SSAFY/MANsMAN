package com.msm.back.board.dto;

import com.msm.back.db.entity.Board;
import com.msm.back.member.dto.ProfileResponseDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
public class BoardResponseDto {
    private Long id;
    private String title;
    private String content;
    private Long viewCnt;
    private Long commentCnt;
    private Long likeCnt;
    private ProfileResponseDto writer; // 게시글 작성자 정보
    private List<BoardImageDto> boardImageList;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isLike;
    private boolean isScrap;

    @Builder
    public BoardResponseDto(Board board, ProfileResponseDto writer,List<BoardImageDto> boardImageDtoList, boolean isLike, boolean isScrap) {
        this.id = board.getId();
        this.title = board.getTitle();
        this.content = board.getContent();
        this.viewCnt = board.getViewCnt();
        this.commentCnt = board.getCommentCnt();
        this.likeCnt = board.getLikeCnt();
        this.writer = writer;
        this.boardImageList = boardImageDtoList;
        this.createdAt = board.getCreatedAt();
        this.updatedAt = board.getUpdatedAt();
        this.isLike = isLike;
        this.isScrap = isScrap;
    }

    public BoardResponseDto(Long id, String title, String content, Long viewCnt, Long commentCnt, Long likeCnt,
        ProfileResponseDto writer, List<BoardImageDto> boardImageList, LocalDateTime createdAt, LocalDateTime updatedAt,
        boolean isLike, boolean isScrap) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.viewCnt = viewCnt;
        this.commentCnt = commentCnt;
        this.likeCnt = likeCnt;
        this.writer = writer;
        this.boardImageList = boardImageList;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.isLike = isLike;
        this.isScrap = isScrap;
    }
}