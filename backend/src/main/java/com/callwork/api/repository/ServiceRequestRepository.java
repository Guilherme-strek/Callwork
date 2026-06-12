package com.callwork.api.repository;

import com.callwork.api.model.ServiceRequest;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ServiceRequestRepository extends JpaRepository<ServiceRequest, Long> {
    List<ServiceRequest> findByProfessionalIdOrderByCreatedAtDesc(Long professionalId);
}
