package com.callwork.api.dto;

import jakarta.validation.constraints.NotBlank;

/** Payload de uma solicitacao de servico feita por uma empresa. */
public record CreateServiceRequestPayload(
        @NotBlank String requesterName,
        @NotBlank String serviceTitle,
        String message
) {}
