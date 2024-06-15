package com.msm.back.db.entity;

import com.msm.back.common.BaseEntity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Member extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String email;

    private String password;

    private String nickname;

    private LocalDate birthday;

    private String imgUrl;

    private boolean privacy;

    private String notificationToken; // 알림 토큰

    @Enumerated(EnumType.STRING)
    private Authority authority;

}
