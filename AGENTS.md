# AGENTS.md

## Repo Purpose

This repository is the top-level coordination workspace for:

- the shared `Cbit2d/` library submodule
- multiple game repositories that depend on that library

The parent repository mainly exists to keep the engine and game projects together in one clone and to track compatible submodule revisions.

## Current Structure

- `Cbit2d/`: primary shared library submodule
- `SharkCardGame/`: game submodule
- `GameOfLife/`: game submodule

## Important Scope Rules

- Treat `Cbit2d/` as the primary active integration target unless the task explicitly says otherwise.
- Ignore code inside `SharkCardGame/` and `GameOfLife/` by default for now.
- Do not treat `SharkCardGame/` or `GameOfLife/` as authoritative examples of the latest Cbit2D integration.
- Only modify those game submodules when the task explicitly requires updating them.

## Submodule Guidance

- This repository tracks submodules by commit, not by branch state.
- If you change code inside a submodule, commit the change inside that submodule first.
- After a submodule commit changes, the parent repository must also commit the updated submodule pointer.
- When cloning, use:

```powershell
git clone --recurse-submodules <repo-url>
```

- If submodules are missing after clone, use:

```powershell
git submodule update --init --recursive
```

## Working Expectations For Codex

- Prefer repo-level documentation, setup, and coordination changes unless asked to modify engine or game code.
- When a task concerns shared architecture or setup, start by checking whether it belongs in the parent repo or in `Cbit2d/`.
- Avoid making assumptions based on the current state of `SharkCardGame/` and `GameOfLife/`; they may lag behind the current library design.
- Preserve submodule boundaries. Do not copy library code into the parent repo.
- If build or usage instructions are added later, keep them aligned with the submodule-based workflow.
