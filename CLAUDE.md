# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a top-level coordination workspace containing three Git submodules:

- `Cbit2d/` — the shared 2D game engine/library (primary active target)
- `SharkCardGame/` — a card game that consumes `Cbit2d`
- `GameOfLife/` — another game that consumes `Cbit2d`

`Cbit2d/` is the primary integration target. `SharkCardGame/` and `GameOfLife/` lag behind the current engine version — do not treat them as authoritative examples of current Cbit2D integration patterns.

## Submodule Workflow

Changes inside a submodule must be committed inside that submodule first. Then the parent repo must commit the updated submodule pointer.

```bash
# Initialize all submodules after cloning
git submodule update --init --recursive

# Update a submodule to latest
cd Cbit2d && git pull
```

## Build and Run (Pop!_OS Linux)

Full setup instructions are in `docs/Building And Running in Pop OS linux.md`. Summary:

**Prerequisites:** CMake 4.2+, Ninja, vcpkg at `~/.local/share/vcpkg`, and system packages (X11/Wayland dev libs, ALSA/PulseAudio). See the doc for the full `apt install` list.

**Set vcpkg env:**
```bash
export VCPKG_ROOT="$HOME/.local/share/vcpkg"
export PATH="$VCPKG_ROOT:$PATH"
```

**Use the helper script (recommended):**
```bash
scripts/build-and-run-shark-card-game.sh           # configure, build, run
scripts/build-and-run-shark-card-game.sh --clean   # wipe build dir first
scripts/build-and-run-shark-card-game.sh --no-run  # build only
scripts/build-and-run-shark-card-game.sh --sdl-driver x11      # force X11
scripts/build-and-run-shark-card-game.sh --sdl-driver wayland  # force Wayland
```

**Manual configure/build/run:**
```bash
# Configure (never use the checked-in CMake preset on Linux — it has a Windows vcpkg path)
cmake \
  -S SharkCardGame \
  -B SharkCardGame/cmake-build-debug \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"

cmake --build SharkCardGame/cmake-build-debug

# Run from build dir so the copied resources/ folder is found
cd SharkCardGame/cmake-build-debug && ./SharkCardGame
```

**SDL display fallback:**
```bash
SDL_VIDEO_DRIVER=x11 ./SharkCardGame      # or
SDL_VIDEO_DRIVER=wayland ./SharkCardGame
```

If SDL backends are missing, rebuild vcpkg SDL packages after installing the system dev libs:
```bash
"$VCPKG_ROOT/vcpkg" remove sdl3 sdl3-image sdl3-ttf --recurse
"$VCPKG_ROOT/vcpkg" install --triplet x64-linux --x-manifest-root=SharkCardGame
```

## Cbit2d Engine Architecture

`Cbit2d/` builds two CMake targets:

- `cbit2d` — the reusable engine library (consumed via `cbit2d::cbit2d`)
- `Cbit2dSandbox` — a thin validation/smoke-test executable; not the primary product

**Public API** is under `Cbit2d/include/cbit/` organized by module:

| Module | Headers |
|--------|---------|
| `core` | `application.hpp`, `audio_service.hpp`, `input.hpp`, `logger.hpp`, `scene.hpp`, `scene_manager.hpp` |
| `ecs` | `components.hpp`, `entity_component_system.hpp`, `game_object.hpp`, `drag_system.hpp`, `sprite_animation_system.hpp`, `sprite_render_system.hpp`, `ui_system.hpp` |
| `assets` | `tile_map.hpp` |

Implementations live under `Cbit2d/src/` mirroring the same module structure.

**Game-side consumption** (as used in `SharkCardGame/CMakeLists.txt`):
```cmake
add_subdirectory(../Cbit2d ${CMAKE_BINARY_DIR}/Cbit2d-build)
target_link_libraries(MyGame PRIVATE cbit2d::cbit2d)
```

**Dependencies** (resolved via vcpkg): SDL3 (x11+wayland features, no ibus), SDL3_image (png), SDL3_ttf, EnTT, fmt, glm, simdjson, spdlog.

## Code Conventions (Cbit2d)

- Namespace: `cbit2d` — do not use `cbit` as the root namespace
- Private member variables: prefix with `_`
- Every `.hpp` and `.cpp` file must have a Doxygen file header:

```cpp
/**
 * @file    FileName.hpp
 * @brief   One-line description.
 * @details Longer description.
 * @author  Nur Akmal bin Jalil
 * @date    YYYY-MM-DD
 */
```

- Method definitions require Doxygen-style comment blocks (`@brief`, `@param`, `@return`, `@details`)
- C++20; `CMAKE_CXX_STANDARD 20`

## Scope Rules

- Work in `Cbit2d/` by default unless the task explicitly targets a game submodule.
- Do not copy engine code into the parent repo or into game repos — consume via CMake `add_subdirectory`.
- Do not put game-specific rules or content into engine modules.
- Keep the `Cbit2dSandbox` app thin — it exists only to exercise the engine, not to grow into game logic.
