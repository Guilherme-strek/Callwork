package com.callwork.api.dto;

import java.time.Instant;

public record ReviewDto(Long id, String author, int rating, String comment, Instant createdAt) {}
