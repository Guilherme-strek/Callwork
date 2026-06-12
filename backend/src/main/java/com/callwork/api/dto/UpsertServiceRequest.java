package com.callwork.api.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record UpsertServiceRequest(
        @NotBlank String title,
        @NotNull @Min(1) Integer priceCents,
        boolean active
) {}
