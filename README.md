# mycustom_NixOs

Single-host flake for **nixxy**. Layout matches a typical multi-host repo, scaled down to one machine.

```
flake.nix + flake.lock     pins nixpkgs + home-manager
hosts/desktop/             hardware, boot, disks, hostname, user
modules/                   reusable: GPU, desktop, dev, AI
home/                      user apps / dotfiles (home-manager)
```

Grey in the diagram: inputs and tooling. Purple: config you write. Green: hardware-specific.

## First boot

On the machine (or from `/mnt` during install):

```bash
nix flake update          # creates flake.lock; re-check GPU/ROCm after this
sudo nixos-rebuild switch --flake .#nixxy
```

Replace `hosts/desktop/hardware-configuration.nix` with a fresh scan on the real disk layout:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/desktop/hardware-configuration.nix
```

Set a password: `sudo passwd hifzhil`.

`system.copySystemConfiguration` is a channel-era option and is not used here. The flake *is* the source of truth.

## RX 9070 XT (RDNA4)

The flake tracks **nixos-unstable** so kernel + Mesa stay new enough for gfx1201. After each `nix flake update`:

```bash
uname -r
glxinfo -B          # Mesa
vulkaninfo --summary
# only if you uncomment ROCm in modules/amd-gpu.nix:
rocminfo | grep -i gfx
clinfo
```

Display/Vulkan (RADV) is enabled. ROCm/OpenCL/HIP is commented until you confirm gfx1201 on that pin. Do not set `HSA_OVERRIDE_GFX_VERSION`.

VirtualBox guest tools live in `modules/vbox-guest.nix` and are **not** imported on the physical box.

## Dev shells (not NixOS modules)

Buildroot and Yocto do not belong in the system closure.

```bash
nix develop .#buildroot   # FHS env via buildFHSEnv
nix develop .#yocto       # prints a crops/poky docker invocation
```

## Adding a second machine later

Copy `hosts/desktop` to `hosts/<name>`, give it its own `hardware-configuration.nix`, and add another `nixosConfigurations.<name>` entry in `flake.nix`. Reuse `modules/` as-is.
