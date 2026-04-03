# Template Control Plane

This repository contains a Copier template whose generated project keeps its Claude-first rules under `template/.claude/`.

## Read Order

1. `CLAUDE.md`
2. `README.md`
3. `copier.yml`
4. `template/CLAUDE.md.jinja`
5. `template/GEMINI.md.jinja`
6. `template/AGENTS.md.jinja`
7. `template/.codex/manifest.md.jinja`
8. `template/.claude/manifest.md.jinja`
9. `template/.claude/config/runtime.yaml.jinja`
10. `template/.claude/policies/quality.md.jinja`
11. `template/.claude/policies/review-scope.md.jinja`
12. `template/.claude/policies/finding-quality.md.jinja`
13. `template/.claude/policies/release-readiness.md.jinja`

Compatibility entrypoints:
- `GEMINI.md`
- `AGENTS.md`
- `.codex/manifest.md`

## Purpose

- Keep the template repository itself easy for Claude to navigate.
- Keep Gemini/AGENTS/Codex compatibility without duplicating the full control plane.
- Keep the generated provider-facing entrypoints materially aligned across Claude, Gemini, and Codex/AGENTS surfaces.
- Route generated-project behavior into `template/.claude/` rather than normal app code.
- Keep `template/src/` intentionally minimal.
