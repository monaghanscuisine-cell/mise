"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import Link from "next/link"
import { createClient } from "@/lib/supabase/client"

export default function SignupPage() {
  const router = useRouter()
  const [email,      setEmail]      = useState("")
  const [password,   setPassword]   = useState("")
  const [confirm,    setConfirm]    = useState("")
  const [error,      setError]      = useState("")
  const [loading,    setLoading]    = useState(false)
  const [checkEmail, setCheckEmail] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError("")
    if (password.length < 8) { setError("Password must be at least 8 characters."); return }
    if (password !== confirm) { setError("Passwords do not match."); return }
    setLoading(true)
    const supabase = createClient()
    const { data, error } = await supabase.auth.signUp({ email, password })
    if (error) {
      setError(
        error.message.includes("already registered") || error.message.includes("already exists")
          ? "An account with this email already exists. Try logging in."
          : "Something went wrong. Please try again."
      )
      setLoading(false)
      return
    }
    if (data.user && data.user.identities && data.user.identities.length === 0) {
      setCheckEmail(true)
      setLoading(false)
      return
    }
    router.refresh()
    router.push("/")
  }

  if (checkEmail) {
    return (
      <>
        <h1 className="font-serif text-xl text-mise-ink mb-4">Check your email</h1>
        <p className="text-sm text-mise-stone leading-relaxed">
          We sent a confirmation link to <span className="text-mise-ink font-medium">{email}</span>.
        </p>
        <div className="mt-6 text-center">
          <Link href="/login" className="text-sm text-mise-ink underline underline-offset-2">Back to log in</Link>
        </div>
      </>
    )
  }

  return (
    <>
      <h1 className="font-serif text-xl text-mise-ink mb-6">Create account</h1>
      <form onSubmit={handleSubmit} noValidate className="flex flex-col gap-4">
        <div className="flex flex-col gap-1">
          <label htmlFor="email" className="text-xs text-mise-stone uppercase tracking-wide">Email</label>
          <input id="email" type="email" autoComplete="email" required value={email}
            onChange={e => setEmail(e.target.value)} placeholder="you@example.com"
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink focus:outline-none focus:border-mise-stone transition-colors" />
        </div>
        <div className="flex flex-col gap-1">
          <label htmlFor="password" className="text-xs text-mise-stone uppercase tracking-wide">Password</label>
          <input id="password" type="password" autoComplete="new-password" required value={password}
            onChange={e => setPassword(e.target.value)} placeholder="At least 8 characters"
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink focus:outline-none focus:border-mise-stone transition-colors" />
        </div>
        <div className="flex flex-col gap-1">
          <label htmlFor="confirm" className="text-xs text-mise-stone uppercase tracking-wide">Confirm password</label>
          <input id="confirm" type="password" autoComplete="new-password" required value={confirm}
            onChange={e => setConfirm(e.target.value)} placeholder="â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢"
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink focus:outline-none focus:border-mise-stone transition-colors" />
        </div>
        {error && <p className="text-sm text-mise-rust" role="alert">{error}</p>}
        <button type="submit" disabled={loading}
          className="w-full mt-2 bg-mise-ink text-mise-paper text-sm py-2.5 rounded hover:bg-mise-stone transition-colors disabled:opacity-50">
          {loading ? "Creating accountâ€¦" : "Create account"}
        </button>
      </form>
      <p className="mt-6 text-center text-xs text-mise-stone">
        Already have an account?{" "}
        <Link href="/login" className="text-mise-ink underline underline-offset-2">Log in</Link>
      </p>
    </>
  )
}