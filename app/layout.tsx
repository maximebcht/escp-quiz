import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'ESCP Quiz',
  description: 'Interactive revision quizzes for ESCP Business School',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="min-h-screen">{children}</body>
    </html>
  )
}
