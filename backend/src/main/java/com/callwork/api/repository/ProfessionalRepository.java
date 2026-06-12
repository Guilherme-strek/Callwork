package com.callwork.api.repository;

import com.callwork.api.model.Professional;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ProfessionalRepository extends JpaRepository<Professional, Long> {
    Optional<Professional> findByEmailIgnoreCase(String email);
    boolean existsByEmailIgnoreCase(String email);
}
