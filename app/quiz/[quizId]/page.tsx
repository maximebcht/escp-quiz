'use client'

import { useEffect, useState, useCallback } from 'react'
import { createClient } from '@/lib/supabase-browser'
import { useRouter, useParams } from 'next/navigation'
import type { Quiz, Question } from '@/lib/types'
import Link from 'next/link'

const LETTERS = ['A', 'B', 'C', 'D', 'E', 'F']

// Helper: get correct indices for a question (supports both old and new format)
function getCorrectIndices(q: Question): number[] {
  if (q.correct_indices && Array.isArray(q.correct_indices) && q.correct_indices.length > 0) {
    return q.correct_indices
  }
  return [q.correct_index]
}

function isMultiAnswer(q: Question): boolean {
  return getCorrectIndices(q).length > 1
}

function arraysEqual(a: number[], b: number[]): boolean {
  if (a.length !== b.length) return false
  const sa = [...a].sort()
  const sb = [...b].sort()
  return sa.every((v, i) => v === sb[i])
}

export default function QuizPage() {
  const supabase = createClient()
  const router = useRouter()
  const params = useParams()
  const quizId = params.quizId as string

  const [quiz, setQuiz] = useState<Quiz | null>(null)
  const [questions, setQuestions] = useState<Question[]>([])
  const [loading, setLoading] = useState(true)
  const [userId, setUserId] = useState<string>('')

  // Quiz state
  const [started, setStarted] = useState(false)
  const [currentIndex, setCurrentIndex] = useState(0)
  const [answers, setAnswers] = useState<number[][]>([]) // Changed: array of arrays
  const [selected, setSelected] = useState<number[]>([]) // Changed: array for multi-select
  const [confirmed, setConfirmed] = useState(false) // New: for multi-answer confirmation
  const [finished, setFinished] = useState(false)
  const [saving, setSaving] = useState(false)
  const [filter, setFilter] = useState<'all' | 'wrong' | 'correct'>('all')
  const [openReview, setOpenReview] = useState<Record<number, boolean>>({})
  const [startedAt, setStartedAt] = useState<string>('')

  // Lecture filter
  const [lectureTags, setLectureTags] = useState<string[]>([])
  const [selectedLecture, setSelectedLecture] = useState<string | null>(null)
  const [filteredQuestions, setFilteredQuestions] = useState<Question[]>([])

  useEffect(() => {
    loadQuiz()
  }, [quizId])

  async function loadQuiz() {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) { router.push('/auth/login'); return }
    setUserId(user.id)

    const [quizRes, questionsRes] = await Promise.all([
      supabase.from('quizzes').select('*, subjects(*)').eq('id', quizId).single(),
      supabase.from('questions').select('*').eq('quiz_id', quizId).order('sort_order'),
    ])

    if (!quizRes.data) { router.push('/dashboard'); return }

    setQuiz(quizRes.data)
    setQuestions(questionsRes.data || [])

    const tags = [...new Set((questionsRes.data || []).map(q => q.lecture_tag).filter(Boolean))] as string[]
    tags.sort()
    setLectureTags(tags)
    setLoading(false)
  }

  function startQuiz(lectureFilter: string | null) {
    setSelectedLecture(lectureFilter)
    const qs = lectureFilter
      ? questions.filter(q => q.lecture_tag === lectureFilter)
      : questions
    setFilteredQuestions(qs)
    setCurrentIndex(0)
    setAnswers([])
    setSelected([])
    setConfirmed(false)
    setFinished(false)
    setStarted(true)
    setStartedAt(new Date().toISOString())
    setFilter('all')
    setOpenReview({})
  }

  function pick(index: number) {
    if (confirmed) return
    const currentQ = filteredQuestions[currentIndex]

    if (isMultiAnswer(currentQ)) {
      // Toggle selection for multi-answer
      setSelected(prev =>
        prev.includes(index)
          ? prev.filter(i => i !== index)
          : [...prev, index]
      )
    } else {
      // Single answer: select and auto-advance
      setSelected([index])
      setTimeout(() => {
        const newAnswers = [...answers, [index]]
        setAnswers(newAnswers)
        setSelected([])
        setConfirmed(false)

        if (currentIndex + 1 < filteredQuestions.length) {
          setCurrentIndex(currentIndex + 1)
        } else {
          finishQuiz(newAnswers)
        }
      }, 350)
    }
  }

  function confirmMulti() {
    if (selected.length === 0) return
    setConfirmed(true)

    setTimeout(() => {
      const newAnswers = [...answers, [...selected]]
      setAnswers(newAnswers)
      setSelected([])
      setConfirmed(false)

      if (currentIndex + 1 < filteredQuestions.length) {
        setCurrentIndex(currentIndex + 1)
      } else {
        finishQuiz(newAnswers)
      }
    }, 350)
  }

  async function finishQuiz(finalAnswers: number[][]) {
    setFinished(true)
    setSaving(true)

    let score = 0
    filteredQuestions.forEach((q, i) => {
      const correct = getCorrectIndices(q)
      if (arraysEqual(finalAnswers[i] || [], correct)) score++
    })

    const percentage = (score / filteredQuestions.length) * 100

    // Store flattened answers for backwards compatibility
    // For single-answer questions, store the single index
    // For multi-answer, store the array
    await supabase.from('quiz_attempts').insert({
      user_id: userId,
      quiz_id: quizId,
      score,
      total: filteredQuestions.length,
      percentage: Math.round(percentage * 100) / 100,
      answers: finalAnswers,
      started_at: startedAt,
      completed_at: new Date().toISOString(),
    })

    setSaving(false)
  }

  function toggleReview(index: number) {
    setOpenReview(prev => ({ ...prev, [index]: !prev[index] }))
  }

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-dim animate-pulse">Loading quiz...</div>
    </div>
  )

  // Score calculation
  let score = 0
  const wrongCount = finished ? filteredQuestions.length - (() => {
    let s = 0
    filteredQuestions.forEach((q, i) => {
      if (arraysEqual(answers[i] || [], getCorrectIndices(q))) s++
    })
    score = s
    return s
  })() : 0

  const percentage = finished ? Math.round((score / filteredQuestions.length) * 100) : 0
  const scoreClass = percentage >= 70 ? 'text-ok' : percentage >= 50 ? 'text-yellow-400' : 'text-no'

  // ==================== START SCREEN ====================
  if (!started) {
    return (
      <div className="min-h-screen">
        <header className="border-b border-border bg-surface/50 backdrop-blur-sm sticky top-0 z-10">
          <div className="max-w-3xl mx-auto px-4 py-3 flex items-center gap-3">
            <Link href="/dashboard" className="text-dim hover:text-accent transition">← Back</Link>
          </div>
        </header>

        <div className="max-w-xl mx-auto px-4 py-12 text-center animate-fadeUp">
          <h1 className="text-2xl font-extrabold mb-2">{quiz?.title}</h1>
          {quiz?.description && <p className="text-dim mb-2">{quiz.description}</p>}
          <p className="text-dim2 text-sm mb-8">{questions.length} questions</p>

          <button
            onClick={() => startQuiz(null)}
            className="w-full max-w-xs mx-auto mb-4 py-3 bg-accent text-white font-bold rounded-xl hover:brightness-110 transition block"
          >
            Start Full Quiz ({questions.length} questions)
          </button>

          {lectureTags.length > 1 && (
            <>
              <div className="text-sm text-dim2 my-6">— or practice by lecture —</div>
              <div className="grid gap-2 sm:grid-cols-2">
                {lectureTags.map(tag => {
                  const count = questions.filter(q => q.lecture_tag === tag).length
                  return (
                    <button
                      key={tag}
                      onClick={() => startQuiz(tag)}
                      className="py-3 px-4 bg-surface border border-border rounded-xl hover:border-accent transition flex justify-between items-center"
                    >
                      <span className="font-semibold text-sm">{tag}</span>
                      <span className="text-dim2 text-xs">{count}Q</span>
                    </button>
                  )
                })}
              </div>
            </>
          )}
        </div>
      </div>
    )
  }

  // ==================== RESULTS SCREEN ====================
  if (finished) {
    const reviewQuestions = filteredQuestions
      .map((q, i) => {
        const correct = arraysEqual(answers[i] || [], getCorrectIndices(q))
        return { q, i, correct }
      })
      .filter(item =>
        filter === 'all' ? true :
        filter === 'wrong' ? !item.correct :
        item.correct
      )

    return (
      <div className="min-h-screen">
        <div className="max-w-2xl mx-auto px-4 py-10 animate-fadeUp">
          {/* Score */}
          <div className="text-center mb-6">
            <div className={`text-5xl font-extrabold ${scoreClass}`}>{score}/{filteredQuestions.length}</div>
            <div className={`text-lg font-semibold ${scoreClass}`}>{percentage}%</div>
            {saving && <p className="text-xs text-dim2 mt-2">Saving result...</p>}
          </div>

          {/* Stats */}
          <div className="flex gap-3 justify-center mb-6 flex-wrap">
            <div className="bg-surface border border-border rounded-xl px-5 py-3 text-center">
              <div className="text-xl font-bold text-ok">{score}</div>
              <div className="text-xs text-dim">Correct</div>
            </div>
            <div className="bg-surface border border-border rounded-xl px-5 py-3 text-center">
              <div className="text-xl font-bold text-no">{wrongCount}</div>
              <div className="text-xs text-dim">Wrong</div>
            </div>
            <div className="bg-surface border border-border rounded-xl px-5 py-3 text-center">
              <div className={`text-xl font-bold ${scoreClass}`}>{percentage}%</div>
              <div className="text-xs text-dim">Score</div>
            </div>
          </div>

          {/* Restart */}
          <div className="text-center mb-8">
            <button
              onClick={() => { setStarted(false); setFinished(false) }}
              className="px-6 py-2.5 bg-accent text-white font-bold rounded-xl text-sm hover:brightness-110 transition"
            >
              ↻ Try Again
            </button>
          </div>

          {/* Filter */}
          <div className="flex gap-2 mb-5 flex-wrap">
            {(['all', 'wrong', 'correct'] as const).map(f => (
              <button
                key={f}
                onClick={() => setFilter(f)}
                className={`px-4 py-1.5 rounded-full text-xs font-semibold border transition ${
                  filter === f
                    ? 'bg-accent-glow border-accent text-accent'
                    : 'bg-surface border-border text-dim hover:border-accent/50'
                }`}
              >
                {f === 'all' ? `All (${filteredQuestions.length})` :
                 f === 'wrong' ? `Wrong (${wrongCount})` :
                 `Correct (${score})`}
              </button>
            ))}
          </div>

          {/* Review */}
          <div className="space-y-2">
            {reviewQuestions.map(({ q, i, correct }) => {
              const correctIndices = getCorrectIndices(q)
              const userAnswer = answers[i] || []

              return (
                <div key={i} className={`border rounded-xl overflow-hidden ${correct ? 'border-ok/20' : 'border-no/20'}`}>
                  <button
                    onClick={() => toggleReview(i)}
                    className="w-full px-4 py-3 flex items-start gap-3 bg-surface hover:bg-surface2 transition text-left"
                  >
                    <div className={`flex-shrink-0 w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold ${
                      correct ? 'bg-ok-bg text-ok' : 'bg-no-bg text-no'
                    }`}>
                      {correct ? '✓' : '✗'}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="text-sm font-semibold">Q{i + 1}. {q.question_text}</div>
                      {q.lecture_tag && <div className="text-xs text-dim2 mt-0.5">{q.lecture_tag}</div>}
                    </div>
                    <span className={`text-dim text-xs transition ${openReview[i] ? 'rotate-180' : ''}`}>▾</span>
                  </button>

                  {openReview[i] && (
                    <div className="px-4 pb-4 bg-surface space-y-2">
                      {!correct && (
                        <div className="px-3 py-2 rounded-lg bg-no-bg text-no text-sm">
                          Your answer: {userAnswer.map(a => `${LETTERS[a]}. ${q.options[a]}`).join(', ')}
                        </div>
                      )}
                      <div className="px-3 py-2 rounded-lg bg-ok-bg text-ok text-sm">
                        Correct answer{correctIndices.length > 1 ? 's' : ''}: {correctIndices.map(a => `${LETTERS[a]}. ${q.options[a]}`).join(', ')}
                      </div>
                      {q.explanation && (
                        <div className="px-3 py-2 rounded-lg bg-surface2 text-dim text-sm leading-relaxed">
                          {q.explanation}
                        </div>
                      )}
                    </div>
                  )}
                </div>
              )
            })}
          </div>
        </div>
      </div>
    )
  }

  // ==================== QUESTION SCREEN ====================
  const currentQ = filteredQuestions[currentIndex]
  const progress = ((currentIndex) / filteredQuestions.length * 100).toFixed(1)
  const multi = isMultiAnswer(currentQ)

  return (
    <div className="min-h-screen">
      {/* Progress bar */}
      <div className="h-1 bg-track sticky top-0 z-10">
        <div
          className="h-full bg-gradient-to-r from-accent to-purple-500 rounded-r transition-all duration-400"
          style={{ width: `${progress}%` }}
        />
      </div>

      <div className="max-w-2xl mx-auto px-4 py-8 animate-fadeUp" key={currentIndex}>
        {/* Header */}
        <div className="flex items-center justify-between mb-6 flex-wrap gap-2">
          <span className="text-sm font-semibold text-dim">
            Question {currentIndex + 1}/{filteredQuestions.length}
          </span>
          {currentQ.lecture_tag && (
            <span className="text-xs font-semibold text-accent bg-accent-glow px-3 py-1 rounded-full">
              {currentQ.lecture_tag}
            </span>
          )}
        </div>

        {/* Question */}
        <p className="text-lg font-semibold leading-relaxed mb-4">
          {currentQ.question_text}
        </p>

        {/* Multi-answer badge */}
        {multi && (
          <div className="mb-5 inline-flex items-center gap-1.5 text-xs font-semibold text-accent bg-accent-glow px-3 py-1.5 rounded-lg">
            ⚡ Multiple correct answers — select all that apply
          </div>
        )}

        {/* Options */}
        <div className="space-y-3">
          {currentQ.options.map((opt, i) => {
            const isSel = selected.includes(i)
            const isLocked = !multi && selected.length > 0 && !isSel

            return (
              <button
                key={i}
                onClick={() => pick(i)}
                disabled={confirmed || (!multi && selected.length > 0)}
                className={`w-full text-left px-4 py-3.5 bg-surface border rounded-xl flex items-start gap-3 transition ${
                  isSel
                    ? 'border-accent bg-accent-glow'
                    : isLocked
                    ? 'opacity-50 cursor-not-allowed border-border'
                    : 'border-border hover:border-accent/50'
                }`}
              >
                <span className={`flex-shrink-0 w-7 h-7 rounded-lg flex items-center justify-center text-xs font-bold ${
                  isSel ? 'bg-accent text-white' : 'bg-surface2'
                }`}>
                  {LETTERS[i]}
                </span>
                <span className="pt-0.5 leading-relaxed">{opt}</span>
              </button>
            )
          })}
        </div>

        {/* Confirm button for multi-answer questions */}
        {multi && selected.length > 0 && !confirmed && (
          <div className="mt-5">
            <button
              onClick={confirmMulti}
              className="w-full py-3 bg-accent text-white font-bold rounded-xl hover:brightness-110 transition"
            >
              Confirm selection ({selected.length} selected)
            </button>
          </div>
        )}
      </div>
    </div>
  )
}
