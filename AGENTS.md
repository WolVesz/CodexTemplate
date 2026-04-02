# Claude Compatibility Guide

This repository is a Claude-first Copier template source repo.

This file exists as a compatibility entrypoint for AGENTS-based tools.

Read these files next before exploring the rest of the repository:
1. `CLAUDE.md`
2. `.claude/manifest.md`
3. `README.md`
4. `copier.yml`
5. `template/CLAUDE.md.jinja`
6. `template/.claude/manifest.md.jinja`
7. `template/.claude/config/runtime.yaml.jinja`
8. `template/.claude/policies/quality.md.jinja`
9. `template/.claude/policies/review-scope.md.jinja`
10. `template/.claude/policies/finding-quality.md.jinja`
11. `template/.claude/policies/release-readiness.md.jinja`

Default behavior:
- Treat `CLAUDE.md` and `.claude/` as canonical for this template repo.
- Treat `AGENTS.md` and `.codex/manifest.md` as compatibility shims.
- Treat `template/` as the generated project root.
- Prefer `template/.claude/` when reasoning about generated-project workflow and agent behavior.
- Do not recursively ingest the whole repository when a question can be answered from the control-plane files above.
- If `template/.claude/config/lightning.yaml.jinja` is enabled or the task is about optimization, then also read `template/.claude/policies/lightning-boundaries.md.jinja`, `template/.claude/config/lightning.yaml.jinja`, and `template/.claude/config/telemetry.yaml.jinja`.

When editing this template:
- Keep `src/` in the generated project minimal.
- Keep Claude-facing workflow material isolated in `.claude/`.
- Preserve adaptive review scope and the in-scope remediation loop.
