package com.msm.back.db.entity;

import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serializable;

@Embeddable
@EqualsAndHashCode
@NoArgsConstructor
@AllArgsConstructor
@Data
public class BoardLikeId implements Serializable {
    private Long memberId;
    private Long boardId;
}
