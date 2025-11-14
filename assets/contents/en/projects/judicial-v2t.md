---
title: "Judicial V2T — Secure Speech-to-Text for Court Systems"
slug: "judicial-v2t"
type: "project"
visibility: "private"
date: "2024-06-12"
summary: "An offline voice-to-text system designed for judicial transcription — accuracy, privacy, and resilience."
tags: ["speech recognition", "AI systems", "FastAPI", "LLMOps", "security"]
thumbnail: "/assets/images/covers/default-project.webp"
---

# Judicial V2T — Secure Speech-to-Text System

## 🧩 Overview

Judicial V2T is an **on-premise speech transcription system** designed for use in courtrooms and legal institutions.  
It transforms complex multi-speaker recordings into structured, timestamped transcripts without sending any data to external APIs.

---

## ⚠️ Problem

Courts in many regions rely on manual transcription or cloud-based APIs that compromise confidentiality.  
Key challenges:

- Sensitive data could not leave premises.
- Human transcription was time-consuming and error-prone.
- Network instability made cloud ASR unreliable.
- Multilingual proceedings (English + Malay + Mandarin) demanded adaptive models.

---

## 🧠 Solution

A self-contained Whisper-based transcription engine, deployed locally via **FastAPI** and **Docker**, integrating multilingual ASR, diarization, and formatting layers.

Features:

- **Offline inference** using fine-tuned Whisper models.
- **Noise reduction pipeline** with PyTorch + RNNoise.
- **Speaker segmentation** (pyannote.audio).
- **Legal formatting layer** for timestamped transcripts.
- **Role-based dashboard** for playback, correction, and audit logging.

---

## ⚙️ Architecture

```plaintext
Audio Input → Preprocessing → Whisper ASR → Diarization → Postprocess (Formatting + Timestamp)
                                     ↓
                              API Gateway (FastAPI)
                                     ↓
                               Local Dashboard (Flutter)
```

Security:

- All data stored on encrypted SSDs (AES-256).
- Network air-gapped.
- Logs anonymised and rotated automatically.

---

## 📈 Results

| Metric                     | Before                | After          |
| -------------------------- | --------------------- | -------------- |
| Average transcription time | 4–6 hours per session | < 20 minutes   |
| Human correction load      | 100%                  | ~15%           |
| Data leakage risk          | High (cloud API)      | None (on-prem) |

---

## 🔬 Lessons

- CPU inference with quantized Whisper is viable for small installations.
- Pre-computing MFCCs saves 25 % runtime.
- Human-in-loop feedback improved model precision for legal vocabulary.

---

## ⚖️ Ethics & Fairness

- No external connectivity: privacy guaranteed.
- Explicit audit logs for each access.
- All training data obtained from publicly available recordings.

---

## 🔮 Next Steps

- Integrate speaker ID with biometric registry.
- Add summarization layer for case metadata.
- Publish internal whitepaper (restricted circulation).

_Status: Internal production deployment · Visibility: Private_
