package com.msm.back.db.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.msm.back.db.entity.Favorite;
import com.msm.back.db.entity.Member;
import com.msm.back.db.entity.Product;

public interface FavoriteRepository extends JpaRepository<Favorite, Long>{

	boolean existsByMemberAndProduct(Member member, Product product);

	boolean existsByMemberIdAndProductId(Long id, Long id1);

	List<Favorite> findByMember(Member member);
}
