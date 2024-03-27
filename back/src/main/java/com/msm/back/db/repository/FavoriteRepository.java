package com.msm.back.db.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.msm.back.db.entity.Favorite;
import com.msm.back.db.entity.Member;
import com.msm.back.db.entity.Product;

public interface FavoriteRepository extends JpaRepository<Favorite, Long>{

	boolean existsByMemberAndProduct(Member member, Product product);

}
