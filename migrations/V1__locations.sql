CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Governorates
CREATE TABLE IF NOT EXISTS governorates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name_ar TEXT NOT NULL,
  name_en TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ,
  deleted_at TIMESTAMPTZ
);

-- Cities
CREATE TABLE IF NOT EXISTS cities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  governorate_id UUID NOT NULL REFERENCES governorates(id) ON DELETE CASCADE,
  name_ar TEXT NOT NULL,
  name_en TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ,
  deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_cities_governorate ON cities(governorate_id);
