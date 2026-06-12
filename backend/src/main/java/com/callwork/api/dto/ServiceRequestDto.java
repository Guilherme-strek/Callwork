package com.callwork.api.dto;

import java.time.Instant;

public record ServiceRequestDto(
        Long id,
        Long professionalId,
        String requesterName,
        String serviceTitle,
        String message,
        String status,
        Instant createdAt
) {}
