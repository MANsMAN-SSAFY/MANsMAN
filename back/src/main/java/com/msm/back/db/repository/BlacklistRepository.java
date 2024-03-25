package com.msm.back.db.repository;

import com.msm.back.db.entity.Blacklist;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BlacklistRepository extends JpaRepository<Blacklist, Long> {
}