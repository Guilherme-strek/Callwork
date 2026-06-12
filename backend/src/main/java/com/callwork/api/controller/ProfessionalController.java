package com.callwork.api.controller;

import com.callwork.api.dto.*;
import com.callwork.api.service.CallWorkService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/professionals")
public class ProfessionalController {

    private final CallWorkService service;

    public ProfessionalController(CallWorkService service) {
        this.service = service;
    }

    /** Busca/listagem com filtros opcionais: /api/professionals?q=&category=&meiOnly= */
    @GetMapping
    public List<ProfessionalSummaryDto> search(
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String category,
            @RequestParam(defaultValue = "false") boolean meiOnly) {
        return service.search(q, category, meiOnly);
    }

    @GetMapping("/{id}")
    public ProfessionalDetailDto getById(@PathVariable Long id) {
        return service.getById(id);
    }

    @PostMapping
    public ResponseEntity<ProfessionalDetailDto> create(@Valid @RequestBody CreateProfessionalRequest req) {
        ProfessionalDetailDto created = service.create(req);
        return ResponseEntity
                .created(URI.create("/api/professionals/" + created.id()))
                .body(created);
    }

    /** Solicitacao de servico para um profissional. */
    @PostMapping("/{id}/requests")
    @ResponseStatus(HttpStatus.CREATED)
    public ServiceRequestDto requestService(@PathVariable Long id,
                                            @RequestHeader("X-Customer-Id") Long requesterCustomerId,
                                            @Valid @RequestBody CreateServiceRequestPayload payload) {
        return service.requestService(id, requesterCustomerId, payload);
    }

    /** Pedidos recebidos por um profissional (usado no painel). */
    @GetMapping("/{id}/requests")
    public List<ServiceRequestDto> listRequests(@PathVariable Long id,
                                                @RequestHeader("X-Professional-Id") Long actorProfessionalId) {
        return service.listRequests(id, actorProfessionalId);
    }

    @GetMapping("/{id}/services")
    public List<ServiceDto> listServices(@PathVariable Long id,
                                         @RequestHeader("X-Professional-Id") Long actorProfessionalId) {
        return service.listServices(id, actorProfessionalId);
    }

    @PostMapping("/{id}/services")
    @ResponseStatus(HttpStatus.CREATED)
    public ServiceDto createService(@PathVariable Long id,
                                    @RequestHeader("X-Professional-Id") Long actorProfessionalId,
                                    @Valid @RequestBody UpsertServiceRequest payload) {
        return service.createService(id, actorProfessionalId, payload);
    }

    @PutMapping("/{professionalId}/services/{serviceId}")
    public ServiceDto updateService(@PathVariable Long professionalId,
                                    @PathVariable Long serviceId,
                                    @RequestHeader("X-Professional-Id") Long actorProfessionalId,
                                    @Valid @RequestBody UpsertServiceRequest payload) {
        return service.updateService(professionalId, actorProfessionalId, serviceId, payload);
    }

    @DeleteMapping("/{professionalId}/services/{serviceId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteService(@PathVariable Long professionalId,
                              @RequestHeader("X-Professional-Id") Long actorProfessionalId,
                              @PathVariable Long serviceId) {
        service.deleteService(professionalId, actorProfessionalId, serviceId);
    }
}
