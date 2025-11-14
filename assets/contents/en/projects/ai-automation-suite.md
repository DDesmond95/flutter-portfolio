---
title: "AI Automation Suite — Modular Workflow Engine"
slug: "ai-automation-suite"
type: "project"
visibility: "public"
date: "2025-04-21"
summary: "Composable automation modules integrating AI decision logic for business operations."
tags: ["automation", "LLM", "workflow", "FastAPI", "Flutter"]
thumbnail: "/assets/images/covers/default-project.webp"
---

# AI Automation Suite

## 🧩 Overview

An internal-use workflow platform that combines rule-based logic with AI models to automate repetitive back-office tasks.  
Designed for clarity, modularity, and human oversight.

---

## ⚠️ Problem

Teams faced fragmentation between manual workflows and AI tools — too many disconnected bots, inconsistent logs, and opaque decisions.

**Objective:**  
Unify workflows into a transparent automation hub where every task is observable and reversible.

---

## 🧠 Solution

A **modular engine** written in FastAPI that executes task chains defined in YAML.  
Each module wraps a small function — scraping, classification, summarization, data cleanup — using LLMs where appropriate.  
A Flutter dashboard visualizes progress and logs.

---

## ⚙️ Architecture

```plaintext
YAML Workflow → Task Parser → Executor
     ↓                ↓
 FastAPI Core       Queue Runner
     ↓                ↓
 SQLite Log ←→ Flutter Dashboard
```

### Modules

- `fetch_web`: HTTP/HTML fetcher
- `summarize_text`: local LLM summarizer
- `extract_entities`: regex/NER hybrid
- `send_report`: email or Markdown export

---

## 📊 Results

| KPI                     | Before | After          |
| ----------------------- | ------ | -------------- |
| Avg manual report time  | 90 min | 10 min         |
| Human intervention rate | 100 %  | 15 %           |
| Rollback recovery       | none   | full audit log |

---

## 💡 Lessons

- YAML templates empower non-dev users to define flows.
- Over-automation is dangerous — always allow manual override.
- Logging is as important as execution.

---

## ⚖️ Ethics

Automation isn’t about replacing people — it’s about removing friction.
Every module includes explainable logs and rollback.

---

## 🔮 Next Steps

- Add visual workflow editor.
- Integrate open-source eval dashboards.
- Package base engine for release on GitHub.

_Currently used internally by partner companies for operations automation._
