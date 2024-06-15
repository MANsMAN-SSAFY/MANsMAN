package com.msm.back.db.entity;

import com.msm.back.mask.dto.MaskResponseDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Mask {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name="member_id")
    private Member member;

    private LocalDate usedAt;

    public MaskResponseDto toMaskResponseDto() {
        return MaskResponseDto.builder().id(id).usedAt(usedAt).build();
    }
}
