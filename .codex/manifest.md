# Template Control Plane

This repository contains a Copier template whose generated project keeps its Codex-facing rules under `template/.codex/`.

## Read Order

1. `AGENTS.md`
2. `README.md`
3. `copier.yml`
4. `template/AGENTS.md.jinja`
5. `template/.codex/manifest.md.jinja`

## Purpose

- Keep the template repository itself easy for Codex to navigate.
- Route generated-project behavior into `template/.codex/` rather than normal app code.
- Keep `template/src/` intentionally minimal.
