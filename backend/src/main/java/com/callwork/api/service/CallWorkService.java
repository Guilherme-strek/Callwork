package com.callwork.api.service;

import com.callwork.api.dto.*;
import com.callwork.api.exception.NotFoundException;
import com.callwork.api.model.Professional;
import com.callwork.api.model.Service;
import com.callwork.api.model.ServiceRequest;
import com.callwork.api.model.Customer;
import com.callwork.api.repository.*;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

@org.springframework.stereotype.Service
public class CallWorkService {

    private static final Locale PT_BR = Locale.forLanguageTag("pt-BR");
    private static final PasswordEncoder PASSWORD_ENCODER = new BCryptPasswordEncoder();

    private final ProfessionalRepository professionals;
    private final CustomerRepository customers;
    private final ServiceRepository services;
    private final ReviewRepository reviews;
    private final ServiceRequestRepository requests;

    public CallWorkService(ProfessionalRepository professionals,
                           CustomerRepository customers,
                           ServiceRepository services,
                           ReviewRepository reviews,
                           ServiceRequestRepository requests) {
        this.professionals = professionals;
        this.customers = customers;
        this.services = services;
        this.reviews = reviews;
        this.requests = requests;
    }

    /* ---------- busca / listagem ---------- */

    @Transactional(readOnly = true)
    public List<ProfessionalSummaryDto> search(String q, String category, boolean meiOnly) {
        String cat = (category == null || category.isBlank() || category.equalsIgnoreCase("Todos"))
                ? null : category;
        String query = (q == null || q.isBlank()) ? null : q.toLowerCase(Locale.ROOT);
        return professionals.findAll(Sort.by(Sort.Direction.DESC, "rating", "reviewsCount")).stream()
                .filter(p -> cat == null || p.getCategory().equals(cat))
                .filter(p -> !meiOnly || p.isMeiVerified())
                .filter(p -> query == null
                        || p.getName().toLowerCase(Locale.ROOT).contains(query)
                        || p.getRole().toLowerCase(Locale.ROOT).contains(query))
                .map(this::toSummary)
                .toList();
    }

    /* ---------- detalhe ---------- */

    @Transactional(readOnly = true)
    public ProfessionalDetailDto getById(Long id) {
        Professional p = professionals.findById(id)
                .orElseThrow(() -> new NotFoundException("Profissional " + id + " nao encontrado"));

        List<ServiceDto> svc = services.findByProfessionalId(id).stream()
                .map(this::toServiceDto)
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
        String email = normalizeEmail(req.email());
        if (professionals.existsByEmailIgnoreCase(email) || customers.existsByEmailIgnoreCase(email)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email ja cadastrado.");
        }

        boolean meiVerified = req.cnpj() != null && !req.cnpj().isBlank();
        Professional p = Professional.builder()
                .name(req.name())
                .email(email)
                .passwordHash(PASSWORD_ENCODER.encode(req.password()))
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

    @Transactional(readOnly = true)
    public LoginResponse login(LoginRequest req) {
        String email = normalizeEmail(req.email());

        var professional = professionals.findByEmailIgnoreCase(email);
        if (professional.isPresent()) {
            Professional p = professional.get();
            if (p.getPasswordHash() == null || !PASSWORD_ENCODER.matches(req.password(), p.getPasswordHash())) {
                throw invalidCredentials();
            }
            return new LoginResponse(
                    "Login realizado com sucesso.",
                    "PROFESSIONAL",
                    new AuthProfessionalDto(p.getId(), p.getName(), p.getEmail()),
                    null
            );
        }

        Customer c = customers.findByEmailIgnoreCase(email)
                .orElseThrow(() -> invalidCredentials());
        if (!PASSWORD_ENCODER.matches(req.password(), c.getPasswordHash())) {
            throw invalidCredentials();
        }
        return new LoginResponse(
                "Login realizado com sucesso.",
                "CUSTOMER",
                null,
                new AuthCustomerDto(c.getId(), c.getName(), c.getEmail())
        );
    }

    @Transactional
    public LoginResponse createCustomer(CreateCustomerRequest req) {
        String email = normalizeEmail(req.email());
        if (professionals.existsByEmailIgnoreCase(email) || customers.existsByEmailIgnoreCase(email)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email ja cadastrado.");
        }

        Customer c = new Customer();
        c.setName(req.name());
        c.setEmail(email);
        c.setPasswordHash(PASSWORD_ENCODER.encode(req.password()));
        Customer saved = customers.save(c);

        return new LoginResponse(
                "Conta criada com sucesso.",
                "CUSTOMER",
                null,
                new AuthCustomerDto(saved.getId(), saved.getName(), saved.getEmail())
        );
    }

    /* ---------- solicitacoes de servico ---------- */

    @Transactional
    public ServiceRequestDto requestService(Long professionalId, Long requesterCustomerId, CreateServiceRequestPayload payload) {
        Professional p = professionals.findById(professionalId)
                .orElseThrow(() -> new NotFoundException("Profissional " + professionalId + " nao encontrado"));
        Customer requester = customers.findById(requesterCustomerId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Sessao de cliente invalida."));
        ServiceRequest sr = ServiceRequest.builder()
                .professional(p)
                .requesterCustomer(requester)
                .requesterName(requester.getName())
                .serviceTitle(payload.serviceTitle())
                .message(payload.message())
                .status(ServiceRequest.Status.PENDING)
                .build();
        return toDto(requests.save(sr));
    }

    @Transactional(readOnly = true)
    public List<ServiceRequestDto> listCustomerRequests(Long customerId, Long actorCustomerId) {
        ensureSameCustomer(customerId, actorCustomerId);
        return requests.findByRequesterCustomerIdOrderByCreatedAtDesc(customerId).stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional
    public ServiceRequestDto payRequest(Long customerId, Long actorCustomerId, Long requestId, String method) {
        ensureSameCustomer(customerId, actorCustomerId);
        ServiceRequest sr = requests.findById(requestId)
                .orElseThrow(() -> new NotFoundException("Solicitacao " + requestId + " nao encontrada"));
        if (sr.getRequesterCustomer() == null || !customerId.equals(sr.getRequesterCustomer().getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Este pedido nao pertence ao cliente logado.");
        }
        if (sr.getStatus() != ServiceRequest.Status.CONFIRMED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "O pedido precisa estar confirmado para pagamento.");
        }
        sr.setPaymentStatus(ServiceRequest.PaymentStatus.PAID);
        sr.setPaymentMethod(method == null || method.isBlank() ? "PIX" : method);
        return toDto(requests.save(sr));
    }

    @Transactional(readOnly = true)
    public List<ServiceRequestDto> listRequests(Long professionalId, Long actorProfessionalId) {
        ensureSameProfessional(professionalId, actorProfessionalId);
        return requests.findByProfessionalIdOrderByCreatedAtDesc(professionalId).stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<ServiceDto> listServices(Long professionalId, Long actorProfessionalId) {
        ensureSameProfessional(professionalId, actorProfessionalId);
        ensureProfessionalExists(professionalId);
        return services.findByProfessionalId(professionalId).stream()
                .map(this::toServiceDto)
                .toList();
    }

    @Transactional
    public ServiceDto createService(Long professionalId, Long actorProfessionalId, UpsertServiceRequest payload) {
        ensureSameProfessional(professionalId, actorProfessionalId);
        Professional p = professionals.findById(professionalId)
                .orElseThrow(() -> new NotFoundException("Profissional " + professionalId + " nao encontrado"));
        Service s = new Service();
        s.setProfessional(p);
        s.setTitle(payload.title());
        s.setPriceCents(payload.priceCents());
        s.setActive(payload.active());
        return toServiceDto(services.save(s));
    }

    @Transactional
    public ServiceDto updateService(Long professionalId, Long actorProfessionalId, Long serviceId, UpsertServiceRequest payload) {
        ensureSameProfessional(professionalId, actorProfessionalId);
        Service s = services.findById(serviceId)
                .orElseThrow(() -> new NotFoundException("Servico " + serviceId + " nao encontrado"));
        if (!s.getProfessional().getId().equals(professionalId)) {
            throw new NotFoundException("Servico " + serviceId + " nao encontrado para este profissional");
        }
        s.setTitle(payload.title());
        s.setPriceCents(payload.priceCents());
        s.setActive(payload.active());
        return toServiceDto(services.save(s));
    }

    @Transactional
    public void deleteService(Long professionalId, Long actorProfessionalId, Long serviceId) {
        ensureSameProfessional(professionalId, actorProfessionalId);
        Service s = services.findById(serviceId)
                .orElseThrow(() -> new NotFoundException("Servico " + serviceId + " nao encontrado"));
        if (!s.getProfessional().getId().equals(professionalId)) {
            throw new NotFoundException("Servico " + serviceId + " nao encontrado para este profissional");
        }
        services.delete(s);
    }

    @Transactional
    public ServiceRequestDto updateRequestStatus(Long requestId, Long actorProfessionalId, ServiceRequest.Status status) {
        ServiceRequest sr = requests.findById(requestId)
                .orElseThrow(() -> new NotFoundException("Solicitacao " + requestId + " nao encontrada"));
        ensureSameProfessional(sr.getProfessional().getId(), actorProfessionalId);
        sr.setStatus(status);
        return toDto(requests.save(sr));
    }

    /* ---------- helpers ---------- */

    private ProfessionalSummaryDto toSummary(Professional p) {
        Integer min = services.findByProfessionalId(p.getId()).stream()
                .filter(Service::isActive)
                .map(Service::getPriceCents)
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
                sr.getId(), sr.getProfessional().getId(),
                sr.getRequesterCustomer() == null ? null : sr.getRequesterCustomer().getId(),
                sr.getRequesterName(), sr.getServiceTitle(), sr.getMessage(), sr.getStatus().name(),
                sr.getPaymentStatus().name(), sr.getPaymentMethod(), sr.getCreatedAt()
        );
    }

    private ServiceDto toServiceDto(Service s) {
        return new ServiceDto(s.getId(), s.getTitle(), formatPrice(s.getPriceCents()), s.getPriceCents(), s.isActive());
    }

    private void ensureProfessionalExists(Long professionalId) {
        if (!professionals.existsById(professionalId)) {
            throw new NotFoundException("Profissional " + professionalId + " nao encontrado");
        }
    }

    private void ensureSameProfessional(Long expectedId, Long actorId) {
        if (actorId == null || !expectedId.equals(actorId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Acesso negado para este painel.");
        }
    }

    private void ensureSameCustomer(Long expectedId, Long actorId) {
        if (actorId == null || !expectedId.equals(actorId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Acesso negado para estes pedidos.");
        }
    }

    private String normalizeEmail(String email) {
        return email == null ? "" : email.trim().toLowerCase(Locale.ROOT);
    }

    private ResponseStatusException invalidCredentials() {
        return new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Email ou senha invalidos.");
    }

    private String formatPrice(int cents) {
        NumberFormat nf = NumberFormat.getCurrencyInstance(PT_BR);
        return nf.format(cents / 100.0);
    }
}
