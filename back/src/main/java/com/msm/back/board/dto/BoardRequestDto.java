package com.msm.back.board.dto;

import com.msm.back.db.entity.BoardImage;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardRequestDto {
    private Long id;
    private String title;
    private String content;
    private List<BoardImage> boardImageList;
}