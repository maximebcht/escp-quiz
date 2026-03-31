'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase-browser'
import Link from 'next/link'
import { useRouter } from 'next/navigation'

export default function RegisterPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [fullName, setFullName] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const router = useRouter()
  const supabase = createClient()

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: { full_name: fullName },
      },
    })

    if (error) {
      if (error.message.includes('not authorized')) {
        setError('This email is not authorized. Contact the admin for access.')
      } else {
        setError(error.message)
      }
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
          <div className="text-4xl mb-3">✨</div>
          <h1 className="text-2xl font-extrabold">Create account</h1>
          <p className="text-dim text-sm mt-1">Your email must be authorized by admin</p>
        </div>

        <form onSubmit={handleRegister} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-dim mb-1.5">Full Name</label>
            <input
              type="text"
              value={fullName}
              onChange={(e) => setFullName(e.target.value)}
              className="w-full px-4 py-3 bg-surface border border-border rounded-xl text-white placeholder:text-dim2 focus:outline-none focus:border-accent transition"
              placeholder="Your full name"
              required
            />
          </div>
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
              placeholder="Min. 6 characters"
              minLength={6}
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
            {loading ? 'Creating account...' : 'Sign Up'}
          </button>
        </form>

        <p className="text-center text-dim2 text-sm mt-6">
          Already have an account?{' '}
          <Link href="/auth/login" className="text-accent hover:underline">Log in</Link>
        </p>
      </div>
    </div>
  )
}
