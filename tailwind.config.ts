import type { Config } from "tailwindcss"

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans:  ["var(--font-sans)", "system-ui", "sans-serif"],
        serif: ["Georgia", "Cambria", "Times New Roman", "serif"],
      },
      colors: {
        mise: {
          ink:   "#1a1a18",
          paper: "#faf9f6",
          stone: "#6b6b63",
          rule:  "#e2e0da",
          sage:  "#4a5e4a",
          amber: "#c47c2b",
          rust:  "#b34b3a",
        },
      },
    },
  },
  plugins: [],
}

export default config