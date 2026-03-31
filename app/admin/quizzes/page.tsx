'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase-browser'
import { useRouter } from 'next/navigation'
import type { Quiz } from '@/lib/types'
import Link from 'next/link'

interface QuizStats {
  quiz_id: string
  attempts: number
  avg_score: number
  best_score: number
}

export default function AdminQuizzesPage() {
  const supabase = createClient()
  const router = useRouter()
  const [loading, setLoading] = useState(true)
  const [quizzes, setQuizzes] = useState<Quiz[]>([])
  const [stats, setStats] = useState<Record<string, QuizStats>>({})

  useEffect(() => {
    loadData()
  }, [])

  async function loadData() {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) { router.push('/auth/login'); return }

    const { data: profile } = await supabase.from('profiles').select('*').eq('id', user.id).single()
    if (!profile?.is_admin) { router.push('/dashboard'); return }

    const [quizzesRes, attemptsRes] = await Promise.all([
      supabase.from('quizzes').select('*, subjects(*)').order('created_at', { ascending: false }),
      supabase.from('quiz_attempts').select('quiz_id, percentage'),
    ])

    setQuizzes(quizzesRes.data || [])

    // Compute per-quiz stats
    const s: Record<string, QuizStats> = {}
    ;(attemptsRes.data || []).forEach((a: any) => {
      if (!s[a.quiz_id]) s[a.quiz_id] = { quiz_id: a.quiz_id, attempts: 0, avg_score: 0, best_score: 0 }
      s[a.quiz_id].attempts++
      s[a.quiz_id].avg_score += a.percentage
      if (a.percentage > s[a.quiz_id].best_score) s[a.quiz_id].best_score = a.percentage
    })
    Object.keys(s).forEach(qid => {
      s[qid].avg_score = Math.round(s[qid].avg_score / s[qid].attempts)
    })
    setStats(s)
    setLoading(false)
  }

  async function toggleQuiz(quizId: string, currentActive: boolean) {
    await supabase.from('quizzes').update({ is_active: !currentActive }).eq('id', quizId)
    setQuizzes(quizzes.map(q => q.id === quizId ? { ...q, is_active: !currentActive } : q))
  }

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-dim animate-pulse">Loading...</div>
    </div>
  )

  return (
    <div className="min-h-screen">
      <header className="border-b border-border bg-surface/50 backdrop-blur-sm sticky top-0 z-10">
        <div className="max-w-5xl mx-auto px-4 py-3 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <Link href="/dashboard" className="text-dim hover:text-accent transition">← Dashboard</Link>
            <span className="font-bold">Admin Panel</span>
          </div>
          <div className="flex gap-3">
            <Link href="/admin/users" className="text-sm font-semibold text-dim hover:text-accent transition">Users</Link>
            <Link href="/admin/quizzes" className="text-sm font-semibold text-accent">Quizzes</Link>
          </div>
        </div>
      </header>

      <main className="max-w-5xl mx-auto px-4 py-8">
        <h1 className="text-xl font-extrabold mb-6 animate-fadeUp">All Quizzes ({quizzes.length})</h1>

        <div className="space-y-3 animate-fadeUp">
          {quizzes.map(quiz => {
            const s = stats[quiz.id]
            const subject = (quiz as any).subjects
            return (
              <div key={quiz.id} className="bg-surface border border-border rounded-xl p-5">
                <div className="flex items-start justify-between flex-wrap gap-3">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1 flex-wrap">
                      <h3 className="font-bold">{quiz.title}</h3>
                      {quiz.lecture_tag && (
                        <span className="text-xs text-accent bg-accent-glow px-2 py-0.5 rounded-full">{quiz.lecture_tag}</span>
                      )}
                      <span className={`text-xs px-2 py-0.5 rounded-full font-semibold ${
                        quiz.is_active ? 'bg-ok-bg text-ok' : 'bg-no-bg text-no'
                      }`}>
                        {quiz.is_active ? 'Active' : 'Hidden'}
                      </span>
                    </div>
                    {subject && (
                      <p className="text-xs text-dim2">{subject.code} – {subject.name}</p>
                    )}
                    <p className="text-sm text-dim mt-1">{quiz.question_count} questions</p>
                  </div>

                  <div className="flex items-center gap-4">
                    {s ? (
                      <div className="flex gap-4 text-center">
                        <div>
                          <div className="text-lg font-bold">{s.attempts}</div>
                          <div className="text-xs text-dim2">Attempts</div>
                        </div>
                        <div>
                          <div className="text-lg font-bold" style={{
                            color: s.avg_score >= 70 ? '#34d399' : s.avg_score >= 50 ? '#f6c547' : '#ef6b6b'
                          }}>{s.avg_score}%</div>
                          <div className="text-xs text-dim2">Avg</div>
                        </div>
                        <div>
                          <div className="text-lg font-bold text-accent">{Math.round(s.best_score)}%</div>
                          <div className="text-xs text-dim2">Best</div>
                        </div>
                      </div>
                    ) : (
                      <span className="text-xs text-dim2">No attempts</span>
                    )}

                    <button
                      onClick={() => toggleQuiz(quiz.id, quiz.is_active)}
                      className="text-xs px-3 py-1.5 border border-border rounded-lg text-dim hover:text-accent hover:border-accent transition"
                    >
                      {quiz.is_active ? 'Hide' : 'Show'}
                    </button>
                  </div>
                </div>
              </div>
            )
          })}
        </div>

        {quizzes.length === 0 && (
          <div className="text-center py-16 text-dim">
            <p>No quizzes created yet.</p>
          </div>
        )}
      </main>
    </div>
  )
}
