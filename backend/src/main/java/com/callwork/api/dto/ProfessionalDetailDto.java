package com.callwork.api.dto;

import java.math.BigDecimal;
import java.util.List;

/** Versao completa usada na tela de perfil. */
public record ProfessionalDetailDto(
        Long id,
        String name,
        String role,
        String category,
        String city,
        String about,
        boolean meiVerified,
        BigDecimal rating,
        int reviewsCount,
        List<ServiceDto> services,
        List<ReviewDto> reviews
) {}
