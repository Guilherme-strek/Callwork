package com.callwork.api.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;

/** Payload do cadastro de profissional. */
public record CreateProfessionalRequest(
        @NotBlank String name,
        @NotBlank @Email String email,
        @NotBlank @Size(min = 6, message = "Senha deve ter pelo menos 6 caracteres") String password,
        @NotBlank String role,
        @NotBlank String category,
        @NotBlank String city,
        String about,
        @Pattern(
            regexp = "^$|\\d{2}\\.\\d{3}\\.\\d{3}/\\d{4}-\\d{2}",
            message = "CNPJ deve estar no formato 00.000.000/0000-00"
        )
        String cnpj
) {}
