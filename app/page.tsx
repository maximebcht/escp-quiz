import Link from 'next/link'

export default function Home() {
  return (
    <div className="min-h-screen flex items-center justify-center px-4">
      <div className="text-center animate-fadeUp max-w-lg">
        <div className="text-5xl mb-6">📚</div>
        <h1 className="text-3xl font-extrabold tracking-tight mb-2">ESCP Quiz</h1>
        <p className="text-dim mb-1">Interactive revision platform</p>
        <p className="text-dim2 text-sm mb-8">ESCP Business School – Bachelor in Management</p>
        <div className="flex gap-3 justify-center">
          <Link
            href="/auth/login"
            className="px-6 py-3 bg-accent text-white font-bold rounded-xl hover:brightness-110 transition"
          >
            Log In
          </Link>
          <Link
            href="/auth/register"
            className="px-6 py-3 bg-surface border border-border text-dim font-semibold rounded-xl hover:border-accent hover:text-accent transition"
          >
            Sign Up
          </Link>
        </div>
      </div>
    </div>
  )
}
