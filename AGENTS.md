# Claude Compatibility Guide

This repository is a Claude-first Copier template source repo.

This file exists as a compatibility entrypoint for AGENTS-based tools.

## Canonical Read Order

1. `.claude/manifest.md`
2. `README.md`
3. `copier.yml`
4. `template/CLAUDE.md.jinja`
5. `template/GEMINI.md.jinja`
6. `template/AGENTS.md.jinja`
7. `template/.codex/manifest.md.jinja`
8. `template/.claude/manifest.md.jinja`
9. `template/.claude/config/runtime.yaml.jinja`
10. `template/.claude/config/project-surfaces.yaml.jinja`
11. `template/.claude/config/quality-gates.yaml.jinja`
12. `template/.claude/config/review-scope.yaml.jinja`
13. `template/.claude/config/trigger-derivation.yaml.jinja`
14. `template/.claude/config/finding-contract.yaml.jinja`
15. `template/.claude/config/workflow.yaml.jinja`
16. `template/.claude/config/reviewers.yaml.jinja`
17. `template/.claude/policies/quality.md.jinja`
18. `template/.claude/policies/review-scope.md.jinja`
19. `template/.claude/policies/finding-quality.md.jinja`
20. `template/.claude/policies/release-readiness.md.jinja`

## Compatibility Surfaces

- `CLAUDE.md`: canonical source-repo entry point
- `GEMINI.md`: Gemini CLI compatibility shim
- `AGENTS.md`: AGENTS-based compatibility shim
- `.codex/manifest.md`: Codex-style compatibility shim
- `template/CLAUDE.md.jinja`, `template/GEMINI.md.jinja`, `template/AGENTS.md.jinja`, `template/.codex/manifest.md.jinja`: generated provider-facing surfaces that must stay materially aligned

## Default Behavior

- Treat `CLAUDE.md` and `.claude/` as canonical for this template repo.
- Treat `GEMINI.md`, `AGENTS.md`, and `.codex/manifest.md` as compatibility shims.
- Treat `template/` as the generated project root.
- Follow this canonical read order verbatim when reviewing or editing provider-facing behavior.
- Prefer `template/.claude/` when reasoning about generated-project workflow and agent behavior.
- Review all generated provider-facing entrypoints together when changing provider-facing instructions.
- Do not recursively ingest the whole repository when a question can be answered from the control-plane files above.
- If `template/.claude/config/lightning.yaml.jinja` is enabled or the task is about optimization, then also read `template/.claude/policies/lightning-boundaries.md.jinja`, `template/.claude/config/lightning.yaml.jinja`, and `template/.claude/config/telemetry.yaml.jinja`.

## Required Workflow

1. Update or confirm scope before editing the template.
2. Make canonical control-plane changes in `.claude/` or `template/.claude/` first.
3. Keep `template/CLAUDE.md.jinja`, `template/GEMINI.md.jinja`, `template/AGENTS.md.jinja`, and `template/.codex/manifest.md.jinja` materially aligned.
4. Update docs, tests, and smoke coverage when provider or compatibility behavior changes.
5. Repeat until no in-scope concerns remain.

## Non-Negotiable Rules

- `.claude/` remains the canonical control plane.
- Provider-facing shims must not introduce conflicting authority or divergent workflow rules.
- Generated compatibility entrypoints must preserve heavy overlap across Claude, Gemini, and Codex/AGENTS surfaces.
- Keep `template/src/` intentionally minimal.
- Preserve adaptive review scope and the in-scope remediation loop.
- If validation is blocked by the environment, capture the failure and escalate instead of guessing.
