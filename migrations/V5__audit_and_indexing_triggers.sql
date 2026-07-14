-- V5__audit_and_indexing_triggers.sql

CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NULL,
  actor_id UUID NULL,
  action TEXT NOT NULL,
  resource_type TEXT,
  resource_id UUID NULL,
  diff JSONB,
  ip TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_audit_tenant_created ON audit_logs (tenant_id, created_at);
