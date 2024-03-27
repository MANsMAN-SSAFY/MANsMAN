package com.msm.back.board.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardImageDto {
//    private Long id;
    private String boardImgUrl;
    private int displayOrder;
}
