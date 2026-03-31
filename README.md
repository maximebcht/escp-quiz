# ESCP Quiz – Interactive Revision Platform

A dark-mode quiz platform built with **Next.js**, **Supabase**, and **Tailwind CSS**, designed for ESCP Business School students.

## Features

- 🔐 **Auth with email whitelist** – Only pre-authorized emails can register
- 📝 **Interactive quizzes** – Full course quiz + per-lecture practice mode
- 📊 **Score tracking** – Per-user history and progression
- 👑 **Admin panel** – Manage authorized emails, view user stats, toggle quizzes
- 🌙 **Dark mode** – Polished study-app aesthetic
- 📱 **Responsive** – Works great on mobile
- 🔄 **Multi-subject ready** – Add new subjects easily

---

## Deployment Guide (Step by Step)

### Step 1: Create a Supabase project

1. Go to [supabase.com](https://supabase.com) and sign up (free)
2. Click **"New Project"**
3. Name it (e.g. `escp-quiz`), set a database password, choose a region
4. Wait for the project to be created (~1 min)

### Step 2: Set up the database

1. In your Supabase dashboard, go to **SQL Editor**
2. Click **"New Query"**
3. Copy-paste the entire contents of `supabase/schema.sql` and click **Run**
4. Then create another query, copy-paste `supabase/seed-ac11.sql` and click **Run**
5. Your database is now ready with tables + the 100-question AC11 quiz!

### Step 3: Configure authentication

1. In Supabase, go to **Authentication > Providers**
2. Make sure **Email** is enabled
3. Go to **Authentication > URL Configuration**
4. Set the **Site URL** to your Vercel URL (you'll update this after deploying)

### Step 4: Make yourself admin

1. Go to **SQL Editor** and run:
```sql
-- First, add your email to the whitelist
INSERT INTO allowed_emails (email) VALUES ('your.email@edu.escp.eu');

-- After you've registered on the site, make yourself admin:
UPDATE profiles SET is_admin = true WHERE email = 'your.email@edu.escp.eu';
```

### Step 5: Get your Supabase API keys

1. Go to **Settings > API** in your Supabase dashboard
2. Copy the **Project URL** (looks like `https://xxxxx.supabase.co`)
3. Copy the **anon/public** key

### Step 6: Deploy to Vercel

1. Push this code to a **GitHub repository**:
   ```bash
   cd escp-quiz
   git init
   git add .
   git commit -m "Initial commit"
   # Create a repo on github.com, then:
   git remote add origin https://github.com/YOUR_USERNAME/escp-quiz.git
   git branch -M main
   git push -u origin main
   ```

2. Go to [vercel.com](https://vercel.com) and sign up with GitHub
3. Click **"Add New" > Project**
4. Import your `escp-quiz` repository
5. In **Environment Variables**, add:
   - `NEXT_PUBLIC_SUPABASE_URL` = your Supabase project URL
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` = your Supabase anon key
6. Click **Deploy**
7. Your site will be live at `https://escp-quiz-xxxxx.vercel.app` (you can rename it in Vercel settings)

### Step 7: Update Supabase auth URL

1. Go back to Supabase **Authentication > URL Configuration**
2. Set **Site URL** to your Vercel URL (e.g. `https://your-site.vercel.app`)
3. Add `https://your-site.vercel.app/auth/login` to **Redirect URLs**

### Step 8: Register and test

1. Visit your deployed site
2. Add your email to `allowed_emails` (Step 4 above, if not done)
3. Sign up on the site
4. Make yourself admin (Step 4 above)
5. Go to Admin Panel and start adding classmates' emails!

---

## Adding Classmates

1. Log in as admin
2. Go to **Admin Panel > Users**
3. Enter each classmate's email and click **Add Email**
4. They can now register on the site with that email

## Project Structure

```
escp-quiz/
├── app/
│   ├── layout.tsx          # Root layout
│   ├── page.tsx            # Landing page
│   ├── globals.css         # Global styles
│   ├── auth/
│   │   ├── login/page.tsx  # Login page
│   │   └── register/page.tsx # Register page
│   ├── dashboard/page.tsx  # Main dashboard
│   ├── quiz/[quizId]/page.tsx # Quiz interface
│   └── admin/
│       ├── users/page.tsx  # Admin: manage users
│       └── quizzes/page.tsx # Admin: manage quizzes
├── components/             # Shared components (future)
├── lib/
│   ├── supabase-browser.ts # Supabase client (browser)
│   ├── supabase-server.ts  # Supabase client (server)
│   └── types.ts            # TypeScript types
├── middleware.ts            # Auth route protection
├── supabase/
│   ├── schema.sql          # Database schema
│   └── seed-ac11.sql       # AC11 quiz data (100 questions)
└── package.json
```

## Adding New Quizzes

To add a new quiz, generate a SQL insert with the quiz data and run it in the Supabase SQL Editor. The format is:

```sql
DO $$
DECLARE v_subject_id UUID; v_quiz_id UUID;
BEGIN
  SELECT id INTO v_subject_id FROM subjects WHERE code = 'AC11';
  
  INSERT INTO quizzes (id, subject_id, title, description, lecture_tag, question_count, is_active)
  VALUES (gen_random_uuid(), v_subject_id, 'Quiz Title', 'Description', 'Lecture X', 25, true)
  RETURNING id INTO v_quiz_id;
  
  INSERT INTO questions (quiz_id, question_text, options, correct_index, explanation, lecture_tag, sort_order)
  VALUES (v_quiz_id, 'Question text?', '["A","B","C","D"]'::jsonb, 0, 'Explanation', 'Lecture X', 1);
  -- ... more questions
END $$;
```

## Adding New Subjects

```sql
INSERT INTO subjects (name, code, description, color)
VALUES ('New Subject Name', 'CODE', 'Description', '#hexcolor');
```

---

Built with ❤️ for ESCP revision
