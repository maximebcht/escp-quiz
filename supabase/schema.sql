-- ============================================
-- ESCP Quiz Platform - Supabase Schema
-- Run this in Supabase SQL Editor
-- ============================================

-- 1. Allowed emails (whitelist)
CREATE TABLE allowed_emails (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  added_at TIMESTAMPTZ DEFAULT now()
);

-- 2. User profiles (extends Supabase auth.users)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  is_admin BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Subjects (multi-subject support)
CREATE TABLE subjects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  code TEXT UNIQUE NOT NULL, -- e.g. 'AC11'
  description TEXT,
  color TEXT DEFAULT '#4d8ce8', -- UI accent color
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 4. Quizzes
CREATE TABLE quizzes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  subject_id UUID REFERENCES subjects(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  lecture_tag TEXT, -- e.g. 'Lecture 3' or 'Full Course'
  question_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Questions
CREATE TABLE questions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  quiz_id UUID REFERENCES quizzes(id) ON DELETE CASCADE NOT NULL,
  question_text TEXT NOT NULL,
  options JSONB NOT NULL, -- ["option A", "option B", "option C", "option D"]
  correct_index INTEGER NOT NULL, -- 0-based index
  explanation TEXT,
  lecture_tag TEXT, -- for filtering within a quiz
  sort_order INTEGER DEFAULT 0
);

-- 6. Quiz attempts (score tracking)
CREATE TABLE quiz_attempts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  quiz_id UUID REFERENCES quizzes(id) ON DELETE CASCADE NOT NULL,
  score INTEGER NOT NULL,
  total INTEGER NOT NULL,
  percentage NUMERIC(5,2) NOT NULL,
  answers JSONB, -- user's answers array
  started_at TIMESTAMPTZ DEFAULT now(),
  completed_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE allowed_emails ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts ENABLE ROW LEVEL SECURITY;

-- Allowed emails: only admins can read/write
CREATE POLICY "Admins manage allowed_emails" ON allowed_emails
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true)
  );

-- Profiles: users can read own, admins can read all
CREATE POLICY "Users read own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Admins read all profiles" ON profiles
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true)
  );
CREATE POLICY "Users insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Subjects: all authenticated users can read
CREATE POLICY "Authenticated read subjects" ON subjects
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins manage subjects" ON subjects
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true)
  );

-- Quizzes: all authenticated users can read active quizzes
CREATE POLICY "Authenticated read active quizzes" ON quizzes
  FOR SELECT USING (auth.role() = 'authenticated' AND is_active = true);
CREATE POLICY "Admins manage quizzes" ON quizzes
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true)
  );

-- Questions: all authenticated users can read
CREATE POLICY "Authenticated read questions" ON questions
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins manage questions" ON questions
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true)
  );

-- Quiz attempts: users manage own, admins read all
CREATE POLICY "Users manage own attempts" ON quiz_attempts
  FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Admins read all attempts" ON quiz_attempts
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true)
  );

-- ============================================
-- FUNCTION: Check if email is allowed before signup
-- ============================================
CREATE OR REPLACE FUNCTION public.check_allowed_email()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.allowed_emails WHERE email = NEW.email) THEN
    RAISE EXCEPTION 'Email not authorized. Contact admin for access.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger on auth.users (signup check)
CREATE TRIGGER check_email_on_signup
  BEFORE INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.check_allowed_email();

-- ============================================
-- FUNCTION: Auto-create profile on signup
-- ============================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- SEED: Insert first subject (AC11)
-- ============================================
INSERT INTO subjects (name, code, description, color)
VALUES ('Managerial Accounting', 'AC11', 'AC11 – Prof. Soudani – ESCP Business School', '#4d8ce8');
