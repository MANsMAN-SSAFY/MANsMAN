package com.msm.back.db.repository;

import java.util.List;

import com.msm.back.db.entity.Board;
import com.msm.back.db.entity.CommonCode;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommonCodeRepository extends JpaRepository<CommonCode, Integer> {
    CommonCode findByCode(int code);

    List<CommonCode> findByParentCode(Integer categoryCode);
}
