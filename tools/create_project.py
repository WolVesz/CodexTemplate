from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]


def resolve_destination(raw_destination: str) -> Path:
    destination = Path(raw_destination).expanduser()
    if not destination.is_absolute():
        destination = (Path.cwd() / destination).resolve()
    return destination


def ensure_safe_destination(destination: Path, force_existing: bool) -> None:
    repo_root = REPO_ROOT.resolve()

    if destination == repo_root:
        raise SystemExit("Destination cannot be this template repository.")

    try:
        destination.relative_to(repo_root)
    except ValueError:
        pass
    else:
        raise SystemExit(
            "Destination must be outside this template repository. "
            "Choose a sibling or other external folder."
        )

    if destination.exists():
        if not destination.is_dir():
            raise SystemExit("Destination exists and is not a directory.")
        if any(destination.iterdir()) and not force_existing:
            raise SystemExit(
                "Destination already exists and is not empty. "
                "Use a new folder or pass --force-existing if you really want that behavior."
            )
    else:
        destination.parent.mkdir(parents=True, exist_ok=True)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Safely generate a new project from this Copier template."
    )
    parser.add_argument("destination", help="Path to the new project directory.")
    parser.add_argument(
        "--force-existing",
        action="store_true",
        help="Allow rendering into an existing directory, even if it is not empty.",
    )
    parser.add_argument(
        "--interactive",
        action="store_true",
        help="Allow Copier to prompt for answers instead of using defaults.",
    )
    args = parser.parse_args()

    destination = resolve_destination(args.destination)
    ensure_safe_destination(destination, args.force_existing)

    if shutil.which("uv") is None:
        raise SystemExit("`uv` is required for this helper. Install uv first and retry.")

    command = [
        "uv",
        "tool",
        "run",
        "copier",
        "copy",
        "--trust",
    ]
    if not args.interactive:
        command.append("--defaults")
    command.extend(
        [
        str(REPO_ROOT),
        str(destination),
        ]
    )
    raise SystemExit(subprocess.call(command))


if __name__ == "__main__":
    main()
