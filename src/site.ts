import config from '../public/config.json';

export const version = config.version;

export const links = {
  github: 'https://github.com/SteamTools-Team',
  discord: 'https://www.steamtools.app/discord',
  manifest: 'https://manilua.steamtools.app',
  shop: 'https://shop.steamtools.app',
};

export const downloads = {
  windows: {
    url: 'https://github.com/SteamTools-Team/Config/raw/refs/heads/main/SteamTools.exe',
    file: 'SteamTools.exe',
    size: '14.7',
    os: 'Windows / Linux',
  },
  linux: {
    url: 'https://github.com/SteamTools-Team/Config/raw/refs/heads/main/SteamTools-linux',
    file: 'SteamTools-linux',
    size: '13.2',
    os: 'Linux / macOS',
  },
};

export const releaseDateApi =
  'https://api.github.com/repos/SteamTools-Team/Config/commits?path=config.json&per_page=1';

let releaseDate: Promise<string | null> | undefined;

/** Date of the last release (fetched once per build, refreshed client-side). */
export function getReleaseDate(): Promise<string | null> {
  releaseDate ??= fetch(releaseDateApi)
    .then((r) => (r.ok ? r.json() : null))
    .then((commits) => commits?.[0]?.commit?.committer?.date ?? null)
    .catch(() => null);
  return releaseDate;
}
