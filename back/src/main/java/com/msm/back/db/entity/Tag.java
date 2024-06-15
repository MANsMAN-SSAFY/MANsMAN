package com.msm.back.db.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.msm.back.common.BaseEntity;
import com.msm.back.tag.dto.TagResponseDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Tag extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonBackReference
    @ManyToOne
    @JoinColumn(name="report_id")
    private Report report;

    private String content;

    private String color;

    public TagResponseDto toTagResponseDto() {
        return TagResponseDto.builder().tagId(id).reportId(report.getId()).content(content).color(color).build();
    }
}
