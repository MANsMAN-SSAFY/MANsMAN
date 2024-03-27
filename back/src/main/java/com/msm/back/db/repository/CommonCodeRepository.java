package com.msm.back.db.repository;

import com.msm.back.db.entity.Board;
import com.msm.back.db.entity.CommonCode;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommonCodeRepository extends JpaRepository<CommonCode, Integer> {
    CommonCode findById(int id);
}
