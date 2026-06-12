package com.callwork.api.dto;

public record LoginResponse(
        String message,
        String role,
        AuthProfessionalDto professional,
        AuthCustomerDto customer
) {}
