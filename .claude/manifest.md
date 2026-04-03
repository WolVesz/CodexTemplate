# Template Control Plane

This repository contains a Copier template whose generated project keeps its Claude-first rules under `template/.claude/`.

## Read Order

1. `README.md`
2. `copier.yml`
3. `template/CLAUDE.md.jinja`
4. `template/GEMINI.md.jinja`
5. `template/AGENTS.md.jinja`
6. `template/.codex/manifest.md.jinja`
7. `template/.claude/manifest.md.jinja`
8. `template/.claude/config/runtime.yaml.jinja`
9. `template/.claude/config/project-surfaces.yaml.jinja`
10. `template/.claude/config/quality-gates.yaml.jinja`
11. `template/.claude/config/review-scope.yaml.jinja`
12. `template/.claude/config/trigger-derivation.yaml.jinja`
13. `template/.claude/config/finding-contract.yaml.jinja`
14. `template/.claude/config/workflow.yaml.jinja`
15. `template/.claude/config/reviewers.yaml.jinja`
16. `template/.claude/policies/quality.md.jinja`
17. `template/.claude/policies/review-scope.md.jinja`
18. `template/.claude/policies/finding-quality.md.jinja`
19. `template/.claude/policies/release-readiness.md.jinja`

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
