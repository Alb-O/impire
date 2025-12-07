# Shared home-manager profile - CLI tooling and essentials
# Works everywhere: desktop, WSL, VM
# Consolidates all shared feature modules into a single import
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.mod.hm.features.shared.essential
    registry.mod.hm.features.shared.cli
    registry.mod.hm.features.shared.fish
    registry.mod.hm.features.shared.sops
    registry.mod.hm.features.shared.ssh
    registry.mod.hm.features.shared.fonts
    registry.mod.hm.features.shared.git
    registry.mod.hm.features.shared.zoxide
    registry.mod.hm.features.shared.fzf
    registry.mod.hm.features.shared.tmux
    registry.mod.hm.features.shared.lazygit
    registry.mod.hm.features.shared.neovim
    registry.mod.hm.features.shared.xdg
    registry.mod.hm.features.shared.yazi
    registry.mod.hm.features.shared.codex
    registry.mod.hm.features.shared.lsp
    registry.mod.hm.features.shared.mcp
    registry.mod.hm.features.shared.nh
    registry.mod.hm.features.shared.opencode
  ];
}
