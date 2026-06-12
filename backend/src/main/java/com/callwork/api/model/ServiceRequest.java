package com.callwork.api.model;

import jakarta.persistence.*;

import java.time.Instant;

@Entity
@Table(name = "service_requests")
public class ServiceRequest {

    public enum Status { PENDING, CONFIRMED, DECLINED }
    public enum PaymentStatus { WAITING_PAYMENT, PAID }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "professional_id", nullable = false)
    private Professional professional;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "requester_customer_id")
    private Customer requesterCustomer;

    @Column(name = "requester_name", nullable = false, length = 120)
    private String requesterName;

    @Column(name = "service_title", nullable = false, length = 140)
    private String serviceTitle;

    @Column(columnDefinition = "text")
    private String message;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Status status = Status.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false, length = 20)
    private PaymentStatus paymentStatus = PaymentStatus.WAITING_PAYMENT;

    @Column(name = "payment_method", length = 40)
    private String paymentMethod;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt = Instant.now();

    public static Builder builder() {
        return new Builder();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Professional getProfessional() {
        return professional;
    }

    public void setProfessional(Professional professional) {
        this.professional = professional;
    }

    public Customer getRequesterCustomer() {
        return requesterCustomer;
    }

    public void setRequesterCustomer(Customer requesterCustomer) {
        this.requesterCustomer = requesterCustomer;
    }

    public String getRequesterName() {
        return requesterName;
    }

    public void setRequesterName(String requesterName) {
        this.requesterName = requesterName;
    }

    public String getServiceTitle() {
        return serviceTitle;
    }

    public void setServiceTitle(String serviceTitle) {
        this.serviceTitle = serviceTitle;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public static class Builder {
        private final ServiceRequest serviceRequest = new ServiceRequest();

        public Builder professional(Professional professional) {
            serviceRequest.professional = professional;
            return this;
        }

        public Builder requesterName(String requesterName) {
            serviceRequest.requesterName = requesterName;
            return this;
        }

        public Builder requesterCustomer(Customer requesterCustomer) {
            serviceRequest.requesterCustomer = requesterCustomer;
            return this;
        }

        public Builder serviceTitle(String serviceTitle) {
            serviceRequest.serviceTitle = serviceTitle;
            return this;
        }

        public Builder message(String message) {
            serviceRequest.message = message;
            return this;
        }

        public Builder status(Status status) {
            serviceRequest.status = status;
            return this;
        }

        public Builder paymentStatus(PaymentStatus paymentStatus) {
            serviceRequest.paymentStatus = paymentStatus;
            return this;
        }

        public ServiceRequest build() {
            return serviceRequest;
        }
    }
}
