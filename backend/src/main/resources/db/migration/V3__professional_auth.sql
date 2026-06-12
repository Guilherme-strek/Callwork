-- V3: autenticacao simples de profissionais por email e senha

ALTER TABLE professionals ADD COLUMN IF NOT EXISTS email VARCHAR(160);
ALTER TABLE professionals ADD COLUMN IF NOT EXISTS password_hash VARCHAR(120);

CREATE UNIQUE INDEX IF NOT EXISTS idx_professionals_email ON professionals (email);

UPDATE professionals SET
    email = 'ana@callwork.local',
    password_hash = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'
WHERE name = 'Ana Moura' AND email IS NULL;

UPDATE professionals SET
    email = 'carlos@callwork.local',
    password_hash = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'
WHERE name = 'Carlos Reis' AND email IS NULL;

UPDATE professionals SET
    email = 'julia@callwork.local',
    password_hash = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'
WHERE name = 'Julia Souza' AND email IS NULL;

UPDATE professionals SET
    email = 'rosa@callwork.local',
    password_hash = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'
WHERE name = 'Rosa Lima' AND email IS NULL;

UPDATE professionals SET
    email = 'clara@callwork.local',
    password_hash = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'
WHERE name = 'Clara Freitas' AND email IS NULL;
