/**
 * auto-version.js
 * Automatically updates the version badge and release date on page load.
 * Fetches version from config.json (same origin) and date from GitHub API.
 * Caches the date in localStorage for 1 hour to avoid GitHub API rate limits.
 */
(function () {
  var BADGE = document.querySelector('.version-badge');
  var META = '.hero-meta span:not(.sep):not(.verified):not(#meta-file):not(#meta-size):not(#meta-os)';
  var CACHE_KEY = 'st_version_data';
  var CACHE_TTL = 3600000; // 1 hour

  function formatDate(iso) {
    var d = new Date(iso);
    var months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    return months[d.getUTCMonth()] + ' ' + d.getUTCDate() + ', ' + d.getUTCFullYear();
  }

  function setDate(dateStr) {
    var spans = document.querySelectorAll(META);
    for (var i = 0; i < spans.length; i++) {
      var el = spans[i];
      if (el.querySelector('svg')) continue;
      if (el.classList.contains('sep')) continue;
      el.textContent = dateStr;
    }
  }

  // 1. Fetch version from config.json
  fetch('/config.json?t=' + Date.now())
    .then(function (r) { return r.json(); })
    .then(function (cfg) {
      var ver = cfg.version || cfg['version-linux'];
      if (ver && BADGE) BADGE.textContent = 'v' + ver;

      // 2. Try cache first
      try {
        var cached = JSON.parse(localStorage.getItem(CACHE_KEY));
        if (cached && cached.date && Date.now() - cached.ts < CACHE_TTL) {
          setDate(cached.date);
          return;
        }
      } catch (e) {}

      // 3. Fetch date from GitHub API
      return fetch('https://api.github.com/repos/SteamTools-Team/Config/commits?path=config.json&per_page=1')
        .then(function (r) { return r.json(); })
        .then(function (commits) {
          if (!commits || !commits.length) return;
          var dateStr = formatDate(commits[0].commit.committer.date);
          setDate(dateStr);
          try {
            localStorage.setItem(CACHE_KEY, JSON.stringify({ date: dateStr, ts: Date.now() }));
          } catch (e) {}
        });
    })
    .catch(function () {});
})();
