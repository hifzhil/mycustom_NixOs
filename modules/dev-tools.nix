{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    git
    zed
  ];

  programs.git = {
    enable = true;

    userName = "hifzhil";
    userEmail = "hifzhil12@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
