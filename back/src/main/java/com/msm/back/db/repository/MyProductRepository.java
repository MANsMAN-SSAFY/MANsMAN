package com.msm.back.db.repository;

import com.msm.back.db.entity.Member;
import com.msm.back.db.entity.MyProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MyProductRepository extends JpaRepository<MyProduct, Long> {
    Optional<MyProduct> findByMemberIdAndProductId(Long memberId, Long productId);

    List<MyProduct> findByMember(Member member);
}
