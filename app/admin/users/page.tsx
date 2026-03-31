'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase-browser'
import { useRouter } from 'next/navigation'
import type { Profile } from '@/lib/types'
import Link from 'next/link'

interface AllowedEmail {
  id: string
  email: string
  added_at: string
}

export default function AdminUsersPage() {
  const supabase = createClient()
  const router = useRouter()
  const [isAdmin, setIsAdmin] = useState(false)
  const [loading, setLoading] = useState(true)
  const [emails, setEmails] = useState<AllowedEmail[]>([])
  const [profiles, setProfiles] = useState<Profile[]>([])
  const [newEmail, setNewEmail] = useState('')
  const [adding, setAdding] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  // Attempt stats
  const [stats, setStats] = useState<Record<string, { attempts: number; avg: number }>>({})

  useEffect(() => {
    checkAdminAndLoad()
  }, [])

  async function checkAdminAndLoad() {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) { router.push('/auth/login'); return }

    const { data: profile } = await supabase.from('profiles').select('*').eq('id', user.id).single()
    console.log('admin profile', profile)
    if (!profile?.is_admin) { router.push('/dashboard'); return }

    setIsAdmin(true)

    const [emailsRes, profilesRes, attemptsRes] = await Promise.all([
      supabase.from('allowed_emails').select('*').order('added_at', { ascending: false }),
      supabase.from('profiles').select('*').order('created_at', { ascending: false }),
      supabase.from('quiz_attempts').select('user_id, percentage'),
    ])

    setEmails(emailsRes.data || [])
    setProfiles(profilesRes.data || [])

    // Compute per-user stats
    const s: Record<string, { attempts: number; avg: number; total: number }> = {}
    ;(attemptsRes.data || []).forEach((a: any) => {
      if (!s[a.user_id]) s[a.user_id] = { attempts: 0, avg: 0, total: 0 }
      s[a.user_id].attempts++
      s[a.user_id].total += a.percentage
    })
    Object.keys(s).forEach(uid => {
      s[uid].avg = Math.round(s[uid].total / s[uid].attempts)
    })
    setStats(s)
    setLoading(false)
  }

  async function addEmail(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    setSuccess('')
    setAdding(true)

    const email = newEmail.trim().toLowerCase()
    if (!email) { setAdding(false); return }

    const { error: err } = await supabase.from('allowed_emails').insert({ email })

    if (err) {
      setError(err.message.includes('duplicate') ? 'Email already in the list' : err.message)
    } else {
      setSuccess(`${email} added successfully`)
      setNewEmail('')
      // Refresh list
      const { data } = await supabase.from('allowed_emails').select('*').order('added_at', { ascending: false })
      setEmails(data || [])
    }
    setAdding(false)
  }

  async function removeEmail(id: string, email: string) {
    if (!confirm(`Remove ${email} from allowed list?`)) return
    await supabase.from('allowed_emails').delete().eq('id', id)
    setEmails(emails.filter(e => e.id !== id))
  }

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-dim animate-pulse">Loading admin panel...</div>
    </div>
  )

  if (!isAdmin) return null

  return (
    <div className="min-h-screen">
      <header className="border-b border-border bg-surface/50 backdrop-blur-sm sticky top-0 z-10">
        <div className="max-w-5xl mx-auto px-4 py-3 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <Link href="/dashboard" className="text-dim hover:text-accent transition">← Dashboard</Link>
            <span className="font-bold">Admin Panel</span>
          </div>
          <div className="flex gap-3">
            <Link href="/admin/users" className="text-sm font-semibold text-accent">Users</Link>
            <Link href="/admin/quizzes" className="text-sm font-semibold text-dim hover:text-accent transition">Quizzes</Link>
          </div>
        </div>
      </header>

      <main className="max-w-5xl mx-auto px-4 py-8">
        {/* Add email form */}
        <div className="bg-surface border border-border rounded-xl p-6 mb-8 animate-fadeUp">
          <h2 className="text-lg font-bold mb-4">Add Authorized Email</h2>
          <form onSubmit={addEmail} className="flex gap-3 flex-wrap">
            <input
              type="email"
              value={newEmail}
              onChange={(e) => setNewEmail(e.target.value)}
              className="flex-1 min-w-[250px] px-4 py-2.5 bg-bg border border-border rounded-xl text-white placeholder:text-dim2 focus:outline-none focus:border-accent transition text-sm"
              placeholder="classmate@edu.escp.eu"
              required
            />
            <button
              type="submit"
              disabled={adding}
              className="px-5 py-2.5 bg-accent text-white font-bold rounded-xl text-sm hover:brightness-110 transition disabled:opacity-50"
            >
              {adding ? 'Adding...' : '+ Add Email'}
            </button>
          </form>
          {error && <p className="text-no text-sm mt-3">{error}</p>}
          {success && <p className="text-ok text-sm mt-3">{success}</p>}
        </div>

        {/* Allowed emails list */}
        <div className="bg-surface border border-border rounded-xl p-6 mb-8 animate-fadeUp">
          <h2 className="text-lg font-bold mb-4">Allowed Emails ({emails.length})</h2>
          {emails.length === 0 ? (
            <p className="text-dim2 text-sm">No emails added yet</p>
          ) : (
            <div className="space-y-2 max-h-64 overflow-y-auto">
              {emails.map(em => (
                <div key={em.id} className="flex items-center justify-between py-2 px-3 rounded-lg hover:bg-surface2 transition">
                  <div>
                    <span className="text-sm font-medium">{em.email}</span>
                    <span className="text-xs text-dim2 ml-3">{new Date(em.added_at).toLocaleDateString()}</span>
                  </div>
                  <button
                    onClick={() => removeEmail(em.id, em.email)}
                    className="text-xs text-dim2 hover:text-no transition"
                  >
                    Remove
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Registered users */}
        <div className="bg-surface border border-border rounded-xl p-6 animate-fadeUp">
          <h2 className="text-lg font-bold mb-4">Registered Users ({profiles.length})</h2>
          {profiles.length === 0 ? (
            <p className="text-dim2 text-sm">No users registered yet</p>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="text-left text-dim2 border-b border-border">
                    <th className="pb-3 font-semibold">Name</th>
                    <th className="pb-3 font-semibold">Email</th>
                    <th className="pb-3 font-semibold text-center">Attempts</th>
                    <th className="pb-3 font-semibold text-center">Avg Score</th>
                    <th className="pb-3 font-semibold text-center">Role</th>
                  </tr>
                </thead>
                <tbody>
                  {profiles.map(p => {
                    const s = stats[p.id]
                    return (
                      <tr key={p.id} className="border-b border-border/50 hover:bg-surface2 transition">
                        <td className="py-3 font-medium">{p.full_name || '—'}</td>
                        <td className="py-3 text-dim">{p.email}</td>
                        <td className="py-3 text-center">{s?.attempts || 0}</td>
                        <td className="py-3 text-center">
                          {s ? (
                            <span style={{
                              color: s.avg >= 70 ? '#34d399' : s.avg >= 50 ? '#f6c547' : '#ef6b6b'
                            }}>{s.avg}%</span>
                          ) : '—'}
                        </td>
                        <td className="py-3 text-center">
                          {p.is_admin ? (
                            <span className="text-xs bg-accent-glow text-accent px-2 py-0.5 rounded-full font-semibold">Admin</span>
                          ) : (
                            <span className="text-xs text-dim2">Student</span>
                          )}
                        </td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </main>
    </div>
  )
}
