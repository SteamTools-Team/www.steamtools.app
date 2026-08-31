# SteamTools Design System — AI Reference

Use this file to reproduce the SteamTools dark/glass design on any new project.

---

## Colors (HSL)

| Token | Value | Usage |
|-------|-------|-------|
| `--background` | `0 0% 3%` | Page background |
| `--foreground` | `0 0% 92%` | Main text |
| `--card` | `0 0% 7%` | Card/surface bg |
| `--card-foreground` | `0 0% 92%` | Text on card |
| `--primary` | `247 60% 61%` | Accent purple (#6e5fd8) |
| `--primary-hover` | `247 50% 52%` | Purple hover |
| `--primary-foreground` | `0 0% 100%` | Text on purple |
| `--muted` | `0 0% 12%` | Subtle bg |
| `--muted-foreground` | `0 0% 48%` | Secondary text |
| `--border` | `0 0% 13%` | Borders |
| `--border-light` | `0 0% 18%` | Lighter borders |
| `--ring` | `247 60% 61%` | Focus ring (same as primary) |
| `--radius` | `0.5rem` | Small radius |
| `--radius-lg` | `0.75rem` | Medium radius |
| `--radius-xl` | `1rem` | Large radius |
| `--green` | `142 71% 45%` | Success/verified |
| `--discord` | `227 70% 60%` | Discord blue |

---

## Typography

```css
font-family: "DM Sans", "Inter", system-ui, -apple-system, sans-serif;
/* Headings / brand */
font-family: "Comfortaa", "DM Sans", system-ui, sans-serif;
```

### Usage
- **Body text**: `0.875rem – 1.1rem`, `--foreground` or `--muted-foreground`
- **Headings**: `2.8rem`, weight `800`, tight letter-spacing `-0.03em`
- **Small text**: `0.75rem – 0.85rem`, `--muted-foreground`

### Import
```html
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Comfortaa:wght@700&display=swap" rel="stylesheet">
```

---

## Glassmorphism (core)

```css
.glass {
  background: hsl(var(--card) / 0.5);
  backdrop-filter: blur(16px) saturate(1.4);
  -webkit-backdrop-filter: blur(16px) saturate(1.4);
  border: 1px solid hsl(var(--border));
  border-radius: var(--radius-xl);
}
```

- **Header glass**: `blur(20px) saturate(1.5)`, bg `hsl(var(--background) / 0.75)`
- **Cards**: `blur(14px) saturate(1.3)`, bg `hsl(var(--card) / 0.5)`
- **Buttons**: `blur(8px)`
- **Modal**: `blur(24px) saturate(1.5)`, bg `hsl(var(--card) / 0.85)`

---

## Buttons

### Glass button (used for Manifest, Premium, secondary)
```css
.btn-glass {
  font-size: 0.85rem; font-weight: 600;
  color: hsl(var(--foreground));
  text-decoration: none;
  padding: 8px 18px;
  border-radius: var(--radius-lg);
  background: hsl(var(--card) / 0.5);
  border: 1px solid hsl(var(--border));
  backdrop-filter: blur(8px);
  transition: all 0.25s;
}
.btn-glass:hover {
  border-color: hsl(var(--primary) / 0.3);
  background: hsl(var(--primary) / 0.1);
  color: hsl(var(--primary));
  box-shadow: 0 0 24px hsl(var(--primary) / 0.12);
}
```

### Primary button (purple fill)
```css
.btn-primary {
  display: inline-flex; align-items: center; gap: 8px;
  padding: 12px 28px;
  border-radius: var(--radius-lg);
  font-size: 0.9rem; font-weight: 600;
  background: hsl(var(--primary));
  color: hsl(var(--primary-foreground));
  border: 1px solid hsl(var(--primary) / 0.5);
  box-shadow: 0 4px 24px hsl(var(--primary) / 0.25);
  backdrop-filter: blur(8px);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}
.btn-primary:hover {
  background: hsl(var(--primary-hover));
  transform: translateY(-2px);
  box-shadow: 0 8px 32px hsl(var(--primary) / 0.35);
}
```

### Secondary button (ghost)
```css
.btn-secondary {
  padding: 12px 28px;
  border-radius: var(--radius-lg);
  font-size: 0.9rem; font-weight: 600;
  background: hsl(var(--card) / 0.6);
  color: hsl(var(--foreground));
  border: 1px solid hsl(var(--border));
  backdrop-filter: blur(12px);
  transition: all 0.25s;
}
.btn-secondary:hover {
  background: hsl(var(--card) / 0.8);
  border-color: hsl(var(--border-light));
  transform: translateY(-1px);
}
```

---

## Background layers

Three stacked layers for depth:

```html
<div class="bg-layer bg-orbs"><div class="o3"></div></div>
<div class="bg-layer bg-grid"></div>
<div class="bg-layer bg-pattern"></div>
```

```css
.bg-layer {
  position: fixed; inset: 0; pointer-events: none; z-index: -1;
}
```

### Orbs (animated floating blobs)
```css
.bg-orbs::before {
  content: '';
  position: absolute;
  width: 700px; height: 700px;
  top: -20%; left: -15%;
  background: radial-gradient(circle, hsl(0 0% 100% / 0.025) 0%, transparent 65%);
  animation: orbFloat 25s ease-in-out infinite alternate;
}
```

### Grid (subtle lines)
```css
.bg-grid::before {
  content: '';
  position: absolute; inset: 0;
  background-image:
    linear-gradient(hsl(0 0% 100% / 0.015) 1px, transparent 1px),
    linear-gradient(90deg, hsl(0 0% 100% / 0.015) 1px, transparent 1px);
  background-size: 64px 64px;
}
```

### Pattern (repeating SVG logo, auto-scroll)
```css
.bg-pattern::before {
  content: '';
  position: absolute; inset: 0;
  background-image: url('./logo.svg');
  background-repeat: repeat;
  background-size: 120px 120px;
  opacity: 0.035;
  animation: patternSlide 20s linear infinite;
}
@keyframes patternSlide {
  0%   { background-position: 0 0; }
  100% { background-position: 120px -120px; }
}
```

---

## Layout

```css
body {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: hsl(var(--background));
  color: hsl(var(--foreground));
  overflow: hidden;
}
main {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 24px 20px;
}
.container {
  width: 100%; max-width: 1440px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  flex: 1;
}
```

---

## Header (sticky glass)

```css
header {
  position: sticky; top: 0; z-index: 40;
  height: 68px;
  display: flex; align-items: center;
  background: hsl(var(--background) / 0.75);
  backdrop-filter: blur(20px) saturate(1.5);
  border-bottom: 1px solid hsl(var(--border));
}
.header-inner {
  max-width: 1440px; width: 100%; margin: 0 auto;
  display: flex; align-items: center; justify-content: space-between;
  padding: 0 24px;
}
```

---

## Hero (centered content)

```css
.hero {
  display: flex; flex-direction: column; align-items: center;
  text-align: center; max-width: 640px; width: 100%;
}
.hero-icon {
  width: 80px; height: 80px; border-radius: 22px;
  background: hsl(var(--primary) / 0.08);
  border: 1px solid hsl(var(--primary) / 0.15);
  backdrop-filter: blur(12px);
  display: flex; align-items: center; justify-content: center;
  margin-bottom: 20px;
}
.hero h1 {
  font-size: 2.8rem; font-weight: 800;
  letter-spacing: -0.03em; line-height: 1.1;
  color: hsl(var(--foreground));
  margin-bottom: 8px;
}
.hero p {
  font-size: 1rem;
  color: hsl(var(--muted-foreground));
  line-height: 1.6;
  margin-bottom: 20px;
}
```

---

## Discord button (fixed bottom-right)

```css
.discord-btn {
  position: fixed; bottom: 24px; right: 24px;
  display: flex; align-items: center; gap: 10px;
  background: hsl(var(--discord) / 0.15);
  color: #fff;
  padding: 14px 22px;
  border-radius: var(--radius-xl);
  border: 1px solid hsl(var(--discord) / 0.25);
  backdrop-filter: blur(16px);
  z-index: 50;
  box-shadow: 0 4px 24px hsl(var(--discord) / 0.15);
  transition: all 0.3s;
}
.discord-btn:hover {
  background: hsl(var(--discord) / 0.25);
  border-color: hsl(var(--discord) / 0.4);
  transform: translateY(-3px);
}
.discord-btn svg { width: 20px; height: 20px; }
.discord-btn:hover svg {
  transform: rotate(-8deg) scale(1.1);
}
```

---

## Stats (glass row)

```css
.stats-wrap {
  background: hsl(var(--card) / 0.5);
  backdrop-filter: blur(16px) saturate(1.4);
  border: 1px solid hsl(var(--border));
  border-radius: var(--radius-xl);
  padding: 20px 32px;
  margin-top: 28px;
}
.stats {
  display: flex; align-items: center; gap: 24px;
  flex-wrap: wrap; justify-content: center;
}
.stat-item {
  display: flex; align-items: center; gap: 8px;
  font-size: 0.9rem;
  color: hsl(var(--muted-foreground));
}
.stat-item strong { color: hsl(var(--foreground)); }
.stat-sep {
  width: 1px; height: 20px;
  background: hsl(var(--border));
}
```

---

## Features (3-column glass grid)

```css
.features {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
  margin-top: 28px;
  width: 100%;
  max-width: 900px;
  padding: 0 24px;
}
.feature {
  background: hsl(var(--card) / 0.5);
  backdrop-filter: blur(14px) saturate(1.3);
  border: 1px solid hsl(var(--border));
  border-radius: var(--radius-xl);
  padding: 20px 20px;
  display: flex; flex-direction: column; gap: 14px;
  transition: all 0.3s ease;
}
.feature:hover {
  border-color: hsl(var(--primary) / 0.2);
  transform: translateY(-3px);
  box-shadow: 0 12px 40px hsl(0 0% 0% / 0.3);
}
.feature-icon {
  width: 44px; height: 44px; border-radius: 12px;
  background: hsl(var(--primary) / 0.1);
  border: 1px solid hsl(var(--primary) / 0.12);
  display: flex; align-items: center; justify-content: center;
}
.feature-icon svg { width: 20px; height: 20px; color: hsl(var(--primary)); }
.feature h3 { font-size: 1rem; font-weight: 700; color: hsl(var(--foreground)); }
.feature p {
  font-size: 0.875rem;
  color: hsl(var(--muted-foreground));
  line-height: 1.6;
}
```

---

## Modal (glass overlay)

```css
.modal-overlay {
  position: fixed; inset: 0; z-index: 999;
  background: hsl(var(--background) / 0.85);
  backdrop-filter: blur(16px);
  display: flex; align-items: center; justify-content: center;
  padding: 20px;
  opacity: 0; pointer-events: none;
  transition: opacity 0.35s;
}
.modal-overlay.show { opacity: 1; pointer-events: auto; }
.modal {
  background: hsl(var(--card) / 0.85);
  backdrop-filter: blur(24px) saturate(1.5);
  border: 1px solid hsl(var(--primary) / 0.12);
  border-radius: calc(var(--radius-xl) * 1.5);
  max-width: 460px; width: 100%;
  padding: 34px 24px 24px;
  transform: scale(0.95);
  transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 24px 80px hsl(0 0% 0% / 0.5);
}
.modal-overlay.show .modal { transform: scale(1); }
```

---

## Footer

```css
footer {
  text-align: center;
  font-size: 0.8rem;
  color: hsl(var(--muted-foreground) / 0.5);
  display: flex; align-items: center; justify-content: center;
  gap: 8px;
  padding: 16px 24px;
}
footer .sep { opacity: 0.4; }
```

---

## Responsive breakpoints

### 768px and below
- Header height: `60px`
- Hero icon: `64px`, h1: `2rem`
- Stats padding: `12px 16px`, gap: `10px`
- Features: `1 column`
- Pattern size: `50px`
- Main padding: `24px 16px 12px`

### 400px and below
- Nav buttons smaller padding/font

---

## Key rules

1. **Always use HSL** with opacity via `/` syntax: `hsl(var(--primary) / 0.1)`
2. **Glass effect** = `backdrop-filter: blur(...) saturate(...)` + semi-transparent bg + border
3. **Hover transitions**: `cubic-bezier(0.4, 0, 0.2, 1)` for smooth easing
4. **Purple is the only accent color** (`247 60% 61%`), everything else is grayscale
5. **No bold colors** besides the purple accent and the green verified badge
6. **SVG logo with base64 PNG** inside: use as repeating CSS background with `background-position` animation
7. **Everything fits in 100vh** — no scroll, content vertically centered
