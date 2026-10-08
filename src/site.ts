/**
 * Release data comes from the SteamTools-Team/Config repo (the same source the
 * app uses). It is fetched once at build time, and the version is refreshed in
 * the browser (see Base.astro) so a new release shows up without a redeploy.
 */

export type Os = 'windows' | 'linux';

const CONFIG_REPO = 'SteamTools-Team/Config';
const RAW = `https://raw.githubusercontent.com/${CONFIG_REPO}/refs/heads/main`;

const DOWNLOAD = `https://github.com/${CONFIG_REPO}/raw/refs/heads/main`;

export const configUrl = `${RAW}/config.json`;
export const releaseDateApi = `https://api.github.com/repos/${CONFIG_REPO}/commits?path=config.json&per_page=1`;

export const links = {
  github: 'https://github.com/SteamTools-Team',
  discord: 'https://www.steamtools.app/discord',
  manifest: 'https://manilua.steamtools.app',
  shop: 'https://shop.steamtools.app',
};

export const platforms: Record<Os, { name: string; file: string; url: string; configKey: string; fallbackMb: number }> = {
  windows: { name: 'Windows', file: 'SteamTools.exe', url: `${DOWNLOAD}/SteamTools.exe`, configKey: 'version', fallbackMb: 23.9 },
  linux: { name: 'Linux', file: 'SteamTools-linux', url: `${DOWNLOAD}/SteamTools-linux`, configKey: 'version-linux', fallbackMb: 10.1 },
};

/** "2.79-Linux" -> "2.79" */
export const cleanVersion = (v: string) => v.replace(/-linux$/i, '');

export interface Release {
  versions: Record<Os, string>;
  sizesMb: Record<Os, number>;
  date: string | null;
}

const getJson = (url: string) =>
  fetch(url, { headers: { 'User-Agent': 'steamtools-website-build' } })
    .then((r) => (r.ok ? r.json() : null))
    .catch(() => null);

let release: Promise<Release> | undefined;

export function getRelease(): Promise<Release> {
  release ??= (async () => {
    const [config, files, commits] = await Promise.all([
      getJson(configUrl),
      getJson(`https://api.github.com/repos/${CONFIG_REPO}/contents`),
      getJson(releaseDateApi),
    ]);
    const local = (await import('../public/config.json')).default as Record<string, string>;
    const cfg: Record<string, string> = config ?? local;

    const sizeOf = (os: Os) => {
      const f = Array.isArray(files) ? files.find((x: { name: string }) => x.name === platforms[os].file) : null;
      return f ? Math.round((f.size / 1e6) * 10) / 10 : platforms[os].fallbackMb;
    };
    const versionOf = (os: Os) => cleanVersion(cfg[platforms[os].configKey] ?? cfg.version);

    return {
      versions: { windows: versionOf('windows'), linux: versionOf('linux') },
      sizesMb: { windows: sizeOf('windows'), linux: sizeOf('linux') },
      date: commits?.[0]?.commit?.committer?.date ?? null,
    };
  })();
  return release;
}
