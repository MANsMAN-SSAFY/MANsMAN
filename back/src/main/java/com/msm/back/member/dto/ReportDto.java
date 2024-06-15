package com.msm.back.member.dto;

import com.msm.back.db.entity.Report;
import com.msm.back.db.entity.SkinTypeEnum;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ReportDto {
    private int acne;
    private int wrinkle;
//    private int blackhead;
    private int age;
    private SkinTypeEnum skinType;
    private String faceShape;

    public ReportDto(Report report) {
        this.acne = report.getAcne();
        this.wrinkle = report.getWrinkle();
//        this.blackhead = report.getBlackhead();
        this.age = report.getAge();
        this.skinType = report.getSkinType();
        this.faceShape = report.getFaceShapeCode().getCodeName();
    }
}
