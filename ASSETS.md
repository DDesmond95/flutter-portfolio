# Assets — Desmond Liew Portfolio

This document defines the structure, conventions, and purpose of all files under `/assets/`.  
These assets serve as the **data layer** for the entire portfolio — powering all pages, projects, and content in a *local-first* architecture.

---

## 📁 Directory Overview

```

assets/
├─ contents/
│   ├─ blog/          → Articles, essays, and posts
│   ├─ foundation/    → Philosophy, ethics, and personal systems
│   ├─ labs/          → Experiments, prototypes, research tools
│   ├─ library/       → Influences, readings, and frameworks
│   ├─ meta/          → Policies, accessibility, credits, legal
│   ├─ pages/         → Static pages (`home.md`, `about.md`, etc.)
│   ├─ projects/      → Portfolio projects, case studies
│   └─ index.json     → (optional future manifest)
│
├─ files/             → Downloadable PDFs, resumes, data files
│
└─ images/
├─ brand/         → Logos, brand marks, favicons
├─ covers/        → Project and post header images
├─ diagrams/      → Visual systems and architecture maps
└─ headshots/     → Portraits and personal photos

````

---

## 🧩 Content Model

Each Markdown (`.md`) file uses **YAML front-matter** followed by body content in Markdown.  
Example template:

```yaml
---
title: "System Monitor"
slug: "system-monitor"
type: "project"
visibility: "private"
date: 2024-08-10
description: "Privacy-first monitoring system prototype."
tags: [systems, flutter, privacy]
cover: "assets/images/covers/system-monitor.jpg"
lang: "en"
---
## Overview

System Monitor is an experiment in self-hosted system visibility, designed to align with Desmond’s principles of ethical transparency.
````

### Front-matter keys

| Key           | Type   | Required | Description                                                       |
| ------------- | ------ | -------- | ----------------------------------------------------------------- |
| `title`       | String | ✅        | Human-readable title                                              |
| `slug`        | String | ✅        | Unique identifier used in routing                                 |
| `type`        | String | ✅        | One of: `page`, `blog`, `project`, `lab`, `foundation`, `library` |
| `visibility`  | String | ✅        | `public` or `private`                                             |
| `date`        | String | ✅        | ISO date (`YYYY-MM-DD`) for sorting                               |
| `description` | String | ✅        | Short summary for previews and cards                              |
| `tags`        | List   | optional | Keywords for filtering                                            |
| `cover`       | String | optional | Relative path to image                                            |
| `lang`        | String | optional | Content language (`en`, `zh`, `ms`)                               |

---

## 📝 Content Folders

### `/assets/contents/pages/`

Static pages rendered via routes:

* `home.md` → `/`
* `about.md` → `/about`
* `contact.md` → `/contact`
* `services.md` → `/services`
* `resume.md` → `/resume`

These pages define the main structure of your site.
All use front-matter `type: "page"`.

---

### `/assets/contents/projects/`

Case studies, technical write-ups, and long-form portfolio entries.

Example:

```
projects/
 ├─ ai-automation-suite.md
 ├─ wood-identification.md
 └─ system-monitor.md
```

Used under `/projects/:slug`.
Each item becomes a project card with title, description, and cover.

---

### `/assets/contents/blog/`

Essays, reflections, and personal thoughts.
Use `type: "blog"` and `visibility: public` unless encrypted.

Supports multilingual posts via `lang` key and language detection.

---

### `/assets/contents/labs/`

Experimental ideas, prototypes, and “sandbox” works.

Examples:

* `creative-experiments.md`
* `automation-tools.md`
* `prototypes.md`
* `code-snippets.md`

These render in `/labs`, each tagged by domain (design, research, systems).

---

### `/assets/contents/library/`

Influences, reference texts, and frameworks used across Desmond’s work.

Example entries:

* `influences.md`
* `reading-list.md`
* `tools-and-frameworks.md`
* `research-notes.md`

---

### `/assets/contents/foundation/`

Conceptual and ethical underpinnings — the “why” behind the portfolio.

Files include:

* `philosophy-of-work.md`
* `justice-manifesto.md`
* `ethics-llm-evals.md`
* `system-design-notes.md`
* `decision-log-001.md`
* `calm-technology.md`
* `eval-principles.md`

These form `/foundation` — readable sections of Desmond’s worldview and practice.

---

### `/assets/contents/meta/`

Site meta content — rendered as standalone pages or linked from footer.

Includes:

* `privacy-policy.md`
* `terms-of-service.md`
* `cookie-policy.md`
* `accessibility.md`
* `credits.md`
* `features.md`

Each file defines `type: meta` and is linked in the footer navigation.

---

## 🖼️ Image Assets

| Folder               | Purpose                     | Recommended Format | Notes                             |
| -------------------- | --------------------------- | ------------------ | --------------------------------- |
| `/images/brand/`     | Logos, favicon, icons       | `.svg`, `.png`     | Used by app bar, footer, metadata |
| `/images/covers/`    | Page and project covers     | `.jpg`, `.webp`    | Landscape, ~1600x900, < 500KB     |
| `/images/diagrams/`  | Schematics, system diagrams | `.svg`             | Vector preferred                  |
| `/images/headshots/` | Portraits                   | `.jpg`, `.png`     | For `about` and resume pages      |

---

## 📄 File Assets

| File Type        | Use                          |
| ---------------- | ---------------------------- |
| `.pdf`           | Resume, reports, whitepapers |
| `.zip`           | Source archives (optional)   |
| `.json` / `.csv` | Data exports or lab inputs   |

---

## 🔐 Private Content

Private `.md` files include `visibility: private`.
Their content is **AES-GCM encrypted** and decrypted client-side when the correct passphrase is provided via login.

When locked, the Markdown body shows an encrypted envelope header instead of readable content.

Example (encrypted file):

```
visibility: private
encrypted: true
cipher: <base64 text>
```

---

## 🧠 Conventions

* Filenames use **kebab-case** (`philosophy-of-work.md`)
* Front-matter always separated by `---` lines
* Image paths use **relative URIs** (`assets/images/...`)
* All timestamps use ISO 8601
* Non-English content has `lang: zh` or `lang: ms`

---

## 🧩 Best Practices

1. **Keep content version-controlled** — edit Markdown, commit, deploy.
2. **Avoid inline HTML** unless absolutely needed.
3. **Use semantic headings** (`##`, `###`) for accessibility.
4. **Compress images** for fast GitHub Pages delivery.
5. **Use front-matter consistently** to allow automated indexing.
6. **Encrypt** only when privacy truly matters — public content improves SEO.

---

## 🚀 Future Plans

* Generate an `index.json` manifest for faster client-side indexing.
* Implement local fuzzy search across Markdown files.
* Add thumbnail generation for covers.
* Store pre-rendered excerpts for list pages.
* Include auto-generated RSS/Atom feeds from `/blog`.

---

## 🧾 License

All assets © Desmond Liew
Software licensed under MIT unless otherwise specified.

---
