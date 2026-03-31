# Template Agent Guide

This repository is a Copier template source repo.

This file is the repository entry point.

Read these files next before exploring the rest of the repository:
1. `.codex/manifest.md`
2. `README.md`
3. `copier.yml`
4. `template/AGENTS.md.jinja`
5. `template/.codex/manifest.md.jinja`

Default behavior:
- Treat `template/` as the generated project root.
- Prefer `template/.codex/` when reasoning about generated-project workflow and agent behavior.
- Do not recursively ingest the whole repository when a question can be answered from the control-plane files above.

When editing this template:
- Keep `src/` in the generated project minimal.
- Keep Codex-facing workflow material isolated in `.codex/`.
- Preserve adaptive review scope and the in-scope remediation loop.
