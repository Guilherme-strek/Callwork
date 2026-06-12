package com.callwork.api.dto;

import java.math.BigDecimal;

/** Versao enxuta usada nas listagens/busca. */
public record ProfessionalSummaryDto(
        Long id,
        String name,
        String role,
        String category,
        String city,
        boolean meiVerified,
        BigDecimal rating,
        int reviewsCount,
        String startingPrice
) {}
