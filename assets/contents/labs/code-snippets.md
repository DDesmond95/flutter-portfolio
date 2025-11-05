---
title: "Code Snippets — Utilities and Patterns"
slug: "labs-code-snippets"
type: "lab"
visibility: "public"
date: "2025-03-19"
summary: "Reusable code fragments for AI evaluation, logging, and automation."
tags: ["code", "utilities", "snippets", "FastAPI", "Flutter"]
thumbnail: "/assets/images/covers/snippets.webp"
---

# Code Snippets — Patterns Worth Keeping

This section curates recurring patterns I’ve found reliable across projects.

---

## 🧾 Log Formatter (Python)

```python
import json, time
def log_event(name: str, data: dict):
    print(json.dumps({
        "event": name,
        "timestamp": time.time(),
        "data": data
    }))
```

**Purpose:** Minimal, human-readable logging that doubles as eval trace.

---

## 🧮 Evaluation Metric Hook

```python
def eval_latency(start, end):
    return {"latency_ms": round((end - start)*1000, 2)}
```

Integrate with FastAPI middlewares to benchmark LLM endpoints.

---

## 🪶 Flutter Markdown Loader

```dart
Future<String> loadMarkdown(String path) async {
  return await rootBundle.loadString(path);
}
```

Reads Markdown from `/assets/contents/` and injects into FlutterMarkdownPlus.

---

> Simple utilities reduce mental overhead and make systems calm by design.
