/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        bg: '#0a0d12',
        surface: '#131720',
        surface2: '#1a1f2b',
        surface3: '#222838',
        accent: '#4d8ce8',
        'accent-glow': 'rgba(77,140,232,0.12)',
        'accent-dark': '#2d5a9e',
        ok: '#34d399',
        'ok-bg': 'rgba(52,211,153,0.08)',
        no: '#ef6b6b',
        'no-bg': 'rgba(239,107,107,0.08)',
        dim: '#7b869b',
        dim2: '#4a5568',
        border: '#252d3d',
        track: '#181d28',
      },
      fontFamily: {
        sans: ['Outfit', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
