package com.callwork.api.repository;

import com.callwork.api.model.Professional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProfessionalRepository extends JpaRepository<Professional, Long> {

    @Query("""
           SELECT p FROM Professional p
           WHERE (:category IS NULL OR p.category = :category)
             AND (:meiOnly = false OR p.meiVerified = true)
             AND (:q IS NULL OR LOWER(p.name) LIKE LOWER(CONCAT('%', :q, '%'))
                              OR LOWER(p.role) LIKE LOWER(CONCAT('%', :q, '%')))
           ORDER BY p.rating DESC, p.reviewsCount DESC
           """)
    List<Professional> search(@Param("q") String q,
                              @Param("category") String category,
                              @Param("meiOnly") boolean meiOnly);
}
