{ pkgs, ... }:

# User-level settings (shell, editor, apps, dotfiles). System packages stay
# in modules/; this file is what home-manager applies for hifzhil.
{
  home.username = "hifzhil";
  home.homeDirectory = "/home/hifzhil";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  programs.bash.enable = true;

  home.packages = with pkgs; [
    # Desktop shell
    quickshell

    # Hyprland
    hyprpaper
    hyprlock
    hypridle

    # Launcher
    fuzzel

    # Clipboard
    wl-clipboard
    cliphist

    # File manager
    yazi

    # Browser
    brave

    # Screenshots
    grim
    slurp
    ];
  }
