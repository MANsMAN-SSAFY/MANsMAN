package com.msm.back.diary.dto;

import com.msm.back.db.entity.Tag;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalTime;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DiaryResponseDto {
    private Long diaryId;
    private String memo;
    private int water;
    private LocalTime sleep;

    private List<Tag> tags;
}
