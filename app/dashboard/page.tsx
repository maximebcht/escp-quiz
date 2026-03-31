'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase-browser'
import { useRouter } from 'next/navigation'
import type { Profile, Subject, Quiz, QuizAttempt } from '@/lib/types'
import Link from 'next/link'

export default function DashboardPage() {
  const supabase = createClient()
  const router = useRouter()
  const [profile, setProfile] = useState<Profile | null>(null)
  const [subjects, setSubjects] = useState<Subject[]>([])
  const [quizzes, setQuizzes] = useState<Quiz[]>([])
  const [attempts, setAttempts] = useState<QuizAttempt[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    loadData()
  }, [])

  async function loadData() {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) { router.push('/auth/login'); return }

    const [profileRes, subjectsRes, quizzesRes, attemptsRes] = await Promise.all([
      supabase.from('profiles').select('*').eq('id', user.id).single(),
      supabase.from('subjects').select('*').order('name'),
      supabase.from('quizzes').select('*, subjects(*)').eq('is_active', true).order('created_at', { ascending: false }),
      supabase.from('quiz_attempts').select('*, quizzes(*)').eq('user_id', user.id).order('completed_at', { ascending: false }).limit(10),
    ])

console.log('profileRes', profileRes)
console.log('subjectsRes', subjectsRes)
console.log('quizzesRes', quizzesRes)
console.log('attemptsRes', attemptsRes)
    
    setProfile(profileRes.data)
    setSubjects(subjectsRes.data || [])
    setQuizzes(quizzesRes.data || [])
    setAttempts(attemptsRes.data || [])
    setLoading(false)
  }

  async function handleLogout() {
    await supabase.auth.signOut()
    router.push('/auth/login')
    router.refresh()
  }

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-dim animate-pulse">Loading...</div>
    </div>
  )

  const bestScores: Record<string, number> = {}
  attempts.forEach(a => {
    if (!bestScores[a.quiz_id] || a.percentage > bestScores[a.quiz_id]) {
      bestScores[a.quiz_id] = a.percentage
    }
  })

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="border-b border-border bg-surface/50 backdrop-blur-sm sticky top-0 z-10">
        <div className="max-w-5xl mx-auto px-4 py-3 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <span className="text-xl">📚</span>
            <span className="font-bold text-lg">ESCP Quiz</span>
          </div>
          <div className="flex items-center gap-4">
            {profile?.is_admin && (
              <Link href="/admin/users" className="text-sm text-accent hover:underline font-medium">
                Admin Panel
              </Link>
            )}
            <span className="text-sm text-dim hidden sm:inline">{profile?.full_name || profile?.email}</span>
            <button onClick={handleLogout} className="text-sm text-dim2 hover:text-no transition">
              Log out
            </button>
          </div>
        </div>
      </header>

      <main className="max-w-5xl mx-auto px-4 py-8">
        {/* Welcome */}
        <div className="mb-8 animate-fadeUp">
          <h1 className="text-2xl font-extrabold">
            Hey {profile?.full_name?.split(' ')[0] || 'there'} 👋
          </h1>
          <p className="text-dim mt-1">Ready to revise?</p>
        </div>

        {/* Quick Stats */}
        {attempts.length > 0 && (
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-8 animate-fadeUp">
            <div className="bg-surface border border-border rounded-xl p-4 text-center">
              <div className="text-2xl font-bold">{attempts.length}</div>
              <div className="text-xs text-dim mt-1">Attempts</div>
            </div>
            <div className="bg-surface border border-border rounded-xl p-4 text-center">
              <div className="text-2xl font-bold text-ok">
                {Math.round(attempts.reduce((a, b) => a + b.percentage, 0) / attempts.length)}%
              </div>
              <div className="text-xs text-dim mt-1">Avg Score</div>
            </div>
            <div className="bg-surface border border-border rounded-xl p-4 text-center">
              <div className="text-2xl font-bold text-accent">
                {Math.max(...attempts.map(a => a.percentage))}%
              </div>
              <div className="text-xs text-dim mt-1">Best Score</div>
            </div>
            <div className="bg-surface border border-border rounded-xl p-4 text-center">
              <div className="text-2xl font-bold">
                {attempts.reduce((a, b) => a + b.score, 0)}
              </div>
              <div className="text-xs text-dim mt-1">Total Correct</div>
            </div>
          </div>
        )}

        {/* Quizzes by Subject */}
        {subjects.map(subject => {
          const subjectQuizzes = quizzes.filter(q => q.subject_id === subject.id)
          if (subjectQuizzes.length === 0) return null

          return (
            <div key={subject.id} className="mb-8 animate-fadeUp">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-2 h-2 rounded-full" style={{ background: subject.color }} />
                <h2 className="text-lg font-bold">{subject.code} – {subject.name}</h2>
              </div>

              <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                {subjectQuizzes.map(quiz => {
                  const best = bestScores[quiz.id]
                  return (
                    <Link
                      key={quiz.id}
                      href={`/quiz/${quiz.id}`}
                      className="bg-surface border border-border rounded-xl p-5 hover:border-accent/50 transition group"
                    >
                      <div className="flex items-start justify-between mb-3">
                        <div>
                          <h3 className="font-bold group-hover:text-accent transition">{quiz.title}</h3>
                          {quiz.lecture_tag && (
                            <span className="text-xs text-accent bg-accent-glow px-2 py-0.5 rounded-full mt-1 inline-block">
                              {quiz.lecture_tag}
                            </span>
                          )}
                        </div>
                        <span className="text-xs text-dim2 font-medium">{quiz.question_count}Q</span>
                      </div>
                      {quiz.description && (
                        <p className="text-sm text-dim mb-3 line-clamp-2">{quiz.description}</p>
                      )}
                      {best !== undefined ? (
                        <div className="flex items-center gap-2">
                          <div className="flex-1 h-1.5 bg-track rounded-full overflow-hidden">
                            <div
                              className="h-full rounded-full transition-all"
                              style={{
                                width: `${best}%`,
                                background: best >= 70 ? '#34d399' : best >= 50 ? '#f6c547' : '#ef6b6b'
                              }}
                            />
                          </div>
                          <span className="text-xs font-bold" style={{
                            color: best >= 70 ? '#34d399' : best >= 50 ? '#f6c547' : '#ef6b6b'
                          }}>
                            {Math.round(best)}%
                          </span>
                        </div>
                      ) : (
                        <span className="text-xs text-dim2">Not attempted yet</span>
                      )}
                    </Link>
                  )
                })}
              </div>
            </div>
          )
        })}

        {quizzes.length === 0 && (
          <div className="text-center py-16 text-dim">
            <div className="text-4xl mb-4">🎯</div>
            <p>No quizzes available yet. Check back soon!</p>
          </div>
        )}

        {/* Recent Attempts */}
        {attempts.length > 0 && (
          <div className="mt-8 animate-fadeUp">
            <h2 className="text-lg font-bold mb-4">Recent Attempts</h2>
            <div className="space-y-2">
              {attempts.slice(0, 5).map(attempt => (
                <div key={attempt.id} className="bg-surface border border-border rounded-xl px-4 py-3 flex items-center justify-between">
                  <div>
                    <span className="font-medium text-sm">{(attempt as any).quizzes?.title || 'Quiz'}</span>
                    <span className="text-xs text-dim2 ml-3">
                      {new Date(attempt.completed_at).toLocaleDateString()}
                    </span>
                  </div>
                  <span className="font-bold text-sm" style={{
                    color: attempt.percentage >= 70 ? '#34d399' : attempt.percentage >= 50 ? '#f6c547' : '#ef6b6b'
                  }}>
                    {attempt.score}/{attempt.total} ({Math.round(attempt.percentage)}%)
                  </span>
                </div>
              ))}
            </div>
          </div>
        )}
      </main>
    </div>
  )
}
