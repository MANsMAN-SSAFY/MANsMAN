package com.msm.back.board.dto;


import com.msm.back.member.entity.Member;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardDto {
    private Long id;
    private String title;
    private String content;
    private Member member;
    private Long viewCnt;
    private Long likeCnt;
    private Long commentCnt;
}