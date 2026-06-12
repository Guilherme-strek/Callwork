package com.callwork.api.service;

import com.callwork.api.dto.*;
import com.callwork.api.exception.NotFoundException;
import com.callwork.api.model.*;
import com.callwork.api.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

@Service
public class CallWorkService {

    private static final Locale PT_BR = Locale.forLanguageTag("pt-BR");

    private final ProfessionalRepository professionals;
    private final ServiceRepository services;
    private final ReviewRepository reviews;
    private final ServiceRequestRepository requests;

    public CallWorkService(ProfessionalRepository professionals,
                           ServiceRepository services,
                           ReviewRepository reviews,
                           ServiceRequestRepository requests) {
        this.professionals = professionals;
        this.services = services;
        this.reviews = reviews;
        this.requests = requests;
    }

    /* ---------- busca / listagem ---------- */

    @Transactional(readOnly = true)
    public List<ProfessionalSummaryDto> search(String q, String category, boolean meiOnly) {
        String cat = (category == null || category.isBlank() || category.equalsIgnoreCase("Todos"))
                ? null : category;
        String query = (q == null || q.isBlank()) ? null : q;
        return professionals.search(query, cat, meiOnly).stream()
                .map(this::toSummary)
                .toList();
    }

    /* ---------- detalhe ---------- */

    @Transactional(readOnly = true)
    public ProfessionalDetailDto getById(Long id) {
        Professional p = professionals.findById(id)
                .orElseThrow(() -> new NotFoundException("Profissional " + id + " nao encontrado"));

        List<ServiceDto> svc = services.findByProfessionalId(id).stream()
                .map(s -> new ServiceDto(s.getId(), s.getTitle(), formatPrice(s.getPriceCents()), s.isActive()))
                .toList();

        List<ReviewDto> rev = reviews.findByProfessionalIdOrderByCreatedAtDesc(id).stream()
                .map(r -> new ReviewDto(r.getId(), r.getAuthor(), r.getRating(), r.getComment(), r.getCreatedAt()))
                .toList();

        return new ProfessionalDetailDto(
                p.getId(), p.getName(), p.getRole(), p.getCategory(), p.getCity(),
                p.getAbout(), p.isMeiVerified(), p.getRating(), p.getReviewsCount(), svc, rev
        );
    }

    /* ---------- cadastro de profissional ---------- */

    @Transactional
    public ProfessionalDetailDto create(CreateProfessionalRequest req) {
        boolean meiVerified = req.cnpj() != null && !req.cnpj().isBlank();
        Professional p = Professional.builder()
                .name(req.name())
                .role(req.role())
                .category(req.category())
                .city(req.city())
                .about(req.about())
                .cnpj(meiVerified ? req.cnpj() : null)
                .meiVerified(meiVerified)
                .rating(BigDecimal.ZERO)
                .reviewsCount(0)
                .build();
        Professional saved = professionals.save(p);
        return getById(saved.getId());
    }

    /* ---------- solicitacoes de servico ---------- */

    @Transactional
    public ServiceRequestDto requestService(Long professionalId, CreateServiceRequestPayload payload) {
        Professional p = professionals.findById(professionalId)
                .orElseThrow(() -> new NotFoundException("Profissional " + professionalId + " nao encontrado"));
        ServiceRequest sr = ServiceRequest.builder()
                .professional(p)
                .requesterName(payload.requesterName())
                .serviceTitle(payload.serviceTitle())
                .message(payload.message())
                .status(ServiceRequest.Status.PENDING)
                .build();
        return toDto(requests.save(sr));
    }

    @Transactional(readOnly = true)
    public List<ServiceRequestDto> listRequests(Long professionalId) {
        return requests.findByProfessionalIdOrderByCreatedAtDesc(professionalId).stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional
    public ServiceRequestDto updateRequestStatus(Long requestId, ServiceRequest.Status status) {
        ServiceRequest sr = requests.findById(requestId)
                .orElseThrow(() -> new NotFoundException("Solicitacao " + requestId + " nao encontrada"));
        sr.setStatus(status);
        return toDto(requests.save(sr));
    }

    /* ---------- helpers ---------- */

    private ProfessionalSummaryDto toSummary(Professional p) {
        Integer min = services.findByProfessionalId(p.getId()).stream()
                .filter(s -> s.isActive())
                .map(s -> s.getPriceCents())
                .min(Integer::compareTo)
                .orElse(null);
        return new ProfessionalSummaryDto(
                p.getId(), p.getName(), p.getRole(), p.getCategory(), p.getCity(),
                p.isMeiVerified(), p.getRating(), p.getReviewsCount(),
                min == null ? null : formatPrice(min)
        );
    }

    private ServiceRequestDto toDto(ServiceRequest sr) {
        return new ServiceRequestDto(
                sr.getId(), sr.getProfessional().getId(), sr.getRequesterName(),
                sr.getServiceTitle(), sr.getMessage(), sr.getStatus().name(), sr.getCreatedAt()
        );
    }

    private String formatPrice(int cents) {
        NumberFormat nf = NumberFormat.getCurrencyInstance(PT_BR);
        return nf.format(cents / 100.0);
    }
}
