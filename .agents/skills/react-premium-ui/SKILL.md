---
name: react-premium-ui
description: Production-grade React dashboard UI with Tailwind CSS, Lucide icons, skeleton loaders, responsive data tables, debounce search, and clean state management.
---

# React & Tailwind UI / Lucide Icons Pro Skill

## UI/UX Standards
1. **Design System & Aesthetics**:
   - Modern enterprise dashboard look: subtle borders (`border-slate-800` or `border-zinc-200`), dark/light theme harmony, clean typography (Inter / Outfit).
   - Glassmorphic card surfaces and subtle glow/shadow effects (`shadow-sm`, `backdrop-blur-md`).
   - Standardized status badges:
     - `Approved` / `Active`: Green (`bg-emerald-500/10 text-emerald-600 border-emerald-500/20`)
     - `Pending`: Amber / Yellow (`bg-amber-500/10 text-amber-600 border-amber-500/20`)
     - `Rejected` / `Critical`: Rose / Red (`bg-rose-500/10 text-rose-600 border-rose-500/20`)

2. **Data Presentation & Tables**:
   - Debounced search filter inputs.
   - Column sorting, pagination, and empty state graphics/placeholders.
   - Skeleton loading states (avoid raw spinners for full content areas).

3. **Interactive Components**:
   - Modal dialogs with accessible escape/backdrop close.
   - Toast notifications for API mutations.
   - Action confirmation drawers / sheets.
