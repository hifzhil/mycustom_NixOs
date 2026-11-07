{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/amd-gpu.nix
    ../../modules/desktop.nix
    ../../modules/dev-tools.nix
    ../../modules/ai.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixxy";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  users.mutableUsers = false;
  users.users.hifzhil = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Ahmad Hifzhil Burhan";
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
    ]; 
  };
  
  system.stateVersion = "26.05";
}
