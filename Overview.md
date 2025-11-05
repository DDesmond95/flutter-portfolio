# Project Overview

**Personal Portfolio**

> A local-first, Markdown-powered portfolio and publication system.  
> Built entirely with Flutter, optimized for privacy, modularity, and longevity.

---

## 🌐 Vision

This project is a **fusion of identity, ethics, and engineering** — a living, evolving document of work, thought, and design.

It’s not just a portfolio; it’s a **personal information system**:

- **Readable in Markdown**
- **Rendered with Flutter Web**
- **Deployed on GitHub Pages**
- **Operates locally without servers**

Every word, image, and layout is designed for clarity and sustainability — portable, inspectable, and free of proprietary lock-in.

---

## ⚙️ Core Architecture

| Layer                          | Description                                                                                                                                                               |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Markdown Content Layer**     | All pages, blogs, and projects exist as `.md` files in `/assets/contents`. These files use YAML front-matter for metadata like `title`, `date`, `slug`, and `visibility`. |
| **Flutter Presentation Layer** | Renders content using Material 3, responsive layouts, and localized text. Each `.md` document is parsed into widgets at runtime.                                          |
| **Routing System**             | Uses `go_router` to map slugs directly to routes (`/blog/:slug`, `/projects/:slug`, etc.), making every page deep-linkable.                                               |
| **Theming System**             | Based on Material 3 `ColorScheme.fromSeed` and dynamic palette switching (`metal`, `earth`, `wood`, `fire`, `water`).                                                     |
| **Localization Layer**         | Multi-language interface via Flutter’s `l10n` — English, 中文, and Bahasa Melayu.                                                                                         |
| **Authentication Layer**       | Local AES-GCM encryption to reveal private Markdown content after a passphrase login. No remote backend.                                                                  |
| **Persistence Layer**          | Local state is stored via `SharedPreferences` (theme, palette, language, auth).                                                                                           |
| **Deployment Layer**           | Built with GitHub Actions → Deployed to GitHub Pages and tagged via GitHub Releases.                                                                                      |

---

## 🧩 Design Principles

1. **Local-first architecture**

   - Everything lives in Markdown and Git.
   - Editable offline, deployable directly via CI/CD.

2. **Privacy-first philosophy**

   - No analytics or tracking.
   - Auth is client-side; nothing leaves your browser.

3. **Transparent by design**

   - Source code and content coexist in one repository.
   - Public and private content differ only by encryption.

4. **Sustainable presentation**
   - Adaptive typography.
   - Responsive layouts that scale gracefully on desktop, tablet, and mobile.

---

## 🔐 Authentication Concept

Unlike typical web apps, login here is **symbolic and local**:

- Passphrase unlocks private Markdown files.
- Encryption uses AES-GCM with PBKDF2-derived keys.
- No external API calls — pure client-side decryption.

This aligns with the principle of _sovereign publishing_:  
your data never leaves your device, and privacy is intrinsic to the medium.

---

## 🧠 Modular Structure

| Module                 | Purpose                                   |
| ---------------------- | ----------------------------------------- |
| `/features/home`       | Landing and dynamic intro tiles.          |
| `/features/blog`       | Articles and essays.                      |
| `/features/projects`   | Technical and creative projects.          |
| `/features/labs`       | Experiments, prototypes, and tools.       |
| `/features/foundation` | Ethics, philosophy, and principles.       |
| `/features/library`    | Readings, influences, and research notes. |
| `/features/resume`     | Curriculum vitae and background.          |
| `/features/auth`       | Login, logout, passphrase validation.     |

---

## 🧱 Technology Stack

| Category         | Package                                                            |
| ---------------- | ------------------------------------------------------------------ |
| UI / Framework   | `flutter`, `google_fonts`, `responsive_framework`                  |
| Routing          | `go_router`                                                        |
| Markdown         | `flutter_markdown_plus`, `yaml`, `http`, `path`                    |
| State Management | `provider`                                                         |
| Encryption       | `cryptography`                                                     |
| Persistence      | `shared_preferences`                                               |
| Environment      | `flutter_dotenv`                                                   |
| Localization     | `flutter_localizations`, ARB files generated by `flutter gen-l10n` |
| Hosting          | GitHub Pages (via CI/CD workflow)                                  |

---

## 🌍 Localization Design

- Default: **English**
- Supported: **中文**, **Bahasa Melayu**
- Language preference is saved in local storage.
- All UI strings are centralized under `/lib/l10n/`.

Example ARB snippet:

```json
{
  "homeTitle": "Welcome",
  "homeSubtitle": "Explore Desmond’s work and philosophy.",
  "@homeTitle": {
    "description": "Title text for the homepage"
  }
}
```

---

## 🎨 Theming Model

Color and typography are rooted in five symbolic palettes:

| Palette | Core Emotion | Color     | Mood                    |
| ------- | ------------ | --------- | ----------------------- |
| Metal   | Clarity      | `#556B8E` | Rational, calm, refined |
| Earth   | Stability    | `#996B2F` | Grounded, enduring      |
| Wood    | Growth       | `#2E7D4F` | Organic, balanced       |
| Fire    | Drive        | `#CF3D2E` | Passionate, dynamic     |
| Water   | Reflection   | `#1F7A8C` | Deep, intuitive         |

Theme preference persists between sessions and syncs with system dark/light mode.

---

## 🚀 Deployment Workflow

1. **Push to `main` branch**
   → triggers GitHub Action to build Flutter web release
   → deploys `build/web` to GitHub Pages

2. **Tag a release**
   → generates a new build
   → updates the `release.yml` workflow
   → optionally bumps version in `pubspec.yaml`

Environment secrets (`.env`) are **not committed** but can be embedded in GitHub repo settings for build-time injection.

---

## 🧩 Philosophy of Work

> “To publish is to preserve thought, to code is to clarify it.”

This portfolio stands as both archive and tool:

- Markdown preserves authenticity.
- Flutter enforces consistency.
- The browser becomes a publishing platform, not a surveillance device.

---

## 🧾 License

MIT License © Desmond Liew
See [LICENSE](./LICENSE)
