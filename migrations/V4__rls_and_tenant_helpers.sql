-- V4__rls_and_tenant_helpers.sql

CREATE TABLE IF NOT EXISTS settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NULL,
  key TEXT NOT NULL,
  value JSONB DEFAULT '{}'::jsonb,
  is_overridable BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_settings_tenant_key ON settings (tenant_id, key);

CREATE OR REPLACE FUNCTION app.set_current_tenant(_tenant uuid) RETURNS void AS $$
BEGIN
  PERFORM set_config('app.current_tenant', _tenant::text, true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS policies should be enabled per-table by the deployer using templates provided in docs.
