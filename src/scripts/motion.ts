/**
 * Motion layer. Everything here is progressive enhancement: without JS, or with
 * prefers-reduced-motion, content is simply shown in its final state.
 */
const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
const finePointer = matchMedia('(hover: hover) and (pointer: fine)').matches;
const root = document.documentElement;

/* ── Nav: compact state once the page is scrolled ──────────── */
const nav = document.querySelector<HTMLElement>('.nav');
if (nav) {
  const onScroll = () => nav.classList.toggle('is-scrolled', scrollY > 8);
  onScroll();
  addEventListener('scroll', onScroll, { passive: true });
}

/* ── Count-up: animates the first number in "150,000+", "~24 MB"… ── */
function countUp(el: HTMLElement) {
  const text = el.textContent ?? '';
  const match = text.match(/\d[\d.,\s  ]*\d|\d/);
  if (!match) return;
  const raw = match[0];
  const target = Number(raw.replace(/\D/g, ''));
  if (!target) return;
  const sep = raw.match(/\D/)?.[0] ?? '';
  const format = (n: number) => (sep ? String(n).replace(/\B(?=(\d{3})+(?!\d))/g, sep) : String(n));
  const before = text.slice(0, match.index);
  const after = text.slice((match.index ?? 0) + raw.length);
  const duration = 1400;
  const start = performance.now();
  el.style.minWidth = `${el.offsetWidth}px`;
  const tick = (now: number) => {
    const p = Math.min(1, (now - start) / duration);
    const eased = 1 - Math.pow(1 - p, 4);
    el.textContent = before + format(Math.round(target * eased)) + after;
    if (p < 1) requestAnimationFrame(tick);
  };
  requestAnimationFrame(tick);
}

/* ── Scroll reveal ─────────────────────────────────────────── */
const revealables = document.querySelectorAll<HTMLElement>('[data-reveal]');
if (reduced || !('IntersectionObserver' in window)) {
  revealables.forEach((el) => el.classList.add('is-in'));
} else {
  const io = new IntersectionObserver(
    (entries) => {
      for (const entry of entries) {
        if (!entry.isIntersecting) continue;
        const el = entry.target as HTMLElement;
        el.classList.add('is-in');
        el.querySelectorAll<HTMLElement>('[data-count]').forEach(countUp);
        io.unobserve(el);
      }
    },
    { rootMargin: '0px 0px -12% 0px', threshold: 0.15 },
  );
  revealables.forEach((el) => io.observe(el));
}

if (!reduced && finePointer) {
  /* ── Spotlight that follows the cursor on cards ──────────── */
  document.querySelectorAll<HTMLElement>('.spot').forEach((card) => {
    card.addEventListener('pointermove', (e) => {
      const r = card.getBoundingClientRect();
      card.style.setProperty('--mx', `${e.clientX - r.left}px`);
      card.style.setProperty('--my', `${e.clientY - r.top}px`);
    });
  });

  /* ── 3D tilt on the app icon, eased with a spring-ish lerp ── */
  const tilt = document.querySelector<HTMLElement>('[data-tilt]');
  if (tilt) {
    let tx = 0, ty = 0, x = 0, y = 0, raf = 0;
    const loop = () => {
      x += (tx - x) * 0.08;
      y += (ty - y) * 0.08;
      tilt.style.setProperty('--rx', `${(-y * 14).toFixed(2)}deg`);
      tilt.style.setProperty('--ry', `${(x * 14).toFixed(2)}deg`);
      raf = Math.abs(tx - x) + Math.abs(ty - y) > 0.001 ? requestAnimationFrame(loop) : 0;
    };
    addEventListener('pointermove', (e) => {
      const r = tilt.getBoundingClientRect();
      const cx = r.left + r.width / 2;
      const cy = r.top + r.height / 2;
      tx = Math.max(-1, Math.min(1, (e.clientX - cx) / (innerWidth / 2)));
      ty = Math.max(-1, Math.min(1, (e.clientY - cy) / (innerHeight / 2)));
      if (!raf) raf = requestAnimationFrame(loop);
    }, { passive: true });
  }
}

root.classList.add('motion-ready');
