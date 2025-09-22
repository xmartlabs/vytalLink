(function () {
  // Fallback bundle (temporary). When GitHub releases are ready, switch to the commented alternative.
  const DEFAULT_BUNDLE_URL = 'https://firebasestorage.googleapis.com/v0/b/vytallink.firebasestorage.app/o/releases%2FVytalLink%20MCP%20Server.mcpb?alt=media';
  // const DEFAULT_BUNDLE_URL = 'https://github.com/xmartlabs/vytalLink/releases/latest/download/vytallink-mcp-server.mcpb';
  const bundleUrl = window.VYTALLINK_MCPB_URL || DEFAULT_BUNDLE_URL;

  function applyBundleLinks(url) {
    document.querySelectorAll('[data-bundle-download]').forEach((element) => {
      element.setAttribute('href', url);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => applyBundleLinks(bundleUrl));
  } else {
    applyBundleLinks(bundleUrl);
  }
})();
