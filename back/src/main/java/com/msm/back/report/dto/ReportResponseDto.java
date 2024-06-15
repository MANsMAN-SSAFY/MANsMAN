package com.msm.back.report.dto;

import com.msm.back.db.entity.Tag;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
public class ReportResponseDto {
    private Long reportId;
    private Long memberId;
    private int acne;
    private int wrinkle; // 주름
//    private int blackhead; // 블랙헤드
    private String skinType; // 지성, 건성, 정상
    private String faceShape; // 얼굴형
    private String imgUrl; // 얼굴 사진의 url
    private int age; // 얼굴 나이
    private LocalDate date;
    private boolean exists; // 존재하는 지 확인
    private String memo;
    private Double water;
    private Double sleep;
    private List<TagDto> tags;
}
