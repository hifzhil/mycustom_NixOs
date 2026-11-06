{ pkgs, ... }:

# Keep this thin until ROCm on gfx1201 is verified on this nixpkgs pin.
# Display works without this module; AI runtimes do not.
{
  environment.systemPackages = with pkgs; [
    python3
  ];

  # After rocminfo shows gfx1201, add e.g.:
  # services.ollama.enable = true;
  # services.ollama.acceleration = "rocm";
}
