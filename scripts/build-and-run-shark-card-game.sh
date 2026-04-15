#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
GAME_DIR="${REPO_ROOT}/SharkCardGame"
BUILD_DIR="${GAME_DIR}/cmake-build-debug"
BUILD_TYPE="Debug"
RUN_GAME=1
CLEAN_BUILD=0
SDL_DRIVER=""

usage() {
  cat <<'USAGE'
Usage: scripts/build-and-run-shark-card-game.sh [options]

Options:
  --clean                 Delete SharkCardGame/cmake-build-debug before configuring.
  --no-run                Configure and build only.
  --sdl-driver <driver>   Run with an explicit SDL3 video driver, such as x11 or wayland.
  -h, --help              Show this help text.

Examples:
  scripts/build-and-run-shark-card-game.sh
  scripts/build-and-run-shark-card-game.sh --clean
  scripts/build-and-run-shark-card-game.sh --sdl-driver x11
USAGE
}

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

version_at_least() {
  local actual="$1"
  local required="$2"
  [[ "$(printf '%s\n%s\n' "${required}" "${actual}" | sort -V | head -n1)" == "${required}" ]]
}

cmake_version() {
  cmake --version | awk 'NR == 1 { print $3 }'
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --clean)
      CLEAN_BUILD=1
      shift
      ;;
    --no-run)
      RUN_GAME=0
      shift
      ;;
    --sdl-driver)
      [[ $# -ge 2 ]] || fail "--sdl-driver requires a value"
      SDL_DRIVER="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown option: $1"
      ;;
  esac
done

require_command git
require_command cmake
require_command ninja

ACTUAL_CMAKE_VERSION="$(cmake_version)"
if ! version_at_least "${ACTUAL_CMAKE_VERSION}" "4.2"; then
  fail "CMake 4.2 or newer is required; found ${ACTUAL_CMAKE_VERSION}"
fi

if [[ -z "${VCPKG_ROOT:-}" ]]; then
  if [[ -d "${HOME}/.local/share/vcpkg" ]]; then
    export VCPKG_ROOT="${HOME}/.local/share/vcpkg"
  else
    fail "VCPKG_ROOT is not set and ${HOME}/.local/share/vcpkg does not exist"
  fi
fi

VCPKG_TOOLCHAIN="${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
[[ -f "${VCPKG_TOOLCHAIN}" ]] || fail "vcpkg toolchain file not found: ${VCPKG_TOOLCHAIN}"

[[ -f "${GAME_DIR}/CMakeLists.txt" ]] || fail "SharkCardGame submodule is missing or not initialized"
[[ -f "${REPO_ROOT}/Cbit2d/CMakeLists.txt" ]] || fail "Cbit2d submodule is missing or not initialized"

printf 'Initializing submodules...\n'
git -C "${REPO_ROOT}" submodule update --init --recursive

if [[ "${CLEAN_BUILD}" -eq 1 ]]; then
  printf 'Removing existing build directory: %s\n' "${BUILD_DIR}"
  rm -rf "${BUILD_DIR}"
fi

printf 'Configuring SharkCardGame...\n'
cmake \
  -S "${GAME_DIR}" \
  -B "${BUILD_DIR}" \
  -G Ninja \
  -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
  -DCMAKE_TOOLCHAIN_FILE="${VCPKG_TOOLCHAIN}"

printf 'Building SharkCardGame...\n'
cmake --build "${BUILD_DIR}"

if [[ "${RUN_GAME}" -eq 1 ]]; then
  printf 'Running SharkCardGame...\n'
  cd "${BUILD_DIR}"

  if [[ -n "${SDL_DRIVER}" ]]; then
    SDL_VIDEO_DRIVER="${SDL_DRIVER}" ./SharkCardGame
  else
    ./SharkCardGame
  fi
fi
