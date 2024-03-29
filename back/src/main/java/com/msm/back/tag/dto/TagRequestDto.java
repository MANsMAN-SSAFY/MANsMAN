package com.msm.back.tag.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class TagRequestDto {
    private Long diaryId; // 태그가 속한 피부 일기의 id
    private String content; // 태그의 내용
}
