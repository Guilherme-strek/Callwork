package com.callwork.api.model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "professionals")
public class Professional {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 120)
    private String name;

    @Column(length = 160)
    private String email;

    @Column(name = "password_hash", length = 120)
    private String passwordHash;

    @Column(nullable = false, length = 120)
    private String role;

    @Column(nullable = false, length = 60)
    private String category;

    @Column(nullable = false, length = 120)
    private String city;

    @Column(columnDefinition = "text")
    private String about;

    @Column(length = 18)
    private String cnpj;

    @Column(name = "mei_verified", nullable = false)
    private boolean meiVerified;

    @Column(nullable = false, precision = 2, scale = 1)
    private BigDecimal rating = BigDecimal.ZERO;

    @Column(name = "reviews_count", nullable = false)
    private int reviewsCount;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt = Instant.now();

    @OneToMany(mappedBy = "professional", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Service> services = new ArrayList<>();

    @OneToMany(mappedBy = "professional", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Review> reviews = new ArrayList<>();

    public static Builder builder() {
        return new Builder();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAbout() {
        return about;
    }

    public void setAbout(String about) {
        this.about = about;
    }

    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    public boolean isMeiVerified() {
        return meiVerified;
    }

    public void setMeiVerified(boolean meiVerified) {
        this.meiVerified = meiVerified;
    }

    public BigDecimal getRating() {
        return rating;
    }

    public void setRating(BigDecimal rating) {
        this.rating = rating;
    }

    public int getReviewsCount() {
        return reviewsCount;
    }

    public void setReviewsCount(int reviewsCount) {
        this.reviewsCount = reviewsCount;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public List<Service> getServices() {
        return services;
    }

    public void setServices(List<Service> services) {
        this.services = services;
    }

    public List<Review> getReviews() {
        return reviews;
    }

    public void setReviews(List<Review> reviews) {
        this.reviews = reviews;
    }

    public static class Builder {
        private final Professional professional = new Professional();

        public Builder name(String name) {
            professional.name = name;
            return this;
        }

        public Builder email(String email) {
            professional.email = email;
            return this;
        }

        public Builder passwordHash(String passwordHash) {
            professional.passwordHash = passwordHash;
            return this;
        }

        public Builder role(String role) {
            professional.role = role;
            return this;
        }

        public Builder category(String category) {
            professional.category = category;
            return this;
        }

        public Builder city(String city) {
            professional.city = city;
            return this;
        }

        public Builder about(String about) {
            professional.about = about;
            return this;
        }

        public Builder cnpj(String cnpj) {
            professional.cnpj = cnpj;
            return this;
        }

        public Builder meiVerified(boolean meiVerified) {
            professional.meiVerified = meiVerified;
            return this;
        }

        public Builder rating(BigDecimal rating) {
            professional.rating = rating;
            return this;
        }

        public Builder reviewsCount(int reviewsCount) {
            professional.reviewsCount = reviewsCount;
            return this;
        }

        public Professional build() {
            return professional;
        }
    }
}
