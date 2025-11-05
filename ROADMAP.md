# 🧭 Roadmap

> _“Refinement is the process of removing everything that does not serve truth.”_

This roadmap defines the **strategic direction**, **technical milestones**, and **feature phases** of the portfolio project.  
It serves as both a development plan and a philosophical guide — merging aesthetics, systems thinking, and privacy-first engineering.

---

## 🎯 Project Vision

To create a **local-first, Markdown-driven, privacy-first publication framework**  
— a living system for personal knowledge, work, and philosophy.

No databases.  
No backend dependencies.  
No external analytics.  
Just **clarity, control, and code**.

This portfolio doubles as:

- a static site deployed via **GitHub Pages**,
- a self-contained **Flutter Web** app,
- a personal documentation and publishing platform.

---

## 🧱 Phase 1 — Foundation (✅ Completed)

> Initial environment setup and core architecture.

| Goal                       | Status | Deliverable                                 |
| -------------------------- | ------ | ------------------------------------------- |
| Initialize Flutter project | ✅     | `flutter create portfolio`                  |
| Configure `.env` handling  | ✅     | `flutter_dotenv` + `env.dart`               |
| Core Markdown engine       | ✅     | `flutter_markdown_plus` integration         |
| Front-matter parser        | ✅     | `front_matter.dart`                         |
| GoRouter navigation        | ✅     | Declarative, deep-link aware routes         |
| Provider state             | ✅     | Lightweight dependency management           |
| Responsive UI setup        | ✅     | `responsive_framework` integrated           |
| Theme system               | ✅     | Material 3 theme palette + dark/light modes |
| Asset organization         | ✅     | `/assets/contents` with unified structure   |
| Auth prototype             | ✅     | Local AES-GCM with canary validation        |
| GitHub Actions             | ✅     | `deploy_pages.yml`, `releases.yml`          |
| Dependabot + CODEOWNERS    | ✅     | Dependency tracking and code review rules   |

📦 **Deliverable:**  
Functional site build, Markdown-based content loading, theming, authentication prototype, and GitHub Pages deploy pipeline.

---

## 💅 Phase 2 — UI, UX & Responsiveness (🔄 In Progress)

> Enhancing adaptability, visual balance, and cross-device layout.

| Goal                     | Description                                   | Status        |
| ------------------------ | --------------------------------------------- | ------------- |
| Responsive layout system | Unified padding/margin across pages           | ✅ Done       |
| Adaptive typography      | Font scaling with `MediaQuery.textScaler`     | 🔄 Refining   |
| Navigation bar refactor  | AppBar + Drawer for smaller breakpoints       | ✅ Done       |
| Timeline page            | Chronological record of milestones & releases | ✅ Integrated |
| Overflow handling        | Fix for horizontal flex overflows             | ✅ Done       |
| App shell improvements   | Consistent padding + breakpoint awareness     | ✅ Done       |
| Theme switching          | Palette + mode persistence                    | ✅ Done       |
| Smooth transitions       | Animated page fades and route transitions     | 🧩 Planned    |
| Accessibility checks     | Focus, ARIA, contrast, reduced motion         | 🔄 Partial    |

🎨 **Deliverable:**  
Visually consistent, accessible interface that feels intentional on every screen size — mobile, tablet, desktop.

---

## 🔐 Phase 3 — Auth, Privacy & Encryption (✅ Core Complete)

> Strengthen security while maintaining simplicity.

| Goal                      | Description                                | Status  |
| ------------------------- | ------------------------------------------ | ------- |
| AES-GCM local encryption  | Encrypt private markdown sections          | ✅ Done |
| Argon2id key derivation   | Derive keys securely from passphrase       | ✅ Done |
| Passphrase validation     | Canary-based verification before unlock    | ✅ Done |
| Persistent session        | Auth state saved in `SharedPreferences`    | ✅ Done |
| Login UX                  | Lock/unlock via dialog (LockGate)          | ✅ Done |
| Private/public visibility | Correct badges and state reflection        | ✅ Done |
| Logout workflow           | Manual & automatic expiration clear        | ✅ Done |
| `.env` integration        | Canary salt, nonce, mac defined in secrets | ✅ Done |

🔒 **Deliverable:**  
Fully self-contained local auth that unlocks encrypted markdown using client-only cryptography — no external services.

---

## 🌍 Phase 4 — Localization (🔄 Expanding)

> Make the portfolio accessible in English, Chinese, and Malay.

| Goal                       | Description                            | Status     |
| -------------------------- | -------------------------------------- | ---------- |
| Flutter localization setup | ARB + `flutter gen-l10n` integration   | ✅ Done    |
| English localization       | `app_en.arb`                           | ✅ Done    |
| Chinese (Simplified)       | `app_zh.arb`                           | ✅ Done    |
| Malay                      | `app_ms.arb`                           | ✅ Done    |
| Language selector UI       | Dropdown on header/footer              | ✅ Done    |
| Persistent locale          | Saved and restored from preferences    | ✅ Done    |
| Content localization       | `lang:` field in Markdown front-matter | 🔄 Partial |
| Auto-detect locale         | Read browser/system locale             | 🧩 Planned |

🌐 **Deliverable:**  
All UI and major pages available in three languages, with automatic detection and manual override.

---

## 🔍 Phase 5 — Search, SEO & Metadata (🧩 Upcoming)

> Introduce discoverability, internal search, and metadata automation.

| Goal                    | Description                                 | Status     |
| ----------------------- | ------------------------------------------- | ---------- |
| Manifest builder        | JSON manifest via `build_manifest.dart`     | ✅ Done    |
| Markdown indexer        | `search_index.dart` parses all front-matter | ✅ Done    |
| Local search UI         | Live fuzzy search for titles/tags           | 🧩 Planned |
| Dynamic metadata        | `<meta>` + OG/Twitter tags                  | 🔄 Partial |
| Sitemap & RSS generator | `gen_sitemap.dart` + `gen_rss.dart`         | ✅ Done    |
| Canonical routing       | Slug-based canonical URLs                   | ✅ Done    |
| Timeline integration    | Display major releases in `/timeline`       | ✅ Done    |

🔎 **Deliverable:**  
A self-documenting site that is SEO-friendly while preserving local-first privacy (no Google Analytics).

---

## 🧩 Phase 6 — Automation & Releases (🧩 Planned)

> Automate build, deploy, and content validation.

| Goal                       | Description                            | Status     |
| -------------------------- | -------------------------------------- | ---------- |
| GitHub Actions deploy      | `deploy_pages.yml` → `gh-pages` branch | ✅ Done    |
| GitHub Releases automation | Tagged builds with artifacts           | ✅ Done    |
| Dependabot updates         | Weekly dependency review               | ✅ Done    |
| Content validator          | YAML & markdown structure linter       | 🧩 Planned |
| Pre-release preview        | Build to `staging` branch              | 🧩 Planned |
| Release manifest           | JSON changelog generator               | 🧩 Planned |
| Semantic versioning        | Tag + CI auto-bump                     | 🧩 Planned |

⚙️ **Deliverable:**  
A self-maintaining CI/CD pipeline that verifies, builds, and publishes both the Flutter app and content automatically.

---

## 🧠 Phase 7 — Foundation & Philosophy (Ongoing)

> Preserve and communicate the underlying worldview — “calm, ethical, systemic.”

| Goal                        | Description                                            | Status  |
| --------------------------- | ------------------------------------------------------ | ------- |
| Foundation section          | `/foundation/` renders essays and systems notes        | ✅ Done |
| Meta ethics                 | Includes `ethics-llm-evals`, `justice-manifesto`, etc. | ✅ Done |
| Work philosophy             | Markdown-driven “why” behind each project              | ✅ Done |
| Calm technology integration | `calm-technology.md` reference                         | ✅ Done |
| Decision logs               | Chronicle via `decision-log-001.md`                    | ✅ Done |

📘 **Deliverable:**  
A readable foundation for Desmond’s principles, with permanent records of decisions and design values.

---

## 🕰️ Phase 8 — Timeline & Reflection (Ongoing)

> Document evolution, iterations, and milestones visually and textually.

| Goal                            | Description                                | Status     |
| ------------------------------- | ------------------------------------------ | ---------- |
| `/timeline` route               | Dedicated route showing historical entries | ✅ Done    |
| Auto-link to commits            | Link milestones to GitHub commits          | 🧩 Planned |
| Styled event cards              | Reusable `TimelineEvent` widget            | ✅ Done    |
| Scrollable chronological layout | Responsive list layout                     | ✅ Done    |
| Integration with manifest       | Pull event metadata from front-matter      | ✅ Done    |
| Reflect releases                | Show tagged versions automatically         | 🧩 Planned |

🪶 **Deliverable:**  
A living historical narrative that visually reflects how Desmond’s work evolves over time.

---

## 🧾 Maintenance Plan

| Task                     | Frequency        | Notes                      |
| ------------------------ | ---------------- | -------------------------- |
| Markdown content updates | Continuous       | via Git commits            |
| Dependency upgrades      | Monthly          | Dependabot PRs             |
| `.env` rotation          | Quarterly        | Manual                     |
| Backup                   | Weekly           | Mirror to secondary host   |
| Release tagging          | Per major change | Semantic versioning        |
| Accessibility audit      | Semiannual       | Lighthouse & manual review |

---

## 🔮 Future Concepts (Phase 9+)

> Experimental ideas and long-term refinements.

- 🧩 **Offline-first PWA mode** via service worker
- 🧩 **Local Markdown editor** for quick note creation
- 🧩 **Encrypted “journal” mode** with on-device storage
- 🧩 **AI-assisted indexing** for related reading suggestions
- 🧩 **Color palette generator** for aesthetic personalization
- 🧩 **Cross-sync with Obsidian vaults or local filesystem**

---

## 🧾 Progress Summary

| Phase | Title                   | Status           |
| ----- | ----------------------- | ---------------- |
| 1     | Foundation              | ✅ Done          |
| 2     | UI & Responsiveness     | 🔄 In Progress   |
| 3     | Auth & Privacy          | ✅ Core Complete |
| 4     | Localization            | 🔄 Expanding     |
| 5     | Search & SEO            | 🧩 Upcoming      |
| 6     | Automation & Releases   | 🧩 Planned       |
| 7     | Foundation & Philosophy | ✅ Done          |
| 8     | Timeline & Reflection   | ✅ Active        |
| 9     | Future Concepts         | 🧩 Research      |

---

## 💬 Closing Note

> “Build once. Publish forever.”

This is not just a website.  
It’s a **living operating system for ideas**, a self-contained archive of Desmond’s life and work — built to evolve, ethically and technically.

---

MIT License © Desmond Liew  
All rights reserved where applicable.
