package com.msm.back.board.dto;

import com.msm.back.db.entity.BoardImage;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BoardImageDto {
//    private Long id;
    private String boardImgUrl;
    private int displayOrder;

    @Builder
    public BoardImageDto(BoardImage boardImage) {
        this.boardImgUrl = boardImage.getBoardImgUrl();
        this.displayOrder = boardImage.getDisplayOrder();
    }
}
