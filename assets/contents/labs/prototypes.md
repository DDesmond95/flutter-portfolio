---
title: "AI Prototypes — Experimental Ideas in Practice"
slug: "labs-prototypes"
type: "lab"
visibility: "public"
date: "2025-05-01"
summary: "Small, self-contained prototypes that explore model behaviour, evaluation, and interaction design."
tags: ["labs", "AI", "prototype", "research", "experiments"]
thumbnail: "/assets/images/covers/labs-prototypes.webp"
---

# AI Prototypes

Every idea begins as an experiment.  
These prototypes test model behaviour, UX patterns, and system integration without production pressure.

---

## 🧠 1. Context Compression Experiment

- **Goal:** Evaluate information retention in LLMs under token constraints.
- **Setup:** GPT-4-mini equivalent, 12 k token context window.
- **Finding:** Reducing redundancy using structured prompts maintained 92 % factual recall.
- **Takeaway:** Compression through _semantic scaffolding_ > raw token trimming.

---

## 🔍 2. Chain Audit Tool

- **Description:** Minimal FastAPI service that logs intermediate reasoning steps for LLM chains.
- **Stack:** FastAPI · SQLite · JSON schemas.
- **Result:** Improved transparency in prompt debugging.
- **Status:** Refactoring for open release.

---

## 🎛️ 3. Human Feedback Visualizer

- **Purpose:** Create a small dashboard to compare user corrections vs. model predictions.
- **Frontend:** Flutter web chart using charts_flutter_plus.
- **Outcome:** Demonstrated 30 % variance between human and automatic grading — key insight for eval bias.

---

## 📡 4. Offline Vector Search Prototype

- **Goal:** Build a local semantic search using sentence-transformers in Dart FFI.
- **Architecture:** Embeddings generated offline → stored in SQlite → searched via cosine similarity.
- **Impact:** Proved feasible to run semantic retrieval entirely client-side.

---

_All prototypes licensed for learning reuse; no user data stored._
