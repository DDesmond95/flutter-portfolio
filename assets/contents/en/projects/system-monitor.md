---
title: "System Monitor — Lightweight Observability Dashboard"
slug: "system-monitor"
type: "project"
visibility: "public"
date: "2024-11-30"
summary: "A minimal observability stack for AI systems — metrics, traces, and error insights with zero cloud dependency."
tags: ["monitoring", "observability", "dashboard", "FastAPI", "Flutter"]
thumbnail: "/assets/images/diagrams/system-architecture.png"
---

# System Monitor

## 🧩 Overview

A portable observability dashboard designed to monitor AI pipelines deployed on local infrastructure.  
It captures logs, metrics, and trace data in real time — all without external telemetry providers.

---

## ⚠️ Problem

Most monitoring platforms are cloud-locked or cost-prohibitive.  
Teams with on-prem deployments lacked a private alternative that was:

- lightweight,
- scriptable,
- and integrated into their CI/CD.

---

## 🧠 Solution

Developed **System Monitor**, a local-first observability stack using FastAPI + SQLite + Flutter.  
It ingests structured logs, displays metrics (CPU, latency, success rate), and visualizes events in near real time.

---

## ⚙️ Architecture

```plaintext
Agents → Collector API (FastAPI) → SQLite Store → WebSocket Stream → Flutter UI
```

Features:

- CPU/memory charts per service.
- Custom metric hooks for LLM latency or response correctness.
- JSON schema for log ingestion.
- Exportable CSV reports.

---

## 📈 Results

| Metric           | Result   |
| ---------------- | -------- |
| Install size     | < 30 MB  |
| Runtime overhead | ~3 % CPU |
| Uptime tracked   | 99.97 %  |
| Integration time | < 1 hour |

---

## 💡 Lessons

- Developers prefer self-hosted dashboards even for small teams.
- SQLite is adequate for short-term metrics if rotated weekly.
- Visual stability > flashy UI.

---

## ⚖️ Ethics & Transparency

- Collects **no personal data**.
- Fully offline operation.
- Clear visual indication for system health without surveillance scope.

---

## 🔮 Next Steps

- Add anomaly detection plugin.
- Optional exporter for Grafana compatibility.
- Package binaries for Windows/Linux on GitHub Releases.

_Now powering several private AI deployments for internal monitoring._
