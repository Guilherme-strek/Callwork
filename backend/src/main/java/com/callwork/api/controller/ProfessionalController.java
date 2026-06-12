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
                                            @Valid @RequestBody CreateServiceRequestPayload payload) {
        return service.requestService(id, payload);
    }

    /** Pedidos recebidos por um profissional (usado no painel). */
    @GetMapping("/{id}/requests")
    public List<ServiceRequestDto> listRequests(@PathVariable Long id) {
        return service.listRequests(id);
    }
}
