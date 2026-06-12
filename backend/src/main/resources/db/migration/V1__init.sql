-- V1: schema inicial do Call Work

CREATE TABLE professionals (
    id           BIGSERIAL PRIMARY KEY,
    name         VARCHAR(120) NOT NULL,
    role         VARCHAR(120) NOT NULL,
    category     VARCHAR(60)  NOT NULL,
    city         VARCHAR(120) NOT NULL,
    about        TEXT,
    cnpj         VARCHAR(18),                 -- formato 00.000.000/0000-00; nulo = autonomo sem MEI
    mei_verified BOOLEAN      NOT NULL DEFAULT FALSE,
    rating       NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    reviews_count INTEGER     NOT NULL DEFAULT 0,
    created_at   TIMESTAMP    NOT NULL DEFAULT now()
);

CREATE INDEX idx_professionals_category ON professionals(category);
CREATE INDEX idx_professionals_city     ON professionals(city);

CREATE TABLE services (
    id              BIGSERIAL PRIMARY KEY,
    professional_id BIGINT       NOT NULL REFERENCES professionals(id) ON DELETE CASCADE,
    title           VARCHAR(140) NOT NULL,
    price_cents     INTEGER      NOT NULL,    -- preco em centavos para evitar erro de ponto flutuante
    active          BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE INDEX idx_services_professional ON services(professional_id);

CREATE TABLE reviews (
    id              BIGSERIAL PRIMARY KEY,
    professional_id BIGINT       NOT NULL REFERENCES professionals(id) ON DELETE CASCADE,
    author          VARCHAR(120) NOT NULL,
    rating          SMALLINT     NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT,
    created_at      TIMESTAMP    NOT NULL DEFAULT now()
);

CREATE INDEX idx_reviews_professional ON reviews(professional_id);

CREATE TABLE service_requests (
    id              BIGSERIAL PRIMARY KEY,
    professional_id BIGINT       NOT NULL REFERENCES professionals(id) ON DELETE CASCADE,
    requester_name  VARCHAR(120) NOT NULL,
    service_title   VARCHAR(140) NOT NULL,
    message         TEXT,
    status          VARCHAR(20)  NOT NULL DEFAULT 'PENDING',  -- PENDING | CONFIRMED | DECLINED
    created_at      TIMESTAMP    NOT NULL DEFAULT now()
);

CREATE INDEX idx_requests_professional ON service_requests(professional_id);
CREATE INDEX idx_requests_status       ON service_requests(status);
