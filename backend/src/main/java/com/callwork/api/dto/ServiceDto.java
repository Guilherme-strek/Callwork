package com.callwork.api.dto;

/** Servico com preco formatado e em centavos para exibicao e edicao no front. */
public record ServiceDto(Long id, String title, String price, Integer priceCents, boolean active) {}
