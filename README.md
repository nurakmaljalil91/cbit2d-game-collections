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
