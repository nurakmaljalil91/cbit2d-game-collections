# Building And Running SharkCardGame On Pop!_OS Linux

This guide explains how to build and run `SharkCardGame` from a fresh clone of the parent `cbit2d-game-collections` repository on Pop!_OS Linux.

The game is a CMake project inside the `SharkCardGame/` submodule. It links the shared engine from `../Cbit2d` through CMake, so build from the parent workspace and keep the submodules initialized.

## 1. Install System Tools

Install the basic compiler and build tools:

```bash
sudo apt update
sudo apt install -y \
  build-essential \
  git \
  ninja-build \
  curl \
  zip \
  unzip \
  tar \
  pkg-config \
  libx11-dev \
  libxext-dev \
  libxft-dev \
  libxcursor-dev \
  libxrandr-dev \
  libxi-dev \
  libxinerama-dev \
  libxss-dev \
  libxtst-dev \
  libxkbcommon-dev \
  libwayland-dev \
  wayland-protocols \
  libdecor-0-dev \
  libibus-1.0-dev \
  libdbus-1-dev \
  libudev-dev \
  libasound2-dev \
  libpulse-dev \
  libpipewire-0.3-dev \
  libegl1-mesa-dev \
  libgl1-mesa-dev
```

## 2. Install CMake 4.2 Or Newer

`Cbit2d/CMakeLists.txt` currently requires CMake `4.2` or newer.

Pop!_OS or Ubuntu packages may provide an older CMake version. Check first:

```bash
cmake --version
```

If the version is older than `4.2`, install a newer CMake before configuring the project. A Kitware apt package or an official CMake binary release are both reasonable options.

Remove the old version (optional but to prevent conflict)

```bash
sudo apt remove cmake
```
Add the kitware signing key:

```bash
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
```
Add the repository to your source:

```bash
echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
```

Update and install cmake:

```bash
sudo apt update
sudo apt install -y cmake
```
Verify again after installing:

```bash
cmake --version
```

Expected version:

```text
cmake version 4.2.x
```

## 3. Install vcpkg

The project dependencies are declared through `vcpkg.json` files in `SharkCardGame/` and `Cbit2d/`.

Install vcpkg locally:

```bash
git clone https://github.com/microsoft/vcpkg.git ~/.local/share/vcpkg
~/.local/share/vcpkg/bootstrap-vcpkg.sh
```

Set the environment variables for the current terminal:

```bash
export VCPKG_ROOT="$HOME/.local/share/vcpkg"
export PATH="$VCPKG_ROOT:$PATH"
```

To make this permanent, add those two `export` lines to your shell profile, such as `~/.bashrc` or `~/.zshrc`.

## 4. Initialize Submodules

From the parent repository:

```bash
cd /home/amal/Development/cbit2d-game-collections
git submodule update --init --recursive
```

If you cloned somewhere else, replace the `cd` path with your local clone path.

## 5. Configure SharkCardGame

After the required packages, CMake, and vcpkg are installed, you can use the helper script from the parent repository to configure, build, and run the game:

```bash
scripts/build-and-run-shark-card-game.sh
```

Use `--clean` to delete and recreate the build directory:

```bash
scripts/build-and-run-shark-card-game.sh --clean
```

Use `--no-run` to configure and build without launching the game:

```bash
scripts/build-and-run-shark-card-game.sh --no-run
```

You can also force a specific SDL3 video backend when running:

```bash
scripts/build-and-run-shark-card-game.sh --sdl-driver x11
scripts/build-and-run-shark-card-game.sh --sdl-driver wayland
```

The manual configure/build/run commands are listed below for reference.

Do not use the checked-in `debug` CMake preset on Linux. It currently points to a Windows CLion vcpkg path.

Configure manually with the Linux vcpkg toolchain:

```bash
cmake \
  -S SharkCardGame \
  -B SharkCardGame/cmake-build-debug \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"
```

During configure, vcpkg should install the required dependencies, including SDL3, SDL3_image, SDL3_ttf, spdlog, EnTT, glm, simdjson, and fmt.

The manifests request SDL3 with `x11` and `wayland` support but without the default `ibus` feature. This avoids static-link failures from unresolved `SDL_IBus_*` symbols on the current Linux vcpkg/SDL3 setup.

If SDL3 was already built before the Linux X11/Wayland development packages were installed, rebuild the vcpkg SDL packages:

```bash
"$VCPKG_ROOT/vcpkg" remove sdl3 sdl3-image sdl3-ttf --recurse
"$VCPKG_ROOT/vcpkg" install --triplet x64-linux --x-manifest-root=SharkCardGame
```

Then delete and reconfigure the CMake build directory:

```bash
rm -rf SharkCardGame/cmake-build-debug
cmake \
  -S SharkCardGame \
  -B SharkCardGame/cmake-build-debug \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"
```

## 6. Build

```bash
cmake --build SharkCardGame/cmake-build-debug
```

## 7. Run

Run from the build directory so the copied `resources/` folder is found:

```bash
cd SharkCardGame/cmake-build-debug
./SharkCardGame
```

## Troubleshooting

### CMake Version Error

If configure fails with a message like:

```text
CMake 4.2 or higher is required
```

Install a newer CMake and re-run the configure command.

### Windows vcpkg Path Error

If CMake tries to use a path like:

```text
C:/Users/User/.vcpkg-clion/vcpkg/scripts/buildsystems/vcpkg.cmake
```

you are using the Windows preset. Configure manually with:

```bash
-DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"
```

### SDL Display Error Under Wayland

If the executable starts but SDL cannot create a window, try forcing X11:

```bash
cd SharkCardGame/cmake-build-debug
SDL_VIDEO_DRIVER=x11 ./SharkCardGame
```

Or force Wayland:

```bash
cd SharkCardGame/cmake-build-debug
SDL_VIDEO_DRIVER=wayland ./SharkCardGame
```

If both commands fail with messages like `x11 not available` or `wayland not available`, SDL3 was built without those video backends. Install the Linux development packages from step 1, rebuild the vcpkg SDL packages, then reconfigure and rebuild the game.

You can check whether the executable contains real display backends with:

```bash
strings SharkCardGame | grep -Ei 'X11_CreateDevice|Wayland_CreateDevice|DUMMY_bootstrap|OFFSCREEN_bootstrap'
```

### Missing Resources

If textures, fonts, or audio are missing, make sure you run the executable from:

```text
SharkCardGame/cmake-build-debug
```

The game CMake file copies `SharkCardGame/resources/` into the build directory during configure/build.
