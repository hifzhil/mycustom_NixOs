# my-nixxy

Single-host NixOS flake for **nixxy**.

A simple, modular configuration for an existing NixOS installation.

## Repository structure

```text
my-nixxy/
├── flake.nix
├── flake.lock
├── hosts/
│   └── desktop/
│       ├── default.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── amd-gpu.nix
│   ├── desktop.nix
│   ├── dev-tools.nix
│   └── ai.nix
└── home/
    └── hifzhil.nix
```

- `flake.nix` — Flake entry point and system configuration.
- `hosts/desktop/` — Host-specific configuration.
- `modules/` — Reusable system modules.
- `home/` — Home Manager configuration.

## Existing installation

Copy the hardware configuration from your existing NixOS installation:

```bash
cp /etc/nixos/hardware-configuration.nix hosts/desktop/
```

## Build and switch

Run these commands from the repository root (the directory containing `flake.nix`):

```bash
cd ~/my-nixxy
sudo nixos-rebuild switch --flake .#nixxy
```

The flake is the source of truth. No channels or `system.copySystemConfiguration` are required.

## AMD GPU (RX 9070 XT)

The system uses `nixos-unstable` for newer kernel and Mesa support for the RDNA4 GPU (gfx1201).

- Mesa and RADV are enabled.
- ROCm, OpenCL and HIP remain disabled until compatibility is verified.
- Do not use `HSA_OVERRIDE_GFX_VERSION`.

After updating flake inputs, verify the graphics stack:

```bash
uname -r
glxinfo -B
vulkaninfo --summary
```

If ROCm is enabled later:

```bash
rocminfo | grep -i gfx
clinfo
```

## Development environments

Buildroot and Yocto are provided through development shells rather than system-wide NixOS modules.

```bash
nix develop .#buildroot
nix develop .#yocto
```
