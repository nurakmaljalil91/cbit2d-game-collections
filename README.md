# cbit2d-game-collections

This repository is the coordination repo for a collection of games built with the Cbit2D library.

It is structured around:

- `Cbit2d/`: the shared Cbit2D library, tracked as a Git submodule
- `SharkCardGame/`: a game project that will consume Cbit2D
- `GameOfLife/`: another game project that will consume Cbit2D

At the moment, this repository is primarily intended to:

- keep the engine library and related game projects in one place
- provide a single entry point for cloning the full workspace
- make it easier to evolve the shared library and then update each game against it

## Repository Status

`Cbit2d/` is the active shared library submodule.

`SharkCardGame/` and `GameOfLife/` are present as submodules, but they are not yet updated to use the latest Cbit2D library. Until that migration happens, treat them as existing projects under integration rather than current examples of the latest setup.

## Clone The Repository

Clone the repo together with all submodules:

```powershell
git clone --recurse-submodules <repo-url>
cd cbit2d-game-collections
```

If you already cloned the repo without submodules, initialize them with:

```powershell
git submodule update --init --recursive
```

## Build And Run SharkCardGame On Pop!_OS Linux

For Pop!_OS Linux setup, dependency installation, CMake configuration, build, and run commands, see:

```text
docs/Building And Running in Pop OS linux.md
```

Important Linux notes:

- The checked-in `SharkCardGame` CMake preset currently points to a Windows CLion vcpkg path.
- Configure manually with a Linux vcpkg toolchain file.
- `Cbit2d` currently requires CMake `4.2` or newer.

After the required Pop!_OS packages, CMake, and vcpkg are installed, the helper script can configure, build, and run the game:

```bash
scripts/build-and-run-shark-card-game.sh
```

Useful options:

```bash
scripts/build-and-run-shark-card-game.sh --clean
scripts/build-and-run-shark-card-game.sh --no-run
scripts/build-and-run-shark-card-game.sh --sdl-driver x11
scripts/build-and-run-shark-card-game.sh --sdl-driver wayland
```

## Update Submodules

To fetch the latest commits referenced by this repository:

```powershell
git submodule update --init --recursive
```

To pull the latest remote changes inside each submodule manually, enter the submodule and use normal Git commands there:

```powershell
cd Cbit2d
git pull
```

Repeat that pattern for other submodules only when you intentionally want to advance them.

## Working Model

This repo is intended to act as the main workspace for:

1. the shared Cbit2D library
2. multiple game repositories that depend on it

Typical workflow:

1. make or pull changes in `Cbit2d/`
2. update a game project to consume those changes
3. verify the game still builds and runs
4. commit the updated submodule pointers in this top-level repository

## Notes

- Submodules are pinned to specific commits by the parent repository.
- Changes made inside a submodule are not fully recorded by the parent repo until you commit inside the submodule and then commit the updated submodule pointer here.
- If a submodule appears as modified, that usually means its checked out commit differs from the commit recorded by this repository.

## Current Scope

For now, the top-level documentation and repo structure are the main source of truth here.

Until `SharkCardGame/` and `GameOfLife/` are updated for the latest Cbit2D version, avoid assuming their current integration reflects the desired long-term project layout.

## Repo-Local Skills

This repository includes repo-local Codex skills under `.codex/skills/`:

- `engine-cpp20`: reusable engine and library work in `Cbit2d/`
- `gameplay-cpp20`: gameplay, ECS, and game-rule work in game repositories

These skills are stored in the repo so the prompting conventions and boundaries stay versioned with the workspace.

## Prompting These Skills

Use an explicit path when prompting repo-local skills:

```text
Use $engine-cpp20 at .codex/skills/engine-cpp20 to refactor the Cbit2d renderer API for cleaner SDL3 boundaries.
```

```text
Use $gameplay-cpp20 at .codex/skills/gameplay-cpp20 to implement turn resolution with focused EnTT systems.
```

You can also use absolute paths if needed:

```text
Use $engine-cpp20 at C:\Users\User\Developments\cbit2d-game-collections\.codex\skills\engine-cpp20 to review the asset manager design.
```

## Prompting Separate Engine And Gameplay Agents

When splitting work across subagents, keep ownership explicit:

- Engine agent: owns `Cbit2d/`, engine APIs, rendering, resources, and platform/runtime code
- Gameplay agent: owns game-side ECS, scenes, rules, and feature logic

Recommended engine prompt:

```text
Use $engine-cpp20 at .codex/skills/engine-cpp20. Work only in Cbit2d unless explicitly told otherwise. Optimize for reusable engine/library architecture, stable APIs, explicit ownership, clean SDL3 boundaries, and maintainable modern C++20. Do not introduce game-specific rules or content into engine modules.
```

Recommended gameplay prompt:

```text
Use $gameplay-cpp20 at .codex/skills/gameplay-cpp20. Work in the game repository unless explicitly told otherwise. Optimize for gameplay behavior, clear ECS structure, explicit update order, and maintainable modern C++20. Consume engine APIs cleanly. Do not redesign engine internals unless an interface gap blocks the task.
```

If a task crosses both layers, define or adjust the engine-facing interface first, then let gameplay integrate against it.
