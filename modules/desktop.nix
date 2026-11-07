{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    options = "eurosign:e,caps:escape";
  };

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "hifzhil";

  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
     kitty
     fastfetch
     wget
     curl 
  ];
  
  # Peristent files for machine id so systemd could now the state of my pc machine
  environment.etc."machine-id".source = "/nix/persist/etc/machine-id";

}
