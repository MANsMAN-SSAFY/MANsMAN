package com.msm.back.db.repository;

import java.util.List;

import com.msm.back.db.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


public interface ProductRepository extends JpaRepository<Product, Long>, ProductCustom{

}
