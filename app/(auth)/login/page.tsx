"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import Link from "next/link"
import { createClient } from "@/lib/supabase/client"

export default function LoginPage() {
  const router = useRouter()
  const [email,    setEmail]    = useState("")
  const [password, setPassword] = useState("")
  const [error,    setError]    = useState("")
  const [loading,  setLoading]  = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError("")
    setLoading(true)
    const supabase = createClient()
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) {
      setError(
        error.message.includes("Invalid login credentials") ||
        error.message.includes("invalid_credentials")
          ? "Incorrect email or password."
          : "Something went wrong. Please try again."
      )
      setLoading(false)
      return
    }
    router.refresh()
    router.push("/")
  }

  return (
    <>
      <h1 className="font-serif text-xl text-mise-ink mb-6">Log in</h1>
      <form onSubmit={handleSubmit} noValidate className="flex flex-col gap-4">
        <div className="flex flex-col gap-1">
          <label htmlFor="email" className="text-xs text-mise-stone uppercase tracking-wide">Email</label>
          <input id="email" type="email" autoComplete="email" required value={email}
            onChange={e => setEmail(e.target.value)} placeholder="you@example.com"
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink focus:outline-none focus:border-mise-stone transition-colors" />
        </div>
        <div className="flex flex-col gap-1">
          <label htmlFor="password" className="text-xs text-mise-stone uppercase tracking-wide">Password</label>
          <input id="password" type="password" autoComplete="current-password" required value={password}
            onChange={e => setPassword(e.target.value)} placeholder="â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢"
            className="w-full border border-mise-rule rounded px-3 py-2 text-sm text-mise-ink focus:outline-none focus:border-mise-stone transition-colors" />
        </div>
        {error && <p className="text-sm text-mise-rust" role="alert">{error}</p>}
        <button type="submit" disabled={loading}
          className="w-full mt-2 bg-mise-ink text-mise-paper text-sm py-2.5 rounded hover:bg-mise-stone transition-colors disabled:opacity-50">
          {loading ? "Logging inâ€¦" : "Log in"}
        </button>
      </form>
      <p className="mt-6 text-center text-xs text-mise-stone">
        No account?{" "}
        <Link href="/signup" className="text-mise-ink underline underline-offset-2">Sign up</Link>
      </p>
    </>
  )
}