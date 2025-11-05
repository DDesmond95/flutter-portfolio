# Features

**A modular, Markdown-driven, privacy-first Flutter web application.**

This document describes the **functional**, **technical**, and **philosophical** features implemented in the project — with clarity on current, planned, and optional modules.

---

## 🌐 Core System

| Category         | Feature                         | Status  | Description                                                       |
| ---------------- | ------------------------------- | ------- | ----------------------------------------------------------------- |
| **Architecture** | Local-first Markdown CMS        | ✅ Done | All content written in `.md` files with YAML front-matter.        |
| **Rendering**    | Markdown + Front-matter parsing | ✅ Done | `flutter_markdown_plus` + `yaml` for content parsing and styling. |
| **Routing**      | Dynamic route builder           | ✅ Done | `go_router` maps slugs to `/page/:slug`, `/project/:slug`, etc.   |
| **Config**       | Environment variables           | ✅ Done | `.env` loaded using `flutter_dotenv` for secrets and constants.   |
| **Assets**       | Manifest-based asset discovery  | ✅ Done | All assets declared in `pubspec.yaml` and loaded dynamically.     |
| **Privacy**      | Local client-only runtime       | ✅ Done | No external API calls, no telemetry. Everything runs in browser.  |

---

## 🎨 User Interface

| Category                | Feature                        | Status         | Description                                                       |
| ----------------------- | ------------------------------ | -------------- | ----------------------------------------------------------------- |
| **Material Design 3**   | Theming & ColorScheme.fromSeed | ✅ Done        | Generates harmonious color palettes automatically.                |
| **Typography**          | Noto Sans + Noto Sans SC       | ✅ Done        | Unified multilingual typography.                                  |
| **Adaptive Layout**     | Responsive Framework           | ✅ Done        | `responsive_framework` used for breakpoints and scaling.          |
| **Animations**          | Subtle transitions             | ✅ Done        | `animations` package provides transitions for pages and elements. |
| **App Shell**           | Unified navigation structure   | ✅ Done        | `ShellScaffold` includes AppBar + Drawer + responsive layout.     |
| **Theme Switcher**      | Palette + mode toggling        | ✅ Done        | Switch between light/dark mode and palettes (metal, wood, fire…). |
| **Font Scaling**        | Accessibility ready            | 🔄 In Progress | Use dynamic text scaling via `MediaQuery.textScaler`.             |
| **Dark Mode Detection** | System adaptive                | ✅ Done        | Auto-switches based on system settings.                           |

---

## 🔐 Authentication & Privacy

| Category                  | Feature                      | Status  | Description                                                    |
| ------------------------- | ---------------------------- | ------- | -------------------------------------------------------------- |
| **Auth Mode**             | Local-only AES-GCM unlock    | ✅ Done | Passphrase stored in `SharedPreferences` for decryption.       |
| **Encrypted Content**     | Private Markdown             | ✅ Done | Markdown with `visibility: private` decrypted client-side.     |
| **Passphrase Validation** | Canary verification          | ✅ Done | Optional `.env`-based encrypted canary to confirm credentials. |
| **Session Persistence**   | Stay logged in after refresh | ✅ Done | SharedPreferences syncs passphrase between sessions.           |
| **Logout**                | Manual + auto-clear          | ✅ Done | Clears stored passphrase and updates UI immediately.           |
| **GitHub Secrets**        | Build-time injection         | ✅ Done | `.env` replaced by GitHub environment variables in CI/CD.      |

---

## 🌍 Localization

| Category              | Feature                      | Status  | Description                                    |
| --------------------- | ---------------------------- | ------- | ---------------------------------------------- |
| **Languages**         | English, 中文, Bahasa Melayu | ✅ Done | Full `l10n` support via `flutter gen-l10n`.    |
| **Language Selector** | Runtime switching            | ✅ Done | AppBar language dropdown updates UI instantly. |
| **Persistence**       | Local preference             | ✅ Done | Saved using `SharedPreferences`.               |
| **Extensibility**     | Add new locales easily       | ✅ Done | New ARB files auto-compiled during build.      |

---

## 🗂 Content Model

| Type           | Directory                     | Description                                      |
| -------------- | ----------------------------- | ------------------------------------------------ |
| **Pages**      | `assets/contents/pages/`      | Static pages (`home`, `about`, `contact`, etc.). |
| **Projects**   | `assets/contents/projects/`   | Detailed case studies, portfolio entries.        |
| **Blog**       | `assets/contents/blog/`       | Articles, reflections, updates.                  |
| **Labs**       | `assets/contents/labs/`       | Experiments, prototypes, creative research.      |
| **Library**    | `assets/contents/library/`    | Reading lists, frameworks, reference materials.  |
| **Foundation** | `assets/contents/foundation/` | Philosophical + ethical background.              |
| **Meta**       | `assets/contents/meta/`       | Manifest, credits, privacy, terms.               |

Each `.md` file includes front-matter like:

```yaml
---
title: "System Monitor"
slug: "system-monitor"
type: "project"
visibility: "private"
date: 2024-08-01
description: "Experimental dashboard prototype for transparent computing."
---
```

---

## ⚙️ Developer Experience

| Category               | Feature                   | Status  | Description                                        |
| ---------------------- | ------------------------- | ------- | -------------------------------------------------- |
| **Hot Reload**         | Flutter standard          | ✅ Done | All UI updates in real time during dev.            |
| **Build Runner**       | Codegen support           | ✅ Done | Used for localization, serialization, and config.  |
| **CI/CD**              | GitHub Actions            | ✅ Done | `ci.yml` builds and deploys to Pages.              |
| **Release Automation** | Tagged releases           | ✅ Done | `release.yml` automates version bump and build.    |
| **Dependabot**         | Auto-updates dependencies | ✅ Done | Tracks versions in `pubspec.yaml`.                 |
| **PR Templates**       | Structured workflow       | ✅ Done | Includes `PULL_REQUEST_TEMPLATE.md`, `CODEOWNERS`. |

---

## 📱 Responsive Layouts

| Breakpoint | Max Width | Usage                                    |
| ---------- | --------- | ---------------------------------------- |
| `xs`       | ≤480px    | Mobile portrait (drawer-only navigation) |
| `sm`       | ≤768px    | Mobile landscape/tablet                  |
| `md`       | ≤1024px   | Small desktop                            |
| `lg`       | ≤1440px   | Full desktop (default breakpoint)        |
| `xl`       | >1440px   | Wide/4K layout, increased padding        |

Each page uses `ResponsivePadding` and adaptive constraints inside `MarkdownView` for readability.

---

## 🧩 Planned Features

| Feature                      | Description                               | Status     |
| ---------------------------- | ----------------------------------------- | ---------- |
| **Offline PWA Support**      | Full service worker caching               | 🧩 Planned |
| **Search Engine**            | Local fuzzy search across Markdown titles | 🧩 Planned |
| **Image Optimizer**          | Lazy-loading for large assets             | 🧩 Planned |
| **Markdown Editor**          | Web-based `.md` editor for quick changes  | 🧩 Planned |
| **RSS Feed Generator**       | Auto-build RSS/Atom feeds from `/blog`    | 🧩 Planned |
| **Dark/Light illustrations** | Auto-switch illustrations per mode        | 🧩 Planned |

---

## 🔗 Integrations

| Tool                | Purpose                               |
| ------------------- | ------------------------------------- |
| **GitHub Pages**    | Static hosting of `/build/web`        |
| **GitHub Releases** | Versioned snapshot of published site  |
| **Dependabot**      | Auto-update Flutter dependencies      |
| **VS Code**         | Recommended workspace setup           |
| **Google Fonts**    | Noto Sans (EN/MS) + Noto Sans SC (ZH) |

---

## 🧱 Philosophy of Features

- Each feature is **intentional**, not ornamental.
- Design and code must reinforce autonomy, privacy, and clarity.
- The site must remain **inspectable**, **editable**, and **reproducible** from source.

---

## 🧩 Summary

✅ **Implemented:**
Routing, theming, markdown, auth, localization, persistent preferences, responsive layout.
⚙️ **Planned:**
Offline PWA, search, editor, feeds, and media optimization.

> _“Simplicity is not absence — it is precision.”_
