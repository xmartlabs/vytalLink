
# vytalLink Landing

This is the public landing page for vytalLink.

- Hosted on **Firebase Hosting**
- Public URL: https://vytallink.xmartlabs.com/

## Local development

To preview locally:

```bash
firebase serve --only hosting --port 5000
```

Then open [http://localhost:5000](http://localhost:5000) in your browser.

## Styles structure

The landing styles are now modularized:

- Entry point: `public/styles.css` (imports only; order matters)
- Partials live in `public/styles/` and are grouped by section, e.g. `01-nav.css`, `04-hero.css`, `07-demo-integrations.css`, etc.
- Edit the partials, not `public/styles.css`. Keep imports order if adding new files.

### Build a single CSS file (optional)

To concatenate all partials into a single `public/styles.css` (no `@import`s):

```bash
scripts/build-css.sh
```

## Navigation

- The navbar HTML lives at the top of each page in `public/*.html`.
- Mobile vs desktop visibility uses utility classes:
  - `desktop-only`: visible on desktop (e.g., Home anchors), hidden on mobile
  - `mobile-only`: visible on mobile (unified menu items), hidden on desktop
- The “Setup Guides” dropdown is desktop-only. On mobile, these links appear as plain items in the unified list.
- Mobile menu behavior is handled in `public/script.js` (hamburger toggles an overlay and adds `body.menu-open` to disable background scroll).

### Mobile menu UX

- Full‑screen overlay, scrolleable content, and sticky “Download App” button at the bottom (respects iOS safe‑area).
- To adjust spacing or items, edit the `<div class="nav-menu">` blocks and the mobile styles in `public/styles/01-nav.css`.

## Deploy

To deploy to production:

```bash
firebase deploy --only hosting
```

Make sure you are authenticated with Firebase CLI (`firebase login`) and have the correct project selected (`firebase use`).
