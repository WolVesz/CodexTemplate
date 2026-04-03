from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ROOT_ENTRYPOINTS = {
    "CLAUDE.md": ROOT / "CLAUDE.md",
    "GEMINI.md": ROOT / "GEMINI.md",
    "AGENTS.md": ROOT / "AGENTS.md",
    ".codex/manifest.md": ROOT / ".codex" / "manifest.md",
}
TEMPLATE_ENTRYPOINTS = {
    "template/CLAUDE.md.jinja": ROOT / "template" / "CLAUDE.md.jinja",
    "template/GEMINI.md.jinja": ROOT / "template" / "GEMINI.md.jinja",
    "template/AGENTS.md.jinja": ROOT / "template" / "AGENTS.md.jinja",
    "template/.codex/manifest.md.jinja": ROOT / "template" / ".codex" / "manifest.md.jinja",
}
ROOT_MANIFEST = ROOT / ".claude" / "manifest.md"
TEMPLATE_MANIFEST = ROOT / "template" / ".claude" / "manifest.md.jinja"
SHARED_HEADINGS = (
    "Canonical Read Order",
    "Compatibility Surfaces",
    "Default Behavior",
    "Required Workflow",
    "Non-Negotiable Rules",
)


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def extract_section(text: str, heading: str) -> str:
    start_marker = f"## {heading}\n"
    start = text.index(start_marker)
    next_heading = text.find("\n## ", start + len(start_marker))
    if next_heading == -1:
        next_heading = len(text)
    return text[start:next_heading].strip()


def parse_numbered_items(text: str, heading: str) -> list[str]:
    section = extract_section(text, heading)
    items: list[str] = []
    for line in section.splitlines()[1:]:
        stripped = line.strip()
        if not stripped:
            continue
        number, _, remainder = stripped.partition(". ")
        if not number.isdigit() or not remainder:
            break
        items.append(remainder)
    return items


def assert_family_parity(name: str, paths: dict[str, Path]) -> None:
    texts = {label: read_text(path) for label, path in paths.items()}
    for heading in SHARED_HEADINGS:
        sections = {label: extract_section(text, heading) for label, text in texts.items()}
        if len(set(sections.values())) != 1:
            details = "\n\n".join(f"[{label}]\n{section}" for label, section in sections.items())
            raise SystemExit(f"{name} drifted in section '{heading}'.\n\n{details}")


def assert_manifest_alignment(
    provider_paths: dict[str, Path], manifest_path: Path, family_name: str, expected_manifest_heading: str
) -> None:
    provider_text = read_text(next(iter(provider_paths.values())))
    manifest_text = read_text(manifest_path)
    provider_read_order = parse_numbered_items(provider_text, "Canonical Read Order")
    manifest_read_order = parse_numbered_items(manifest_text, expected_manifest_heading)
    if manifest_read_order != provider_read_order[1:]:
        raise SystemExit(
            f"{family_name} manifest read order drifted from provider entrypoints.\n\n"
            f"Provider read order tail:\n{provider_read_order[1:]}\n\nManifest read order:\n{manifest_read_order}"
        )


def main() -> None:
    assert_family_parity("Root provider entrypoints", ROOT_ENTRYPOINTS)
    assert_family_parity("Template provider entrypoints", TEMPLATE_ENTRYPOINTS)
    assert_manifest_alignment(ROOT_ENTRYPOINTS, ROOT_MANIFEST, "Root", "Read Order")
    assert_manifest_alignment(TEMPLATE_ENTRYPOINTS, TEMPLATE_MANIFEST, "Template", "Read Order")


if __name__ == "__main__":
    main()
