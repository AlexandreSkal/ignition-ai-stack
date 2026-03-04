-- ============================================================
-- Init DB for Ignition Stack
-- Runs automatically on first Postgres start
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS app;
CREATE SCHEMA IF NOT EXISTS history;

COMMENT ON SCHEMA app IS 'Schema for Ignition application data';
COMMENT ON SCHEMA history IS 'Schema for custom historical data';
