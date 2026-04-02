# Codex Compatibility Manifest

This repository is Claude-first.

Use these files as the compatibility handoff for Codex-style tooling:

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

Notes:
- `.claude/` is the canonical control plane for both the template repo and generated projects.
- `AGENTS.md` and this file exist only to preserve compatibility with AGENTS/Codex-oriented entrypoint conventions.
- If the generated template's Lightning optimization layer is relevant, also read `template/.claude/policies/lightning-boundaries.md.jinja`, `template/.claude/config/lightning.yaml.jinja`, and `template/.claude/config/telemetry.yaml.jinja`.
