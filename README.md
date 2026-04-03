## ClaudeTemplate

This repository is a `copier` template for Python projects that want a Claude-first control plane with strict scope tracking, reviewer-driven QA loops, strong local quality gates, selectable Anthropic Claude or Google Gemini runtime defaults, and compatibility shims for AGENTS, Codex, and Gemini CLI.

The generated control plane is written to map cleanly onto a future LangGraph implementation without forcing you to ship orchestration code in `src/` on day one.

What it generates:
- a minimal `src/` package scaffold with only `__init__.py`
- a dedicated `.claude/` control plane for agent rules, workflow policy, reviewer specs, and scope-memory conventions
- compatibility entrypoints through `GEMINI.md`, `AGENTS.md`, and `.codex/manifest.md`
- provider-aware runtime defaults for Anthropic Claude or Google Gemini
- Codex/OpenAI compatibility through entrypoint alignment and `CODEX_*` model-alias fallbacks, not as a third generated runtime provider
- optional Agent Lightning scaffolding for optimizing development workflow without changing scope or governance authority
- `uv`-managed Python project metadata
- `ruff`, `mypy`, `pytest`, branch coverage enforcement, `pre-commit`, and GitHub Actions
- a reviewer registry that is easy to extend without rewiring the rest of the project

Why the layout looks this way:
- this template repo ships `CLAUDE.md` and `.claude/manifest.md` as the canonical entrypoints for Claude
- it also ships `GEMINI.md`, `AGENTS.md`, and `.codex/manifest.md` as compatibility shims for Gemini CLI, AGENTS, and Codex-style tools
- generated projects keep `.claude/` as the control plane Claude should read first
- generated projects still include Gemini/AGENTS/Codex-compatible handoff files that point back to `.claude/`
- generated projects keep heavy overlap across `CLAUDE.md`, `GEMINI.md`, `AGENTS.md`, and `.codex/manifest.md` so the same workflow rules survive provider changes
- `src/` stays intentionally minimal because this is a starter template, not a bundled application
- scope memory defaults to SQLite and lives under `.claude/state/`, which is ignored by git
- the tooling still accepts legacy `.codex/state/` and `.codex/exports/` paths during migration
- the `model_provider` Copier answer selects whether generated runtime defaults target Anthropic Claude or Google Gemini; Codex/OpenAI support remains compatibility-only

Recommended first-time path:

```bash
python tools/create_project.py ../my-new-project
```

This helper expects `uv` to be installed in the environment running the command.
By default it uses Copier defaults for reliability; pass `--interactive` if you want prompts.

What the helper does:
- resolves the destination path before copying
- refuses to write into this template repo
- refuses to write into a non-empty existing directory unless you explicitly override it
- runs `uv tool run copier copy --trust ...` for you
- uses `--defaults` automatically when there is no interactive TTY

If you want to render manually with Copier instead:

```bash
uv tool install copier
copier copy --trust . ../my-new-project
```

If you want the helper but still want prompts:

```bash
python tools/create_project.py --interactive ../my-new-project
```

Important: Copier will write into an existing destination directory if you point it at one. If you want the safer behavior, use `tools/create_project.py`.

The generated project includes:
- adaptive review scope: changed files for small edits, full-repo review for milestone changes
- a root `CLAUDE.md` that directs Claude into `.claude/` instead of consuming the whole repo by default
- a root `GEMINI.md` that directs Gemini CLI into `.claude/` instead of treating the whole repo as flat context
- compatibility `AGENTS.md` and `.codex/manifest.md` handoffs for AGENTS/Codex-style tools
- an opinionated README that explains the workflow and how to add reviewers
- provider-aware runtime config that can target Anthropic Claude or Google Gemini defaults at generation time
- enforced prompt overlap across the provider-facing entrypoints so the same read order, workflow loop, and safety rules are visible across all three frontier-lab surfaces
- explicit clarification that Codex/OpenAI support here is compatibility-surface support, not a third generated runtime provider
- optional Agent Lightning telemetry and dataset-export scaffolding for improving execution, review quality, review-mode recommendation, and remediation efficiency over time
- Copier post-copy bootstrap that installs the selected project Python, creates `.venv`, installs dev dependencies, initializes state, and installs pre-commit hooks

After generation, the trusted post-copy tasks already attempt to:
- install the selected Python with `uv python install`
- create `.venv`
- install dev dependencies with `uv sync --dev`
- initialize the local SQLite state files
- install pre-commit hooks if the new project already has its own `.git` directory

After generation, open the new project and run:

```bash
uv run python tools/run_full_test_suite.py
uv run python tools/run_pre_commit.py
```

If you ever need to rerun bootstrap manually:

```bash
uv python install 3.14
uv run --python 3.14 python tools/install_dev_dependencies.py --bootstrap --python-version 3.14
uv run python tools/init_scope_memory.py
uv run python tools/init_review_state.py
uv run python tools/install_pre_commit.py
```

If you chose a different Python version during project generation, replace `3.14` with that version.

If you cloned the generated project onto another machine, rerun that bootstrap sequence before development.

If you later want to turn on the optional Agent Lightning scaffolding for dev-workflow optimization:

```bash
uv sync --dev --group lightning
uv run python tools/init_lightning_telemetry.py
uv run python tools/record_lightning_trace.py sample_trace.json
uv run python tools/export_lightning_dataset.py
uv run python tools/purge_lightning_telemetry.py
```
