-- V3__resource_categories_and_others.sql

CREATE TABLE IF NOT EXISTS resource_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT UNIQUE NOT NULL,
  label_ar TEXT,
  label_en TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Example categories: lectures, summaries, references, exams, videos, others
INSERT INTO resource_categories (key, label_ar, label_en)
VALUES
('lectures','محاضرات','Lectures'),
('summaries','ملخصات','Summaries'),
('references','مراجع','References'),
('exams','الاختبارات','Exams'),
('videos','فيديوهات تعليمية','Educational Videos'),
('others','مصادر اخرى','Other Resources')
ON CONFLICT (key) DO NOTHING;
