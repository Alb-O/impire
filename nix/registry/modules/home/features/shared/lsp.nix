# LSP feature - Language Server Protocol tooling
# Provides common language servers for development
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TypeScript/JavaScript
    nodePackages.typescript-language-server
    vscode-langservers-extracted # html, css, json, eslint
    
    # Web
    tailwindcss-language-server
    
    # Markdown
    marksman
    
    # Rust
    rust-analyzer
    
    # Nix
    nixd
    
    # Package versions
    package-version-server
  ];
}
