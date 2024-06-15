package com.msm.back.db.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.msm.back.common.BaseEntity;
import com.msm.back.report.dto.ReportResponseDto;
import com.msm.back.report.dto.TagDto;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Report extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name="member_id")
    private Member member;

    private int acne; // 여드름

    private int wrinkle; // 주름

//    private int blackhead; // 블랙헤드

    @Enumerated(EnumType.STRING)
    private SkinTypeEnum skinType; // 건성, 지성, 정상

    @ManyToOne
    @JoinColumn(name="code")
    private CommonCode faceShapeCode;

    @JsonManagedReference
    @OneToMany(mappedBy="report")
    private List<Tag> tags;

    private String imgUrl; // 사진 url

    private int age; // 얼굴 나이

    private String memo;

    private Double water;

    private Double sleep;

    public ReportResponseDto toReportResponseDto() {
        String skinTypeKorean = "";
        if (skinType.name().equals("DRY")) {
            skinTypeKorean = "건성";
        } else if (skinType.name().equals("OILY")) {
            skinTypeKorean = "지성";
        } else {
            skinTypeKorean = "정상";
        }
        List<TagDto> tagList = new ArrayList<>();

        for (Tag tag : tags) {
            tagList.add(TagDto.builder().tag(tag).build());
        }

        return ReportResponseDto.builder()
                .reportId(id)
                .memberId(member.getId())
                .acne(acne)
                .wrinkle(wrinkle)
//                .blackhead(blackhead)
                .skinType(skinTypeKorean)
                .imgUrl(imgUrl)
                .age(age)
                .date(this.getCreatedAt().toLocalDate())
                .exists(true)
                .faceShape(faceShapeCode.getCodeName())
                .memo(memo)
                .sleep(sleep)
                .water(water)
                .tags(tagList)
                .build();
    }

    public void updateAcne(int acne) {
        this.acne = acne;
    }

    public void updateWrinkle(int wrinkle) {
        this.wrinkle = wrinkle;
    }

//    public void updateBlackhead(int blackhead) {
//        this.blackhead = blackhead;
//    }

    public void updateSkinType(SkinTypeEnum skinTypeEnum) {
        this.skinType = skinTypeEnum;
    }

    public void updateFaceShapeCode(CommonCode faceShapeCode) {
        this.faceShapeCode = faceShapeCode;
    }

    public void updateImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public void updateAge(int age) {
        this.age = age;
    }

    public void updateMemo(String memo) {
        this.memo = memo;
    }

    public void updateWater(double water) {
        this.water = water;
    }

    public void updateSleep(double sleep) {
        this.sleep = sleep;
    }


}