package com.msm.back.db.repository;

import com.msm.back.db.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {
    Optional<Member> findByEmail(String email);

    boolean existsByEmail(String email);

    @Query("SELECT m FROM Member m WHERE NOT EXISTS " +
            "(SELECT r FROM Report r WHERE r.member.id = m.id AND DATE(r.createdAt) = CURRENT_DATE)")
    List<Member> findMembersWithoutReportsToday();
}
