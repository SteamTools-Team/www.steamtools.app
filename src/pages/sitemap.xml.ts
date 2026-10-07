import type { APIRoute } from 'astro';
import { locales } from '../i18n';

export const GET: APIRoute = ({ site }) => {
  const url = (path: string) => new URL(path, site).href;
  const alternates = locales
    .map((l) => `    <xhtml:link rel="alternate" hreflang="${l.hreflang}" href="${url(`/${l.path}/`)}"/>`)
    .join('\n');
  const lastmod = new Date().toISOString().slice(0, 10);
  const entry = (path: string, priority: string) => `  <url>
    <loc>${url(path)}</loc>
    <lastmod>${lastmod}</lastmod>
    <priority>${priority}</priority>
${alternates}
    <xhtml:link rel="alternate" hreflang="x-default" href="${url('/')}"/>
  </url>`;

  const body = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
${[entry('/', '1.0'), ...locales.map((l) => entry(`/${l.path}/`, '0.9'))].join('\n')}
  <url>
    <loc>${url('/fixes/')}</loc>
    <lastmod>${lastmod}</lastmod>
    <priority>0.5</priority>
  </url>
</urlset>
`;
  return new Response(body, { headers: { 'Content-Type': 'application/xml; charset=utf-8' } });
};
