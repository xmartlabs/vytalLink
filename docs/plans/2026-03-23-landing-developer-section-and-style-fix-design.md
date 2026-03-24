# Landing Developer Section + Style Fix Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Fix the current developer-related style regression in the landing flow and add a simple developer-focused section after “Pick Your AI Assistant” with a clear link to the developers page.

**Architecture:** Keep the existing modular landing structure (HTML + imported CSS partials) and implement only scoped changes in `index.html` and landing style partials. Reuse existing design tokens/utility classes and add minimal new classes for the new section. Validate desktop + mobile behavior to avoid layout regressions.

**Tech Stack:** Static HTML, modular CSS (`styles.css` imports), vanilla JS (only if interaction is needed), Firebase Hosting preview flow.

---

### Task 1: Baseline audit and precise regression target

**Files:**
- Inspect: `landing/public/index.html`
- Inspect: `landing/public/developers.html`
- Inspect: `landing/public/styles/07-demo-integrations.css`
- Inspect: `landing/public/styles/20-developers.css`
- Inspect: `landing/public/styles/10-responsive-and-effects.css`

**Step 1: Identify the “developer section style issue” scope**
- Confirm whether regression is on home page, developers page, or both.
- Capture exact selectors involved before changes.

**Step 2: Define constraints for fix**
- Keep current visual language (tokens, spacing scale, button styles).
- Avoid introducing new JS unless strictly required.

**Step 3: Commit checkpoint (optional if this task is investigative only)**
```bash
# no commit if no file changes
```

### Task 2: Add new “For Developers” section in landing

**Files:**
- Modify: `landing/public/index.html`

**Step 1: Insert section after integrations block (`#integrations`) and before footer**
- Add a simple section with:
  - Title focused on developers
  - Short explanatory copy (“create your own agents”)
  - Primary CTA to `/developers.html`
  - Secondary CTA to `/mcp-setup.html` (optional, if aligned with final copy)

**Step 2: Keep semantics and accessibility**
- Use proper section heading hierarchy.
- Ensure link text is explicit.

**Step 3: Commit checkpoint**
```bash
git add landing/public/index.html
git commit -m "feat: add developers CTA section to landing"
```

### Task 3: Style the new section and fix developer-style inconsistency

**Files:**
- Modify: `landing/public/styles/07-demo-integrations.css`
- Modify (if needed): `landing/public/styles/20-developers.css`
- Modify (if needed): `landing/public/styles/10-responsive-and-effects.css`

**Step 1: Add scoped styles for the new home section**
- Create namespaced classes (e.g. `.home-dev-cta*`) for container, copy, action row.
- Reuse existing variables (`--primary-color`, `--secondary-color`, `--gradient`, shadows).

**Step 2: Apply regression fix for developer style mismatch**
- Normalize spacing/typography/alignment where regression is detected.
- Keep changes isolated to affected selector(s) to avoid global side effects.

**Step 3: Mobile adjustments**
- Ensure CTA buttons and text stack properly at `<= 768px` and `<= 480px`.

**Step 4: Commit checkpoint**
```bash
git add landing/public/styles/07-demo-integrations.css landing/public/styles/20-developers.css landing/public/styles/10-responsive-and-effects.css
git commit -m "fix: align developer section styling across landing pages"
```

### Task 4: Content polish and consistency checks

**Files:**
- Modify (if needed): `landing/public/index.html`
- Modify (if needed): `landing/public/developers.html`

**Step 1: Copy consistency**
- Keep concise English copy consistent with existing landing tone.
- Ensure “Pick Your AI Assistant” and new developer section flow naturally.

**Step 2: Link consistency**
- Verify all developer-related links point to correct pages (`/developers.html`, `/mcp-setup.html`).

**Step 3: Commit checkpoint**
```bash
git add landing/public/index.html landing/public/developers.html
git commit -m "refactor: improve developer messaging flow in landing"
```

### Task 5: Verification and QA before merge

**Files:**
- Validate: `landing/public/index.html`
- Validate: `landing/public/styles/07-demo-integrations.css`
- Validate: `landing/public/styles/10-responsive-and-effects.css`
- Validate: `landing/public/styles/20-developers.css`

**Step 1: Run local preview**
```bash
cd landing
firebase serve --only hosting --port 5000
```
Expected:
- Home renders without broken layout.
- New developer section appears after “Pick Your AI Assistant”.

**Step 2: Responsive QA**
- Check desktop, tablet, and mobile widths.
- Confirm no overflow, broken cards, or CTA wrapping issues.

**Step 3: Final sanity checks**
- Navigation remains functional.
- Visual hierarchy and spacing look consistent.

**Step 4: Final commit (if QA changes were needed)**
```bash
git add landing/public/index.html landing/public/styles/07-demo-integrations.css landing/public/styles/10-responsive-and-effects.css landing/public/styles/20-developers.css
git commit -m "chore: finalize landing developer section QA adjustments"
```
