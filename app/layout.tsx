import type { Metadata } from "next"
import "./globals.css"

export const metadata: Metadata = {
  title: { default: "Mise", template: "%s â€” Mise" },
  description: "Production planning for catering and events.",
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}