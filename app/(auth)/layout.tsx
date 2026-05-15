export default function AuthLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-mise-paper flex flex-col items-center justify-center px-4">
      <p className="font-serif text-2xl text-mise-ink tracking-tight mb-8">Mise</p>
      <div className="w-full max-w-sm bg-white border border-mise-rule rounded-lg p-8 shadow-sm">
        {children}
      </div>
    </div>
  )
}