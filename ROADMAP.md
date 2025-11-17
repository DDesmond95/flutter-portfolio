# 🧭 Roadmap

> _“Refinement is removing everything that does not serve truth.”_

This roadmap defines the long-term direction of the portfolio system — balancing software engineering, aesthetics, privacy, and personal philosophy.

The project is a **local-first, Markdown-driven, privacy-preserving publication system**, built entirely with **Flutter Web**, deployed through **GitHub Pages**, and powered by a **private content repository**.

---

# 🎯 Vision

To maintain a **self-contained personal operating system for ideas**:

- No backend
- No databases
- No analytics
- Total ownership of content
- Sustainable, minimal, elegant

The system is:

- A public portfolio
- A private research archive
- A publishing tool
- A philosophical notebook
- A technical playground

---

# 🧱 Phase 1 — Foundation

### _Status: ✅ Completed_

Core structure, architecture, and essential tooling.

| Goal                    | Status      | Notes                                              |
| ----------------------- | ----------- | -------------------------------------------------- |
| Flutter project setup   | ✅          | App shell, modules, environment                    |
| Markdown renderer       | ✅          | `flutter_markdown_plus`, front-matter              |
| Routing                 | ✅          | `go_router` + deep linking                         |
| State management        | ✅          | Provider                                           |
| Asset system            | ⚠️ Updated  | Now a **private submodule** (`Portfolio-Contents`) |
| Theme engine            | ✅          | Material 3 + palettes                              |
| Auth prototype          | ✅          | Local AES + Argon2id                               |
| CI setup                | ✅          | Lint, analyze                                      |
| GitHub Pages deployment | ⚠️ Enhanced | PAT-authenticated submodule checkout               |

**Deliverable:**
A stable, fully working foundation.

---

# 💅 Phase 2 — UI, UX & Responsiveness

### _Status: 🔄 Active_

Refining ergonomics, consistency, and layout.

| Goal                   | Status | Notes                             |
| ---------------------- | ------ | --------------------------------- |
| Layout & spacing rules | ✅     | Unified responsive grid           |
| Typography scaling     | 🔄     | Needs polishing on tablet classes |
| Navigation redesign    | ✅     | Drawer, compact header            |
| Timeline UI            | ✅     | Integrated, responsive            |
| Overflow fixes         | ✅     | Flex + adaptive breakpoints       |
| App shell refinement   | ✅     | Smoother transitions planned      |
| Accessibility          | 🔄     | Contrast + keyboard traversal     |

**Deliverable:**
A balanced, smooth UI that works on every device.

---

# 🔐 Phase 3 — Auth, Privacy & Encryption

### _Status: 🛡️ Core Complete_

Local-only cryptography.

| Goal                      | Status     | Notes                                                |
| ------------------------- | ---------- | ---------------------------------------------------- |
| AES-GCM encryption        | ✅         | Per-block encrypted Markdown                         |
| Argon2id KDF              | ✅         | Strong local key derivation                          |
| Passphrase canary         | ⚠️ Refined | Canary now stored via **GitHub Secrets**, not `.env` |
| Unlock/Lock UX            | ✅         | LockGate + persistent session                        |
| Private/public visibility | ✅         | Accurate conditional rendering                       |

**Deliverable:**
Stable client-side encrypted content system.

---

# 🌍 Phase 4 — Localization

### _Status: 🔄 Expanding_

| Goal                 | Status     | Notes                           |
| -------------------- | ---------- | ------------------------------- |
| gen-l10n setup       | ✅         | Complete                        |
| English              | ✅         |                                 |
| Chinese (Simplified) | ✅         |                                 |
| Malay                | ✅         |                                 |
| Locale selector      | ✅         |                                 |
| Locale persistence   | ✅         |                                 |
| Localized Markdown   | 🔄         | Partial — some sections missing |
| Auto-detect locale   | 🧩 Planned |                                 |

---

# 🔍 Phase 5 — Search, SEO & Metadata

### _Status: 🧩 Upcoming_

| Goal             | Status   | Notes                            |
| ---------------- | -------- | -------------------------------- |
| Content manifest | ✅       | `build_manifest.dart`            |
| Search index     | ⚠️ Ready | Back-end logic complete; UI next |
| Search UI        | 🧩       | Planned fuzzy-search modal       |
| Metadata engine  | 🔄       | Partial OG/Twitter tags          |
| Sitemap          | ✅       |                                  |
| RSS feed         | ✅       |                                  |
| Canonical routes | ✅       |                                  |

---

# 🧩 Phase 6 — Automation, CI & Releases

### _Status: 🧩 Planned / Partial Complete_

| Goal                  | Status      | Notes                       |
| --------------------- | ----------- | --------------------------- |
| Multi-platform builds | ✅          | Windows, Linux, Android     |
| Release automation    | ✅          | Auto attach build artifacts |
| Private submodule CI  | ⚠️ Complete | Using PAT-based checkout    |
| Content validator     | 🧩 Planned  | YAML/MD structure linter    |
| Semantic versioning   | 🧩 Planned  |                             |
| Staging deployments   | 🧩 Planned  |                             |

---

# 🧠 Phase 7 — Philosophy & Foundations

### _Status: 📘 Mature_

Documentation of thought, systems, ethics, and worldview.

| Goal                 | Status     |
| -------------------- | ---------- |
| Foundation essays    | ✅         |
| Ethics & philosophy  | ✅         |
| Systems & frameworks | ✅         |
| Decision logs        | 🔄 Growing |

---

# 🕰 Phase 8 — Timeline & Reflection

### _Status: 🪶 Active_

| Goal                    | Status     | Notes |
| ----------------------- | ---------- | ----- |
| Timeline route          | ✅         |       |
| Event cards             | ✅         |       |
| Markdown-driven entries | ✅         |       |
| Release integration     | 🧩 Planned |       |
| GitHub commit linkage   | 🧩 Planned |       |

---

# 🔮 Phase 9 — Future Concepts

### _Status: Research_

These are long-term ideas:

- Offline-first PWA mode
- Local Markdown editor
- Encrypted journal mode
- Local graph / backlinks
- Related-content auto suggestion
- Palette generator for theming
- Interactive data visualizations
- Obsidian vault sync (local filesystem)

---

# 🧾 Maintenance Plan

| Task                | Frequency   | Notes               |
| ------------------- | ----------- | ------------------- |
| Content updates     | Continuous  | via submodule       |
| Dependency updates  | Monthly     | Dependabot          |
| Canary rotation     | Quarterly   | via GitHub Secrets  |
| Backup mirroring    | Weekly      | Private remote      |
| Release tagging     | Per feature | Manual or CI-driven |
| Accessibility audit | Semiannual  | Lighthouse + manual |

---

# 📊 Progress Summary

| Phase | Title           | Status           |
| ----- | --------------- | ---------------- |
| 1     | Foundation      | ✅ Complete      |
| 2     | UX & UI         | 🔄 Active        |
| 3     | Auth & Privacy  | 🛡️ Core Complete |
| 4     | Localization    | 🔄 Expanding     |
| 5     | Search & SEO    | 🧩 Upcoming      |
| 6     | Automation      | 🧩 Planned       |
| 7     | Philosophy      | 📘 Mature        |
| 8     | Timeline        | 🪶 Active        |
| 9     | Future Concepts | Research         |

---

# 💬 Final Note

> _“Build once. Publish forever.”_
> This roadmap is a living document — evolving as the system evolves.
