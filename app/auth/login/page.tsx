'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase-browser'
import Link from 'next/link'
import { useRouter } from 'next/navigation'

export default function LoginPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const router = useRouter()
  const supabase = createClient()

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    const { error } = await supabase.auth.signInWithPassword({ email, password })

    if (error) {
      setError(error.message)
      setLoading(false)
    } else {
      router.push('/dashboard')
      router.refresh()
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4">
      <div className="w-full max-w-sm animate-fadeUp">
        <div className="text-center mb-8">
          <div className="text-4xl mb-3">📚</div>
          <h1 className="text-2xl font-extrabold">Welcome back</h1>
          <p className="text-dim text-sm mt-1">Log in to your account</p>
        </div>

        <form onSubmit={handleLogin} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-dim mb-1.5">Email</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full px-4 py-3 bg-surface border border-border rounded-xl text-white placeholder:text-dim2 focus:outline-none focus:border-accent transition"
              placeholder="you@edu.escp.eu"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-dim mb-1.5">Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full px-4 py-3 bg-surface border border-border rounded-xl text-white placeholder:text-dim2 focus:outline-none focus:border-accent transition"
              placeholder="••••••••"
              required
            />
          </div>

          {error && (
            <div className="px-4 py-3 bg-no-bg border border-no/20 rounded-xl text-no text-sm">
              {error}
            </div>
          )}

          <button
            type="submit"
            disabled={loading}
            className="w-full py-3 bg-accent text-white font-bold rounded-xl hover:brightness-110 transition disabled:opacity-50"
          >
            {loading ? 'Logging in...' : 'Log In'}
          </button>
        </form>

        <p className="text-center text-dim2 text-sm mt-6">
          Don't have an account?{' '}
          <Link href="/auth/register" className="text-accent hover:underline">Sign up</Link>
        </p>
      </div>
    </div>
  )
}
