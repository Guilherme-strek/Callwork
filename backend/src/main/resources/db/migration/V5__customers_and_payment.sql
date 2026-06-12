-- V5: contas de cliente e pagamento de solicitacoes

CREATE TABLE IF NOT EXISTS customers (
    id            BIGSERIAL PRIMARY KEY,
    name          VARCHAR(120) NOT NULL,
    email         VARCHAR(160) NOT NULL UNIQUE,
    password_hash VARCHAR(120) NOT NULL,
    created_at    TIMESTAMP NOT NULL DEFAULT now()
);

ALTER TABLE service_requests ADD COLUMN IF NOT EXISTS requester_customer_id BIGINT REFERENCES customers(id);
ALTER TABLE service_requests ADD COLUMN IF NOT EXISTS payment_status VARCHAR(20) NOT NULL DEFAULT 'WAITING_PAYMENT';
ALTER TABLE service_requests ADD COLUMN IF NOT EXISTS payment_method VARCHAR(40);
