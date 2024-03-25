package com.msm.back.db.entity;

import com.msm.back.common.BaseEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardImage extends BaseEntity {

    @Id
    private Long id;

    private String boardImgUrl;

    private int displayOrder;

}
