package com.callwork.api.repository;

import com.callwork.api.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByProfessionalIdOrderByCreatedAtDesc(Long professionalId);
}
