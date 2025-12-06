# Albert's Home Manager configuration
# Base user config - imported by both desktop and wsl hosts
{
  registry,
  imp,
  lib,
  ...
}:
{
  imports = imp.imports [
    registry.modules.home.base
    registry.modules.home.features.essential
    registry.modules.home.features.cli
    registry.modules.home.features.fish
    registry.modules.home.features.sops
    registry.modules.home.features.ssh
    registry.modules.home.features.fonts
    registry.modules.home.features.git
    registry.modules.home.features.zoxide
    registry.modules.home.features.fzf
    registry.modules.home.features.tmux
    registry.modules.home.features.lazygit
    registry.modules.home.features.kitty
    registry.modules.home.features.kakoune
    registry.modules.home.features.neovim
    registry.modules.home.features.zed
    registry.modules.home.features.xdg
    registry.modules.home.features.yazi
    registry.modules.home.features.firefox
    registry.modules.home.features.opencode

    # Universal tools
    registry.modules.home.features.lsp
    registry.modules.home.features.mcp
    registry.modules.home.features.mpv
    registry.modules.home.features.nh

    # Desktop-only (graphical session)
    registry.modules.home.features.clipboard
    registry.modules.home.features.gtk
    registry.modules.home.features.niri
    registry.modules.home.features.polkit
  ];

  # User identity
  home = {
    username = "albert";
    homeDirectory = "/home/albert";
    stateVersion = "24.05";
  };

  # Sops secrets configuration
  sops.defaultSopsFile = ./secrets.yaml;

  # Git identity
  programs.git.settings.user = {
    name = lib.mkDefault "Albert O'Shea";
    email = lib.mkDefault "albertoshea2@gmail.com";
  };
}
