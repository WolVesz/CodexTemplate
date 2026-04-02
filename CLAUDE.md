# Template Agent Guide

This repository is a Claude-first Copier template source repo.

This file is the canonical repository entry point.

Read these files next before exploring the rest of the repository:
1. `.claude/manifest.md`
2. `README.md`
3. `copier.yml`
4. `template/CLAUDE.md.jinja`
5. `template/.claude/manifest.md.jinja`

Compatibility entrypoints:
- `AGENTS.md` forwards AGENTS-based tools into this Claude-first layout.
- `.codex/manifest.md` forwards Codex-style control-plane discovery into `.claude/`.

Default behavior:
- Treat `template/` as the generated project root.
- Prefer `template/.claude/` when reasoning about generated-project workflow and agent behavior.
- Do not recursively ingest the whole repository when a question can be answered from the control-plane files above.

When editing this template:
- Keep `src/` in the generated project minimal.
- Keep Claude-facing workflow material isolated in `.claude/`.
- Preserve adaptive review scope and the in-scope remediation loop.
