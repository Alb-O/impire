# Zoxide feature - smarter cd with jump navigation
{ ... }:
{
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd"
      "cd"
    ];
  };
}
