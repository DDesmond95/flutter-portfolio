---
title: "Features & System Overview"
slug: "foundation-features"
type: "foundation"
visibility: "public"
date: "2025-07-12"
summary: "Comprehensive breakdown of features and architecture powering the portfolio website."
tags: ["features", "architecture", "system"]
thumbnail: "/assets/images/covers/features.webp"
---

# Features & System Overview

This portfolio is not a static resume — it’s a **local-first, modular system**.  
Built entirely in **Flutter**, it unifies content, design, and logic in one coherent framework.

---

## 🧩 Core Design Principles

1. **Local-First Architecture** – all Markdown content lives inside `/assets/contents/`.
2. **Automatic Indexing** – Flutter reads file metadata dynamically; no manual code edits needed when new content is added.
3. **Multi-Platform Deployment** – single codebase exports to web, Android, Linux, macOS, and Windows.
4. **Offline Operation** – no external APIs required for viewing or browsing.
5. **Privacy by Design** – no analytics or external cookies.
6. **Accessible Typography** – balanced contrast, dyslexia-friendly font spacing.
7. **Configurable Theme Engine** – adaptive color system derived from local JSON config.
8. **Login-Protected Section** – unlocks private Markdown via encryption and local cache.

---

## 📁 Folder Structure Summary

| Path                | Purpose                                                       |
| ------------------- | ------------------------------------------------------------- |
| `/lib/`             | Dart source code for UI, content loader, and routing.         |
| `/assets/contents/` | Markdown content — pages, blogs, projects, etc.               |
| `/assets/images/`   | Illustrations, covers, icons, headshots.                      |
| `/assets/files/`    | Documents, CVs, downloadable materials.                       |
| `/web/`             | Web deployment assets (`index.html`, `manifest.json`, icons). |

---

## 🧠 Technical Stack

| Layer          | Technology                           |
| -------------- | ------------------------------------ |
| **Frontend**   | Flutter 3.24 + flutter_markdown_plus |
| **Routing**    | go_router                            |
| **State**      | Riverpod                             |
| **Theme**      | Dynamic color generator              |
| **Build/CI**   | GitHub Actions                       |
| **Encryption** | AES-256 via flutter_secure_storage   |
| **Storage**    | Local JSON index + markdown parser   |

---

## 🧰 Feature Highlights

- Dynamic content routing
- Markdown metadata parsing
- Offline search (tokenized)
- Dark/light mode
- Auto-generated sitemap
- Local caching
- Private file decryption for hidden content
- Minimal animations for calm UX

---

## 🪶 Reflection

A portfolio is a living document.  
By building it as code, I turned self-expression into system design.

> “When your portfolio updates itself, you can spend your time learning, not maintaining.”
