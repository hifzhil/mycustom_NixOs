# Channel-style entry point, kept only as a pointer.
# This repo is a flake. Do not nixos-rebuild this file.
#
#   sudo nixos-rebuild switch --flake .#nixxy
#
# Host:    hosts/desktop
# Modules: modules/
# Home:    home/hifzhil.nix

{ ... }:
{
  imports = [ ./hosts/desktop ];
}
