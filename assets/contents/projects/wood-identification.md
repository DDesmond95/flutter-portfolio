---
title: "Wood Identification AI — Species Detection via Computer Vision"
slug: "wood-identification"
type: "project"
visibility: "public"
date: "2023-09-08"
summary: "A lightweight computer vision system that identifies timber species to combat illegal logging."
tags: ["computer vision", "sustainability", "AI", "edge computing"]
thumbnail: "/assets/images/covers/wood.webp"
---

# Wood Identification AI

## 🌍 Overview

A mobile-deployable computer vision model that detects timber species from microscopic images of wood.  
Developed to aid forestry departments and customs officers in identifying endangered wood species quickly and reliably.

---

## ⚠️ Problem

Illegal logging and timber trade rely on mislabelling species.  
Manual identification by experts takes days and is limited by microscope availability.

**Goals:**

- Classify > 40 tropical wood species with high precision.
- Run entirely offline (forest conditions).
- Output readable results for non-technical users.

---

## 🧠 Solution

Trained a CNN architecture (EfficientNet-B0) on curated microscopic image dataset (30 k + samples).  
Quantized and exported to **TensorFlow Lite** for use on mobile and edge devices.

---

## ⚙️ Architecture

```plaintext
Image Capture (Microscope + Mobile)
      ↓
Preprocessing (Color norm, Patch extraction)
      ↓
EfficientNet-B0 Model (TF Lite)
      ↓
Prediction + Confidence
      ↓
UI (Flutter app)
```

Flutter front-end enables camera capture, preview, and offline inference.
Metadata stored locally with optional JSON export.

---

## 📊 Results

| Metric            | Value                    |
| ----------------- | ------------------------ |
| Model size        | 18 MB (quantized)        |
| Accuracy          | 94.6 % top-1             |
| Inference latency | ~120 ms (Snapdragon 855) |

---

## 💡 Lessons

- Lighting normalization critical for consistent accuracy.
- TF Lite GPU delegate improves inference speed by ~2×.
- Field testing identified 5 mislabeled dataset samples — now corrected.

---

## ⚖️ Ethics

- Model trained on open forestry datasets with permission.
- No geolocation or biometric data collected.
- Focused on conservation, not enforcement surveillance.

---

## 🔮 Next Steps

- Expand dataset to > 100 species.
- Open-source non-sensitive components.
- Publish methodology for scientific reuse.

_Deployed prototype in 2024 forestry pilot._
