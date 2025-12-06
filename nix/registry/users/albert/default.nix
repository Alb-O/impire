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

    # Shared - works everywhere (desktop, wsl, vm)
    registry.modules.home.features.shared.essential
    registry.modules.home.features.shared.cli
    registry.modules.home.features.shared.fish
    registry.modules.home.features.shared.sops
    registry.modules.home.features.shared.ssh
    registry.modules.home.features.shared.fonts
    registry.modules.home.features.shared.git
    registry.modules.home.features.shared.zoxide
    registry.modules.home.features.shared.fzf
    registry.modules.home.features.shared.tmux
    registry.modules.home.features.shared.lazygit
    registry.modules.home.features.shared.neovim
    registry.modules.home.features.shared.xdg
    registry.modules.home.features.shared.yazi
    registry.modules.home.features.shared.opencode
    registry.modules.home.features.shared.codex
    registry.modules.home.features.shared.lsp
    registry.modules.home.features.shared.mcp
    registry.modules.home.features.shared.nh

    # Desktop-only (graphical Linux session)
    registry.modules.home.features.desktop.blender
    registry.modules.home.features.desktop.clipboard
    registry.modules.home.features.desktop.firefox
    registry.modules.home.features.desktop.gtk
    registry.modules.home.features.desktop.helium
    registry.modules.home.features.desktop.kakoune
    registry.modules.home.features.desktop.kitty
    registry.modules.home.features.desktop.mpv
    registry.modules.home.features.desktop.mako
    registry.modules.home.features.desktop.niri
    registry.modules.home.features.desktop.polkit
    registry.modules.home.features.desktop.sillytavern
    registry.modules.home.features.desktop.vscode
    registry.modules.home.features.desktop.zed
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
