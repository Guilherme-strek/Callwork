-- V4: corrige a senha demo para "password"

UPDATE professionals
SET password_hash = '$2a$10$Xf7RgLhX6TqWPIbQlIORa.CW1Z0uSWfvVnM1wy2IAUplPXYhrmomi'
WHERE email IN (
    'ana@callwork.local',
    'carlos@callwork.local',
    'julia@callwork.local',
    'rosa@callwork.local',
    'clara@callwork.local'
);
