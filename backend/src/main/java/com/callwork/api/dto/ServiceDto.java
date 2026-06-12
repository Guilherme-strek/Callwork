package com.callwork.api.dto;

/** Servico com preco ja formatado em reais para o front. */
public record ServiceDto(Long id, String title, String price, boolean active) {}
