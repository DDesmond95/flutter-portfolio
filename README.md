# 🪶 Flutter Portfolio

### _Local-first • Markdown-driven • Privacy-first_

This repository hosts **Desmond Liew’s personal portfolio**, built as a fully self-contained **Flutter Web app** deployed to GitHub Pages.
It renders Markdown files, supports private encrypted content, works offline, and requires **no backend or database**.

This repo contains **the code only**.
All content lives in a separate **private repo**, pulled in as a git submodule.

---

## 📦 Repositories

| Purpose                                  | Repo                                            |
| ---------------------------------------- | ----------------------------------------------- |
| **Main Flutter app (this repo)**         | `https://github.com/YukiRed/flutter-portfolio`  |
| **Private Markdown content (submodule)** | `https://github.com/YukiRed/Portfolio-Contents` |

---

## ✨ Features

| Category                 | Highlights                                                                |
| ------------------------ | ------------------------------------------------------------------------- |
| **Content system**       | Markdown-based pages, posts, projects, labs, meta sections                |
| **Markdown+ extensions** | Front-matter, callouts, diagrams, code blocks, SVG, encrypted sections    |
| **Privacy-first**        | AES-256-GCM + Argon2id encrypted blocks (`:::cipher`)                     |
| **Local-first**          | No backend, no cookies, no tracking, no analytics                         |
| **Multilingual**         | English 🇬🇧 • Chinese 🇨🇳 • Malay 🇲🇾                                        |
| **Theme & UX**           | Responsive layout, Material 3, custom palettes, persistent theme settings |
| **CI/CD**                | Auto-deploy to GitHub Pages, multi-platform build releases                |
| **SEO Tools**            | Sitemap, RSS, manifest generator, OG metadata                             |
| **Timeline**             | Visual life/work timeline sourced from Markdown                           |

---

# 🗂️ Project Structure

```
lib/
├── app/               # initialization, router, theming, config
├── core/              # crypto, parsing, markdown engine, manifest
├── features/          # UI pages for blog, timeline, about, meta...
├── widgets/           # shared components
└── tools/             # CLI tools: encrypt, sitemap, rss, manifest
```

### Assets Submodule (private repo)

```
assets/                      <-- git submodule
└── contents/
    ├── blog/
    ├── pages/
    ├── meta/
    ├── projects/
    ├── timeline/
    └── ...
```

---

# ⚙️ Getting Started

## 1. Clone with submodule

```
git clone --recurse-submodules git@github.com:YukiRed/flutter-portfolio.git
cd flutter-portfolio
```

If you forgot `--recurse-submodules`:

```
git submodule update --init --recursive
```

---

## 2. Install Flutter (3.9+)

```
flutter doctor
```

---

## 3. Get dependencies

```
flutter pub get
```

---

## 4. (Optional) Local `.env`

**Not required for CI or deployment.**
Only used for local dev overrides.

Create `.env` (ignored by git):

```
SITE_NAME="Desmond Liew Portfolio"
THEME_PALETTE="wood"
THEME_MODE="system"
```

All secrets are stored **only in GitHub Secrets**, not in `.env`.

---

# 🔐 Private Content (Git Submodule)

Your private content repo is configured in `.gitmodules`:

```
[submodule "assets"]
    path = assets
    url  = https://github.com/YukiRed/Portfolio-Contents.git
```

## Pull latest content

```
cd assets
git pull origin main
cd ..
git add assets
git commit -m "Update content"
git push
```

## Push content changes

```
cd assets
git add .
git commit -m "Update markdown"
git push origin main
```

Then commit the pointer:

```
cd ..
git add assets
git commit -m "Update submodule pointer"
git push
```

---

---

## 🚀 Running Locally

### Web (recommended for portfolio)

```bash
flutter run -d edge
# or
flutter run -d chrome
```

### Desktop (optional)

```bash
flutter run -d windows
flutter run -d linux
flutter run -d macos
```

---

# 🔐 Encryption Overview

Private sections use the block:

```md
:::cipher
algo: aes-256-gcm
kdf: argon2id
salt: <base64>
nonce: <base64>
body: |
<base64 ciphertext>
:::
```

Encrypt plaintext:

```
dart run lib/tools/encrypt_markdown.dart
```

Canary generator:

```
dart run lib/tools/gen_canary.dart "your-passphrase"
```

---

# 🌍 Localization

- English (`en`)
- Simplified Chinese (`zh`)
- Malay (`ms`)

Localization uses Flutter’s built-in `gen-l10n`.

Markdown files may include `lang:` in front-matter.

---

# 🎨 Theming

- Material 3
- Custom palettes
- Wood/Graphite/Forest/etc.
- Light/Dark/System modes
- Persisted via `SharedPreferences`

---

# 🕰 Timeline System

- Markdown-driven
- Sorted chronologically
- Supports dates, tags, links, and categories
- Pulls from `/assets/contents/timeline/`

---

# 🚀 Deployment (GitHub Pages)

Your deploy workflow:

- Fetches private submodule (via PAT)
- Builds Flutter Web with correct `--base-href`
- Uploads to GitHub Pages

### Build manually

```
flutter build web --release --base-href "/flutter-portfolio/"
```

---

# 📦 Multi-Platform Releases

Triggered by tags:

```
git tag v1.0.0
git push origin v1.0.0
```

Builds:

- Android APK
- Windows release
- Linux release

Artifacts uploaded to GitHub Releases automatically.

---

# 🧰 Tools

| Tool                    | Purpose                     |
| ----------------------- | --------------------------- |
| `encrypt_markdown.dart` | Encrypts private blocks     |
| `gen_canary.dart`       | Generates passphrase canary |
| `gen_sitemap.dart`      | Sitemap                     |
| `gen_rss.dart`          | RSS feed                    |
| `build_manifest.dart`   | Compiles content manifest   |

---

# ✍️ Authoring Markdown Content

Example page:

```md
---
title: "About"
slug: "/about"
lang: "en"
visibility: "public"
summary: "A reflection on work and design."
---

Normal Markdown goes here.
```

Private:

```md
visibility: "private"
```

Then encrypt body.

---

# 📘 Development Notes (for future contributors)

- All real content lives inside the **private submodule**.
- CI uses `${{ secrets.CONTENT_REPO_TOKEN }}` to fetch it.
- `.env` is optional and **not used** in CI builds.
- Submodule pointer must be committed after content updates.

---

# 🧩 License

- **Code:** MIT
- **Content:** All Rights Reserved (private repo)

---

# 🧠 Closing Note

> _“Build once. Publish forever.”_
> Every file remains yours — private or public — and the entire system is built to preserve that.
