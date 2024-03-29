package com.msm.back.diary.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalTime;

@Getter
@NoArgsConstructor
public class DiaryRequestDto {
    private String memo;
    private int water;
    private String sleep; // "10-01-23" 형태이어야 함. 10시간 1분 23초 수면.
}
