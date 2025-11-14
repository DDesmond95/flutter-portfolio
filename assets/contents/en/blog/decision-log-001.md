---
title: "Decision Log #001 — Why I Built My Portfolio as a Local-First System"
slug: "decision-log-001"
type: "blog"
visibility: "public"
date: "2025-03-15"
summary: "A reasoning walkthrough on building a markdown-based portfolio system without external databases or paid hosting."
tags: ["decision log", "architecture", "portfolio", "local-first"]
thumbnail: "/assets/images/covers/default-blog.webp"
reading_time: "8 min"
---

# Decision Log #001 — Why I Built My Portfolio as a Local-First System

The portfolio you’re reading was designed around one question:

> _Can a website be a complete ecosystem without any external dependencies or hidden costs?_

---

## 🧩 Problem

I wanted to create a long-term personal platform that would:

1. Run anywhere — web, desktop, or mobile.
2. Require no backend servers.
3. Respect privacy.
4. Be maintainable even ten years from now.

Most portfolio templates rely on APIs, databases, or frameworks that will disappear over time.  
I wanted a system that could live entirely within version control — **Git as database, Markdown as truth**.

---

## 🧠 Design Criteria

| Principle        | Description                                 |
| ---------------- | ------------------------------------------- |
| **Durability**   | Works offline, no vendor lock-in.           |
| **Transparency** | Content visible and auditable in Markdown.  |
| **Flexibility**  | One source can generate multiple platforms. |
| **Ethics**       | No analytics that compromise user privacy.  |

---

## ⚙️ Solution

1. **Flutter-based UI:** for multi-platform builds (Android, Web, Linux, Windows).
2. **Markdown-driven content engine:** each file in `/assets/contents/` becomes a route automatically.
3. **GitHub Pages deployment:** free static hosting.
4. **Private content flag:** files can include `visibility: "private"` — hidden unless logged in.

This system allows me to focus on _content, not code churn._

---

## 📈 Outcome

- Zero hosting fees.
- Transparent updates via commit history.
- Encrypted private files supported by local decryption.
- Every section — projects, blogs, notes — defined as a simple `.md`.

---

## 💡 Lessons

- Local-first systems force better structure and discipline.
- Markdown remains the most resilient “database” for personal archives.
- Simplicity ages better than convenience.

---

## 🔮 Next Steps

- Add incremental build scripts for Flutter web.
- Release minimal open template for other engineers.

> “If you build a system that survives neglect, you’ve built something worth keeping.”
