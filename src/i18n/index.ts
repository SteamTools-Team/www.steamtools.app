import en from './locales/en.json';

export type Translation = typeof en;

export interface Locale {
  /** Translation file name (src/i18n/locales/<code>.json) */
  code: string;
  /** URL segment, e.g. /fr-FR/ */
  path: string;
  hreflang: string;
  /** BCP 47 tag used for date formatting */
  intl: string;
  name: string;
  dir: 'ltr' | 'rtl';
}

// Order = order in the language menu.
export const locales: Locale[] = [
  { code: 'en', path: 'en-EN', hreflang: 'en', intl: 'en-US', name: 'English', dir: 'ltr' },
  { code: 'fr', path: 'fr-FR', hreflang: 'fr', intl: 'fr-FR', name: 'Français', dir: 'ltr' },
  { code: 'zh', path: 'zh-CN', hreflang: 'zh-CN', intl: 'zh-CN', name: '中文', dir: 'ltr' },
  { code: 'es', path: 'es-ES', hreflang: 'es', intl: 'es-ES', name: 'Español', dir: 'ltr' },
  { code: 'hi', path: 'hi-IN', hreflang: 'hi', intl: 'hi-IN', name: 'हिन्दी', dir: 'ltr' },
  { code: 'ar', path: 'ar-AR', hreflang: 'ar', intl: 'ar-u-nu-latn', name: 'العربية', dir: 'rtl' },
  { code: 'pt', path: 'pt-BR', hreflang: 'pt', intl: 'pt-BR', name: 'Português', dir: 'ltr' },
  { code: 'ru', path: 'ru-RU', hreflang: 'ru', intl: 'ru-RU', name: 'Русский', dir: 'ltr' },
  { code: 'ja', path: 'ja-JP', hreflang: 'ja', intl: 'ja-JP', name: '日本語', dir: 'ltr' },
  { code: 'de', path: 'de-DE', hreflang: 'de', intl: 'de-DE', name: 'Deutsch', dir: 'ltr' },
  { code: 'ko', path: 'ko-KR', hreflang: 'ko', intl: 'ko-KR', name: '한국어', dir: 'ltr' },
  { code: 'vi', path: 'vi-VN', hreflang: 'vi', intl: 'vi-VN', name: 'Tiếng Việt', dir: 'ltr' },
  { code: 'tr', path: 'tr-TR', hreflang: 'tr', intl: 'tr-TR', name: 'Türkçe', dir: 'ltr' },
  { code: 'it', path: 'it-IT', hreflang: 'it', intl: 'it-IT', name: 'Italiano', dir: 'ltr' },
  { code: 'pl', path: 'pl-PL', hreflang: 'pl', intl: 'pl-PL', name: 'Polski', dir: 'ltr' },
  { code: 'nl', path: 'nl-NL', hreflang: 'nl', intl: 'nl-NL', name: 'Nederlands', dir: 'ltr' },
  { code: 'id', path: 'id-ID', hreflang: 'id', intl: 'id-ID', name: 'Bahasa Indonesia', dir: 'ltr' },
];

export const defaultLocale = locales[0];

const files = import.meta.glob<Translation>('./locales/*.json', { eager: true, import: 'default' });

export function getTranslation(code: string): Translation {
  const t = files[`./locales/${code}.json`];
  if (!t) throw new Error(`Missing translation file: src/i18n/locales/${code}.json`);
  return t;
}
