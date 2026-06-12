package com.callwork.api.dto;

import java.time.Instant;

public record ServiceRequestDto(
        Long id,
        Long professionalId,
        Long requesterCustomerId,
        String requesterName,
        String serviceTitle,
        String message,
        String status,
        String paymentStatus,
        String paymentMethod,
        Instant createdAt
) {}
