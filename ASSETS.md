# ✅ Final `assets/` layout (clean + future-proof)

```
assets/
├─ images/                     # site-wide images (logos, avatars, covers, diagrams)
│  ├─ brand/
│  │  ├─ logo.svg
│  │  └─ favicon.png
│  ├─ headshots/
│  │  └─ desmond.jpg
│  ├─ covers/
│  │  ├─ default-post.webp
│  │  └─ default-project.webp
│  └─ diagrams/
│     ├─ system-architecture.png
│     └─ encryption-model.png
│
├─ files/                      # downloadable files
│  ├─ resume.pdf
│  ├─ proposal-template.pdf
│  └─ whitepaper-v1.pdf
│
└─ contents/                   # ALL markdown content (public + private together)
   ├─ pages/
   │  ├─ home.md
   │  ├─ about.md
   │  ├─ services.md
   │  ├─ contact.md
   │  └─ resume.md
   ├─ projects/
   │  ├─ judicial-v2t.md            # visibility: private (encrypted body)
   │  ├─ wood-identification.md     # visibility: public
   │  └─ ai-automation-suite.md
   ├─ blog/
   │  ├─ decision-log-001.md
   │  ├─ ethics-llm-evals.md
   │  └─ system-note-private.md     # visibility: private (encrypted body)
   ├─ labs/
   │  ├─ whisper-optimization.md
   │  └─ cv-detection-lab.md
   ├─ library/
   │  ├─ reading-list.md
   │  └─ tools-and-frameworks.md
   ├─ meta/
   │  ├─ personality.md
   │  ├─ philosophy-of-work.md
   │  └─ justice-manifesto.md
   └─ foundation/
      ├─ features.md
      ├─ privacy.md
      ├─ terms.md
      ├─ cookies.md
      └─ accessibility.md
```

- Keep **all** `.md`’s together here.
- Private content uses `visibility: private` and **client-side encrypted body** (the `:::cipher` block).
- Images/files referenced in Markdown should use stable absolute paths like `/assets/images/...` and `/assets/files/...`.

---

# 📦 `pubspec.yaml` (assets section)

No manifest file needed—just ensure Flutter bundles your content and media:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/contents/
    - assets/contents/pages/
    - assets/contents/projects/
    - assets/contents/blog/
    - assets/contents/labs/
    - assets/contents/library/
    - assets/contents/meta/
    - assets/contents/foundation/
    - assets/images/
    - assets/images/brand/
    - assets/images/headshots/
    - assets/images/covers/
    - assets/images/diagrams/
    - assets/files/
```

> This makes the markdown/media available via `rootBundle` on **all** platforms (Web/Android/Windows/Linux).

---

# 🧠 How auto-discovery works (no custom manifest)

- Flutter emits `AssetManifest.json` at build time (Web & native).
- On app startup, read `AssetManifest.json` → filter keys matching `assets/contents/**.md`.
- For each `.md`:

  - Load only the **first few KB** to parse front-matter (fast).
  - Build in-memory index: `type`, `slug`, `visibility`, `title`, `date`, `tags`, etc.

- Your list pages (Projects/Blog/Labs/Library/Pages) filter this index by `type`; detail routes load the full file on demand.
- **No code edits** when you add new markdown—just push.

---

# 🔐 Encryption flow (unchanged)

- Author private content with `visibility: private`.
- Run your CLI (`dart run lib/tools/encrypt_markdown.dart`) locally:

  - Argon2id derive → AES-GCM encrypt → replace body with `:::cipher ... :::` fenced block.

- Commit ciphertext; the app will prompt for passphrase to decrypt **in memory**.

---

# 🧭 Markdown link conventions (works everywhere)

- Images: `![alt](/assets/images/diagrams/system-architecture.png)`
- Files: `[Download resume](/assets/files/resume.pdf)`

Since assets are bundled, these paths resolve on all targets. (If you ever use relative paths inside `.md`, implement a small resolver to normalize them against the MD file’s directory.)

---

# 🛠 CI (what to change)

Because we’re **not** generating a custom manifest anymore:

- **Remove** any step that created `assets/contents/manifest.json`.
- **Keep** (optional) your `sitemap.xml` / `rss.xml` generation—those can be produced by a CI script that simply scans the repo directories (`assets/contents/**`) and parses front-matter, then writes the XML files to `web/` (or directly into `build/web/`) before deploying to GitHub Pages.

**Deploy flow stays simple:**

1. `flutter pub get`
2. _(optional)_ run your sitemap/rss generator (reads files from repo)
3. `flutter build web --release --base-href "/<repo_name>/"`
4. Publish `/build/web` to `gh-pages`

> No need to copy the assets manually for web—they’re already bundled by Flutter and referenced in `AssetManifest.json`.

---

# 🧩 Minimal code pointers (so it “just works”)

- **Discovery:**

  ```dart
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifest = jsonDecode(manifestJson);
  final mdPaths = manifest.keys
      .where((k) => k.startsWith('assets/contents/') && k.endsWith('.md'))
      .toList()..sort();
  ```

- **Front-matter parse:** read first chunk of the file, split on initial `--- ... ---`, parse with `yaml`.
- **Public vs private:** check `visibility` in front-matter; if private, expect a `:::cipher` block in body and gate behind a passphrase dialog.
- **Routing:** one generic detail route per type (e.g., `/projects/:slug`), no page registration.

