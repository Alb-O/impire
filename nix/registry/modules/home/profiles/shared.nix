# Shared home-manager profile - CLI tooling and essentials
# Works everywhere: desktop, WSL, VM
# Consolidates all shared feature modules into a single import
{ imp, registry, ... }:
{
  imports = imp.imports [
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
    registry.modules.home.features.shared.codex
    registry.modules.home.features.shared.lsp
    registry.modules.home.features.shared.mcp
    registry.modules.home.features.shared.nh
    registry.modules.home.features.shared.opencode
  ];
}
