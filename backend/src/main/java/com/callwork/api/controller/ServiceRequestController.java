package com.callwork.api.controller;

import com.callwork.api.dto.ServiceRequestDto;
import com.callwork.api.model.ServiceRequest;
import com.callwork.api.service.CallWorkService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/requests")
public class ServiceRequestController {

    private final CallWorkService service;

    public ServiceRequestController(CallWorkService service) {
        this.service = service;
    }

    /** Atualiza o status: PATCH /api/requests/{id}/status?value=CONFIRMED|DECLINED */
    @PatchMapping("/{id}/status")
    public ServiceRequestDto updateStatus(@PathVariable Long id,
                                          @RequestHeader("X-Professional-Id") Long actorProfessionalId,
                                          @RequestParam("value") ServiceRequest.Status value) {
        return service.updateRequestStatus(id, actorProfessionalId, value);
    }
}
