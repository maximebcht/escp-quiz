export interface Profile {
  id: string
  email: string
  full_name: string | null
  is_admin: boolean
  created_at: string
}

export interface Subject {
  id: string
  name: string
  code: string
  description: string | null
  color: string
  created_at: string
}

export interface Quiz {
  id: string
  subject_id: string
  title: string
  description: string | null
  lecture_tag: string | null
  question_count: number
  is_active: boolean
  created_at: string
  subjects?: Subject
}

export interface Question {
  id: string
  quiz_id: string
  question_text: string
  options: string[]
  correct_index: number
  correct_indices: number[] | null  // NEW: for multi-answer questions
  explanation: string | null
  lecture_tag: string | null
  sort_order: number
}

export interface QuizAttempt {
  id: string
  user_id: string
  quiz_id: string
  score: number
  total: number
  percentage: number
  answers: number[] | number[][]  // UPDATED: supports both formats
  started_at: string
  completed_at: string
  quizzes?: Quiz
  profiles?: Profile
}
