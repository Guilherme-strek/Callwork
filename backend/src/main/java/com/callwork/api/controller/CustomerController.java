package com.callwork.api.controller;

import com.callwork.api.dto.CreateCustomerRequest;
import com.callwork.api.dto.LoginResponse;
import com.callwork.api.dto.ServiceRequestDto;
import com.callwork.api.service.CallWorkService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/customers")
public class CustomerController {

    private final CallWorkService service;

    public CustomerController(CallWorkService service) {
        this.service = service;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public LoginResponse create(@Valid @RequestBody CreateCustomerRequest request) {
        return service.createCustomer(request);
    }

    @GetMapping("/{id}/requests")
    public List<ServiceRequestDto> listRequests(@PathVariable Long id,
                                                @RequestHeader("X-Customer-Id") Long actorCustomerId) {
        return service.listCustomerRequests(id, actorCustomerId);
    }

    @PatchMapping("/{customerId}/requests/{requestId}/payment")
    public ServiceRequestDto pay(@PathVariable Long customerId,
                                 @PathVariable Long requestId,
                                 @RequestHeader("X-Customer-Id") Long actorCustomerId,
                                 @RequestParam(defaultValue = "PIX") String method) {
        return service.payRequest(customerId, actorCustomerId, requestId, method);
    }
}
