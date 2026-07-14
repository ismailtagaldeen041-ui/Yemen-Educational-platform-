-- V2__universities_academia.sql

-- Universities
CREATE TABLE IF NOT EXISTS universities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT NOT NULL,
  name_ar TEXT NOT NULL,
  name_en TEXT,
  type TEXT NOT NULL CHECK (type IN ('public','private')),
  governorate_id UUID REFERENCES governorates(id),
  city_id UUID REFERENCES cities(id),
  website TEXT,
  contact JSONB DEFAULT '{}'::jsonb,
  metadata JSONB DEFAULT '{}'::jsonb,
  tenant_id UUID NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ,
  deleted_at TIMESTAMPTZ
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_universities_slug_city ON universities (slug, city_id);

-- Colleges
CREATE TABLE IF NOT EXISTS colleges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  university_id UUID NOT NULL REFERENCES universities(id) ON DELETE CASCADE,
  name_ar TEXT NOT NULL,
  name_en TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ,
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_colleges_univ ON colleges(university_id);

-- Departments
CREATE TABLE IF NOT EXISTS departments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  college_id UUID NOT NULL REFERENCES colleges(id) ON DELETE CASCADE,
  name_ar TEXT NOT NULL,
  name_en TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ,
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_departments_college ON departments(college_id);

-- Programs
CREATE TABLE IF NOT EXISTS programs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  university_id UUID NOT NULL REFERENCES universities(id),
  college_id UUID NOT NULL REFERENCES colleges(id),
  department_id UUID NULL REFERENCES departments(id),
  name_ar TEXT NOT NULL,
  name_en TEXT,
  degree_type TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ,
  deleted_at TIMESTAMPTZ
);

-- Levels
CREATE TABLE IF NOT EXISTS levels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  program_id UUID NOT NULL REFERENCES programs(id) ON DELETE CASCADE,
  level_number INT NOT NULL,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Semesters
CREATE TABLE IF NOT EXISTS semesters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  level_id UUID NOT NULL REFERENCES levels(id) ON DELETE CASCADE,
  name_ar TEXT NOT NULL,
  name_en TEXT,
  sequence INT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Courses
CREATE TABLE IF NOT EXISTS courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  university_id UUID NOT NULL REFERENCES universities(id),
  college_id UUID NOT NULL REFERENCES colleges(id),
  department_id UUID NULL REFERENCES departments(id),
  program_id UUID NOT NULL REFERENCES programs(id),
  level_id UUID NULL REFERENCES levels(id),
  semester_id UUID NULL REFERENCES semesters(id),
  code TEXT,
  title_ar TEXT NOT NULL,
  title_en TEXT,
  credits INT,
  theory_hours INT,
  practical_hours INT,
  description JSONB DEFAULT '{}'::jsonb,
  resource_categories JSONB DEFAULT '[]'::jsonb,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_courses_univ ON courses(university_id);
CREATE INDEX IF NOT EXISTS idx_courses_code_univ ON courses (university_id, code);
