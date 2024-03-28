package com.msm.back.db.entity;

import lombok.*;

import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class MyProductId implements Serializable {

    private Long member;

    private Long product;

}
