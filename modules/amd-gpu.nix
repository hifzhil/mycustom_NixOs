{ pkgs, ... }:

# RX 9070 XT (RDNA4 / gfx1201). Display/Vulkan via Mesa RADV is the safe
# baseline on nixos-unstable. ROCm/HIP/AI is a moving target — enable the
# commented block only after you confirm the current nixpkgs ROCm build
# lists gfx1201 (rocminfo, clinfo). Do not use HSA_OVERRIDE_GFX_VERSION.
{
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.amdgpu.initrd.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.variables.AMD_VULKAN_ICD = "RADV";

  # --- verify before enabling (ROCm / OpenCL / HIP) ---
  # hardware.amdgpu.opencl.enable = true;
  # nixpkgs.config.rocmSupport = true;
  # environment.systemPackages = with pkgs; [ rocmPackages.rocminfo clinfo ];
  # systemd.tmpfiles.rules = [
  #   "L+ /opt/amdgpu/share/libdrm/amdgpu.ids - - - - ${pkgs.libdrm}/share/libdrm/amdgpu.ids"
  # ];
}
