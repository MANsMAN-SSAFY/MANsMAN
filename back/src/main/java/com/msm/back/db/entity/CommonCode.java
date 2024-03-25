package com.msm.back.db.entity;

import com.msm.back.common.BaseEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Getter;

@Entity
@Getter
public class CommonCode extends BaseEntity {

    // 공통코드
    @Id
    private int code;

    // 공통코드명
    private String codeName;

    // 부모코드
    private int parentCode;

}