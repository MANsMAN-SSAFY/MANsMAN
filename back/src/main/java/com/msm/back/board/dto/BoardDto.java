package com.msm.back.board.dto;


import java.time.LocalDateTime;
import java.util.List;

import com.msm.back.db.entity.Board;
import com.msm.back.member.dto.ProfileResponseDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@NoArgsConstructor
public class BoardDto {
    private Long id;
    private String title;
    private String content;
    @Setter
    private ProfileResponseDto writer;

    private Long viewCnt;
    private Long likeCnt;
    private Long commentCnt;
    private boolean isScrap;
    private boolean isLike;
    private List<BoardImageDto> boaredImageList;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @Builder
    public BoardDto(Board board, ProfileResponseDto writer, List<BoardImageDto> boardImageDtoList, boolean isScrap, boolean isLike) {
        this.id = board.getId();
        this.title = board.getTitle();
        this.content = board.getContent();
        this.writer = writer;
        this.viewCnt = board.getViewCnt();
        this.likeCnt = board.getLikeCnt();
        this.commentCnt = board.getCommentCnt();
        this.boaredImageList = boardImageDtoList;
        this.createdAt = board.getCreatedAt();
        this.updatedAt = board.getUpdatedAt();
        this.isScrap = isScrap;
        this.isLike = isLike;
    }


}