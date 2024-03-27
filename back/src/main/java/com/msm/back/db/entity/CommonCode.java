package com.msm.back.db.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Getter;

@Entity
@Getter
public class CommonCode {

    // 공통코드
    @Id
    private int code;

    // 공통코드명
    private String codeName;

}