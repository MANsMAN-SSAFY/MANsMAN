package com.msm.back.db.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.msm.back.db.entity.Product;
import com.msm.back.db.entity.ProductImage;

public interface PoductImageRepository extends JpaRepository<ProductImage, Long>, ProductCustom{

}
