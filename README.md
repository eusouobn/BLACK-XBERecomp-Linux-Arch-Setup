# BLACK-XBERecomp-Linux - Arch Linux Setup Script

A simple automated script to build [BLACK-XBERecomp-Linux](https://github.com/datfooldive/BLACK-XBERecomp-Linux) natively on Arch Linux. 

This setup will:
- Install all required dependencies via `pacman`
- Clone the Linux fork of BLACK-XBERecomp
- Automatically detect and copy your extracted Black (2006) game files
- Build the game natively with Vulkan (no Wine/Proton/DXVK required)

## Requirements

- Arch Linux (or Arch-based distro like EndeavourOS, Garuda)
- A legally acquired copy of **Black (2006)** for the original Xbox (USA or EU release)
- Extracted game files containing `default.xbe`

## Usage

1. Clone this repo

```bash
git clone https://github.com/eusouobn/BLACK-XBERecomp-Linux-Arch-Setup.git
cd BLACK-XBERecomp-Linux-Arch-Setup
```

2. Make the script executable and run it

```bash
chmod +x scripts/build-black-xberecomp-linux.sh
./scripts/build-black-xberecomp-linux.sh
```

3. Follow the prompts. The first build can take **15 - 60 minutes** depending on your CPU.

4. Launch the game

```bash
cd ~/BLACK-XBERecomp-Linux
./out/build/release/black
```

## Notes

- **Game files required**: This repo does **not** contain any game assets. You must provide your own extracted files from a legally acquired copy.
- **Native Vulkan**: This uses the Linux port by [datfooldive](https://github.com/datfooldive), running natively with SDL3 + Vulkan.
- **Settings**: Press `F10` in-game to open the settings overlay.
- **Saves/Config**: `hdd/`, `black.toml` and logs are created next to the executable.
- **Wayland/X11**: Fully supported.

## Credits & Sources

- [TGP482/BLACK-XBERecomp](https://github.com/TGP482/BLACK-XBERecomp) - Original Windows project
- [datfooldive/BLACK-XBERecomp-Linux](https://github.com/datfooldive/BLACK-XBERecomp-Linux) - Linux port
- [TGP482/XboxXBE-Recomp](https://github.com/TGP482/XboxXBE-Recomp) - Xbox XBE Recompilation tool
- [SDL3](https://github.com/libsdl-org/SDL) - Cross-platform input/windowing/audio
- [Vulkan](https://www.vulkan.org/) - Graphics API
- [Google Shaderc](https://github.com/google/shaderc) - Shader compilation
- [LLVM/Clang](https://llvm.org/) - Compiler toolchain
- [Official Discord](https://discord.gg/8dAn4ZSsap)

**Game:** *Black (2006)* - Developed by Criterion Games, Published by Electronic Arts
